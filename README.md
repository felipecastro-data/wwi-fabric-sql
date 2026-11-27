# wwi-fabric-sql

Production-grade Microsoft Fabric project on the **Wide World Importers** sample: Fabric Warehouse, CI/CD (Dev → Staging → Prod), Ontology, Data Agent and a Fabric App dashboard.

> 🚧 Work in progress. Full documentation, metrics and screenshots are added at the end of the project.

## Layout

| Path | Content |
|---|---|
| `fabric/` | Fabric items synced from the `WWI Analytics [DEV]` workspace (Git integration) |
| `sql/` | T-SQL to create, load (COPY INTO from Microsoft's public WWI parquet) and verify `WWI_Warehouse` |
| `tests/` | Unit tests for the Claude data agent's read-only SQL guard |
| `docs/adr/` | Architecture Decision Records |
| `docs/images/` | Screenshots used in this README |

## Environments

| Stage | Workspace | Source |
|---|---|---|
| Dev | `WWI Analytics [DEV]` | Git-connected to `main` / `fabric/` |
| Staging | `WWI Analytics [STG]` | Deployment pipeline |
| Prod | `WWI Analytics [PROD]` | Deployment pipeline |

## Deployment pipeline

`WWI Analytics Pipeline` promotes items Development → Test → Production. Pipelines copy the warehouse schema but not its data, so each stage loads data with `sql/02_load_data.sql` and checks it with `sql/03_verify.sql` ([ADR-0002](docs/adr/0002-deployment-strategy.md)).

![Deployment pipeline with all three stages deployed](docs/images/deployment-pipeline-stages.png)

![Deployment history: Test and Production deployments succeeded](docs/images/deployment-pipeline-history.png)

## Ontology

`WWI_Ontology` (Fabric IQ Ontology, preview) puts a business layer over `WWI_Warehouse` for the Data Agent. It has 5 entity types (Customer, City, StockItem, Employee, Sale), each bound directly to a warehouse table. Sale has 4 bound relationships: `soldTo`, `deliveredTo`, `contains` and `soldBy`. Every entity type has a description and synonyms. The ontology copies no data and reads live from the warehouse ([ADR-0003](docs/adr/0003-ontology-design.md)).

![Full ontology: Sale linked to Customer, City, StockItem and Employee](docs/images/ontology-full-graph.png)

![Sale entity type: properties, key and description](docs/images/ontology-sale-entity.png)

![soldBy relationship bound SalespersonKey → EmployeeKey](docs/images/ontology-relationship-binding.png)

![Customer instances read live from the warehouse](docs/images/ontology-customer-instances.png)

The definition is synced to Git as TMDL (`fabric/WWI_Ontology.Ontology/`) and promoted with the same pipeline. Each stage binds to its own warehouse automatically.

![Ontology deployed to Production](docs/images/ontology-pipeline-prod.png)

## Data agent

A Fabric Data agent can't run on trial capacity, so the agent is **Claude Haiku 5.5 running inside a Fabric User Data Function** (`WWI_Agent_Functions`). Ask a question, and Claude writes read-only T-SQL. The function checks and runs it on `WWI_Warehouse`, and Claude answers from the rows. The Anthropic API key lives in Azure Key Vault and is read at runtime through a Fabric Key Vault connection ([ADR-0004](docs/adr/0004-claude-data-agent.md), source in [`function_app.py`](fabric/WWI_Agent_Functions.UserDataFunction/function_app.py)).

![ask_wwi: top 5 customers by profit](docs/images/agent-test-top-customers.png)

![ask_wwi: revenue and profit by year](docs/images/agent-test-revenue-by-year.png)

| Question | Model calls | Input tokens | Output tokens | Cost (USD) |
|---|---|---|---|---|
| What was total revenue and profit by year? | 2 | 3,335 | 483 | $0.000575 |

Claude's SQL for that question:

```sql
SELECT YEAR(InvoiceDateKey) AS SaleYear, SUM(TotalExcludingTax) AS Revenue, SUM(Profit) AS Profit
FROM dbo.fact_sale GROUP BY YEAR(InvoiceDateKey) ORDER BY SaleYear
```

The agent showed that all 50,150,843 sales in this sample are dated in **2000**: $36,186,702,997.75 revenue and $17,980,267,019.75 profit.

Setup in Fabric and Azure:

![User data functions item created in DEV](docs/images/agent-udf-created.png)

![Warehouse connection alias WWIWarehouse](docs/images/agent-udf-connection.png)

![Libraries: anthropic and azure-keyvault-secrets](docs/images/agent-udf-library.png)

![Key Vault kv-wwi-fabric-fc01 (RBAC, West US)](docs/images/agent-keyvault-created.png)

![Secret anthropic-api-key stored in Key Vault](docs/images/agent-keyvault-secret.png)

![new_user_fabric gets read-only Key Vault Secrets User](docs/images/agent-keyvault-role-fabric.png)

# ADR-0003: Hand-built ontology bound directly to the warehouse

- **Status:** Accepted
- **Date:** 2026-11-26

## Context
Phase 5 adds a Fabric Data Agent. The agent needs business context on top of the raw star schema: what a "customer" or a "sale" is, which keys join, and what words users will type. [Fabric IQ Ontology (preview)](https://learn.microsoft.com/en-us/fabric/iq/ontology/overview) provides that layer. It doesn't copy data: entity types bind to source tables. The item supports [Git integration](https://learn.microsoft.com/en-us/fabric/cicd/git-integration/intro-to-git-integration) and deployment pipelines.

## Options
1. **Build by hand in the UI, binding each entity type directly to a `WWI_Warehouse` table.**
2. **Generate it from a semantic model** ("Generate Ontology"). This needs a semantic model, which we don't have yet. Keys and relationship bindings still have to be fixed by hand afterwards.
3. **Let the Ontology agent build it** from a prompt. It's fast, but the decisions are hidden and harder to review.

## Decision
Option 1. `WWI_Ontology` lives in `WWI Analytics [DEV]` and reaches STG and PROD through `WWI Analytics Pipeline`.

| Entity type | Source table | Key | Notes |
|---|---|---|---|
| Customer | `dimension_customer` | CustomerKey | |
| City | `dimension_city` | CityKey | Location kept for "where" questions |
| StockItem | `dimension_stock_item` | StockItemKey | Decimal prices kept as Decimal |
| Employee | `dimension_employee` | EmployeeKey | |
| Sale | `fact_sale` | SaleKey | `InvoiceDateKey`/`DeliveryDateKey` renamed `InvoiceDate`/`DeliveryDate` |

Relationships, all from Sale, each bound to the join columns:

| Relationship | Target | Join |
|---|---|---|
| `soldTo` | Customer | `CustomerKey` → `CustomerKey` |
| `deliveredTo` | City | `CityKey` → `CityKey` |
| `contains` | StockItem | `StockItemKey` → `StockItemKey` |
| `soldBy` | Employee | `SalespersonKey` → `EmployeeKey` |

Rules applied:
- **No Date entity.** An entity key must be a string or an integer, and `dimension_date.Date` is a datetime. Dates are properties on Sale instead.
- **Housekeeping columns dropped:** `ValidFrom`, `ValidTo`, `LineageKey` and `Photo` (binary). They mean nothing to a business user or the agent.
- **Every entity type and relationship has a description**, and every entity type has synonyms (e.g. Employee: salesperson, sales rep). The descriptions also state that key `0` means "Unknown".

## Consequences
- The definition is TMDL in `fabric/WWI_Ontology.Ontology/`, so every change is reviewable in Git.
- The warehouse binding references `WWI_Warehouse` by its Git **logical ID**, with the workspace ID zeroed (`00000000-…`, meaning "this workspace"). Each stage therefore binds to its own warehouse. STG and PROD returned customer instances right after deployment, with no manual rebinding.
- Creating the ontology also auto-creates an Eventhouse, a KQL Database and a Graph model. They aren't tracked in Git, but deployment pipelines list them under the ontology and deploy them alongside it.
- After deploying Dev → Test, the ontology showed "Different from source", while Test → Prod showed "Same as source". The ontology works in every stage. We treat this compare result as a preview quirk, not drift. Re-checked on 2026-11-27: the flag remains, the deployed copy still has all 5 entity types and 4 relationships, and the pipeline offers no compare view for this preview item type. The likely cause is the auto-created Eventhouse and graph, which get a different generated name in each stage.
- A relationship created on the canvas has **no data binding until both join properties are set**. Unbound relationships show up in the graph but return nothing to the agent.
- The ontology reads live from the warehouse, so new rows only show up after a manual refresh of the ontology item. No schedule is set, in line with the project's "nothing left running" rule.

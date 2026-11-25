# ADR-0002: Promote with a deployment pipeline, load data per stage with scripts

- **Status:** Accepted
- **Date:** 2026-11-25

## Context
ADR-0001 set up three workspaces with Git on Dev only. `WWI_Warehouse` now has to reach Staging and Prod. Fabric deployment pipelines copy item definitions but [never data](https://learn.microsoft.com/en-us/fabric/cicd/deployment-pipelines/understand-the-deployment-process). For warehouses they apply a [schema diff (DacFx)](https://learn.microsoft.com/en-us/fabric/data-warehouse/deploy-pipelines) to the target.

## Options
1. **Deployment pipeline for schema, plus the repo's T-SQL scripts to load data in each stage.**
2. **Git-connect every workspace** to its own branch, and promote with pull requests.
3. **Cross-warehouse copy** (`INSERT … SELECT` from DEV) to move data along with the schema.

## Decision
Option 1. The pipeline `WWI Analytics Pipeline` (Development → Test → Production) promotes items. In each stage, `sql/02_load_data.sql` loads the data from Microsoft's public WWI parquet, and `sql/03_verify.sql` checks it.

## Consequences
- Git stays the single source of truth on Dev only. Staging and Prod change only through the pipeline, so every promotion appears in deployment history.
- Each stage loads its own data from the same public source. Stages don't depend on each other's data, and the load can be re-run (`TRUNCATE` + `COPY INTO`).
- Row counts must be checked after each load. All three stages match (`fact_sale` = 50,150,843).
- A schema change has to be deployed before the load script that needs it is run.
- Option 2 would mean extra branches to manage, and option 3 would tie Prod's data to Dev. Neither is worth it for a sample dataset.

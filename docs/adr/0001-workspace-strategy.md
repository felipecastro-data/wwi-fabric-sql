# ADR-0001: Three workspaces with Git on Dev and a deployment pipeline

- **Status:** Accepted
- **Date:** 2026-11-23

## Context
The project needs separate staging and production environments for a Fabric Warehouse, Ontology, Data Agent and App, with source control in GitHub.

## Options
1. **Three workspaces** (`SQL` → `SQL-Staging` → `SQL-Prod`) with Git on Dev and a Fabric deployment pipeline.
2. **One workspace** with staging and production schemas inside a single warehouse.

## Decision
Option 1.

## Consequences
- Each stage is isolated: separate permissions, items and data.
- Git holds the Dev definitions; promotion happens through the deployment pipeline with a clear history.
- Three workspaces use more capacity than one, which is fine on the F64 trial.

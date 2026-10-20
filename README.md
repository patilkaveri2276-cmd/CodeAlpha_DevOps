# Azure Pipelines CI/CD Example

This repository contains a minimal Node.js web application and an Azure Pipelines configuration for a complete CI/CD workflow.

## What this project demonstrates

- Continuous Integration (CI) with Azure Pipelines
- Automated Docker image build
- Pipeline-based push to Azure Container Registry (ACR)
- Automatic deployment to Azure App Service
- Deployment validation and health checks
- Core DevOps practices using Azure-native tooling

## Architecture

- Source code stored in GitHub
- Azure Pipelines runs build and test steps
- Docker image is built and pushed to Azure Container Registry
- App Service pulls the container and serves the web app
- A smoke test checks `/health` to confirm deployment success

## Files in this repo

- `server.js` - sample web service
- `Dockerfile` - container definition
- `package.json` - Node.js app metadata
- `azure-pipelines.yml` - Azure Pipelines config
- `scripts/create-azure-resources.sh` - Azure resource provisioning helper

## Prerequisites

Before running this pipeline, prepare the following in Azure:

1. Azure subscription
2. Azure Resource Group
3. Azure Container Registry
4. Azure App Service Plan (Linux)
5. Azure App Service web app
6. Service connections in Azure DevOps:
   - `azure-service-connection`
   - `acr-service-connection`

## Azure setup

Option A: Use the script to create the required resources:

```bash
chmod +x scripts/create-azure-resources.sh
RESOURCE_GROUP=rg-az-pipeline-demo \
LOCATION=eastus \
ACR_NAME=myacr12345 \
PLAN_NAME=asp-az-pipeline-demo \
WEB_APP_NAME=app-az-pipeline-demo-12345 \
./scripts/create-azure-resources.sh
```

Then create the Azure DevOps service connections and connect them to the pipeline variables.

## Pipeline flow

The pipeline runs in two stages:

1. Build stage
   - installs dependencies
   - validates the app
   - builds a Docker image
   - pushes the image to Azure Container Registry

2. Deploy stage
   - creates required Azure resources if needed
   - deploys the container to Azure App Service
   - calls the health endpoint to verify the app is live

## Monitoring and validation

During deployment, the pipeline performs a smoke test using:

```bash
curl -fsSL "https://<app-name>.azurewebsites.net/health"
```

This confirms the app is responding correctly after deployment.

## Key DevOps concepts learned

- Source control: Git-based code management
- CI: automated build and validation in Azure Pipelines
- Containerization: Docker packaging for app portability
- Registry: Azure Container Registry for image storage
- Continuous delivery: automated deployment to App Service
- Environment promotion: production deployment through deployment stages
- Monitoring: smoke tests, health endpoints, and deployment logs
- IaC readiness: Azure CLI scripts for provisioning infrastructure

## Example environment variables in Azure DevOps

Set these as pipeline variables or in the Azure DevOps UI:

```yaml
azureServiceConnection: 'azure-service-connection'
dockerRegistryServiceConnection: 'acr-service-connection'
resourceGroup: 'rg-az-pipeline-demo'
location: 'eastus'
acrName: 'myacr12345'
appServicePlan: 'asp-az-pipeline-demo'
webAppName: 'app-az-pipeline-demo-12345'
```

## Useful commands

```bash
npm install
npm start
curl http://localhost:8080/health
```

## Next steps

- Add automated unit tests
- Add a staging environment
- Enable Azure Monitor or Application Insights
- Integrate security scans and dependency checks

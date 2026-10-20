#!/usr/bin/env bash
set -euo pipefail

# Azure resource provisioning script
# Prerequisites:
# - az logged in with permission to create resources
# - Subscription selected using: az account set --subscription "<subscription-id-or-name>"

RESOURCE_GROUP="${RESOURCE_GROUP:-rg-az-pipeline-demo}"
LOCATION="${LOCATION:-eastus}"
ACR_NAME="${ACR_NAME:-azpipelineacr${RANDOM}}"
PLAN_NAME="${PLAN_NAME:-asp-az-pipeline-demo}"
WEB_APP_NAME="${WEB_APP_NAME:-app-az-pipeline-demo-${RANDOM}}"
SKU="B1"

az group create --name "$RESOURCE_GROUP" --location "$LOCATION" --output table

az acr create \
  --resource-group "$RESOURCE_GROUP" \
  --name "$ACR_NAME" \
  --sku Basic \
  --admin-enabled true \
  --output table

az appservice plan create \
  --name "$PLAN_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --location "$LOCATION" \
  --sku "$SKU" \
  --is-linux \
  --output table

az webapp create \
  --resource-group "$RESOURCE_GROUP" \
  --plan "$PLAN_NAME" \
  --name "$WEB_APP_NAME" \
  --deployment-container-image-name "$ACR_NAME.azurecr.io/sample-webapp:latest" \
  --output table

ACR_USER=$(az acr credential show --name "$ACR_NAME" --query username --output tsv)
ACR_PASSWORD=$(az acr credential show --name "$ACR_NAME" --query passwords[0].value --output tsv)

az webapp config container set \
  --resource-group "$RESOURCE_GROUP" \
  --name "$WEB_APP_NAME" \
  --docker-custom-image-name "$ACR_NAME.azurecr.io/sample-webapp:latest" \
  --docker-registry-server-url "https://$ACR_NAME.azurecr.io" \
  --docker-registry-server-user "$ACR_USER" \
  --docker-registry-server-password "$ACR_PASSWORD" \
  --output table

echo "Resource group: $RESOURCE_GROUP"
echo "Container registry: $ACR_NAME"
echo "App Service: $WEB_APP_NAME"
echo "URL: https://$WEB_APP_NAME.azurewebsites.net"

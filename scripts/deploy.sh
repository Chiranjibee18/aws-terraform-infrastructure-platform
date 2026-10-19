#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# AWS Terraform Infrastructure Platform - Deployment Helper Script
# ==============================================================================

ENV="${1:-dev}"

if [[ "$ENV" != "dev" && "$ENV" != "prod" ]]; then
    echo "Usage: $0 [dev|prod]"
    exit 1
fi

echo "======================================================================"
echo " Preparing deployment for environment: [$ENV]"
echo " Working directory: environments/$ENV"
echo "======================================================================"

cd "environments/$ENV"

echo "[1/4] Initializing Terraform backend and modules..."
terraform init

echo "[2/4] Validating Terraform syntax..."
terraform validate

echo "[3/4] Generating execution plan..."
terraform plan -out=tfplan.binary

echo "[4/4] Review execution plan above."
read -p "Do you want to apply these changes to AWS ($ENV)? (yes/no): " -r CONFIRM

if [[ "$CONFIRM" == "yes" ]]; then
    echo "Applying plan..."
    terraform apply tfplan.binary
    rm -f tfplan.binary
    echo "✓ Deployment to $ENV completed successfully."
else
    echo "Deployment cancelled by user. Cleaning up plan file."
    rm -f tfplan.binary
fi

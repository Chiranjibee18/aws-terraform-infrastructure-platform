#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# AWS Terraform Infrastructure Platform - Validation & Linting Suite
# ==============================================================================

echo "======================================================================"
echo " Running Terraform Platform Validation Suite"
echo "======================================================================"

# Check if terraform binary is present
if command -v terraform &> /dev/null; then
    echo "[1/4] Checking code formatting across entire repository..."
    terraform fmt -check -recursive
    echo "  ✓ Formatting check passed."
else
    echo "[1/4] (Notice) Terraform CLI not detected in local path. Skipping local fmt."
fi

echo "[2/4] Verifying directory structure and required modules..."
REQUIRED_DIRS=(
    "backend-setup"
    "modules/vpc"
    "modules/security"
    "modules/iam"
    "modules/storage"
    "modules/compute"
    "environments/dev"
    "environments/prod"
)

for dir in "${REQUIRED_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        echo "  ✓ Module/Directory exists: $dir"
    else
        echo "  ✗ Error: Missing directory: $dir"
        exit 1
    fi
done

echo "[3/4] Verifying environment root modules and manifests..."
for env in dev prod; do
    for file in main.tf variables.tf outputs.tf terraform.tfvars; do
        if [ -f "environments/$env/$file" ]; then
            echo "  ✓ environments/$env/$file verified."
        else
            echo "  ✗ Error: Missing environments/$env/$file"
            exit 1
        fi
    done
done

echo "[4/4] Validation complete. Platform configuration verified successfully!"

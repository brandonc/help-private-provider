#!/usr/bin/env bash

set -e

source "../.secret_config"

echo "Get the sha256sum of the platform-specific provider. Example:"
echo ""
printf "shasum -a 256 terraform-provider-%s_%s_linux_amd64.zip\n" "$PROVIDER_NAME" "$PROVIDER_VERSION"

#!/usr/bin/env bash

set -e

if test ! ../.secret_config; then
  echo "Modify config_example and save as \".secret_config\""
  exit 1
fi

source "../.secret_config"

# Create the provider
cat << EOF > provider.json
{
  "data": {
    "type": "registry-providers",
    "attributes": {
      "name": "$PROVIDER_NAME",
      "namespace": "$ORG_NAME",
      "registry-name": "private"
    }
  }
}
EOF

curl \
  -f \
  --header "Authorization: Bearer $TFE_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  --request POST \
  --data @provider.json \
  https://$TFE_HOSTNAME/api/v2/organizations/$ORG_NAME/registry-providers

echo "Success."

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
  -s \
  --header "Authorization: Bearer $TFE_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  --request POST \
  --data @provider.json \
  https://$TFE_HOSTNAME/api/v2/organizations/$ORG_NAME/registry-providers

# Create the provider version
cat << EOF > version.json
{
  "data": {
    "type": "registry-provider-versions",
    "attributes": {
      "version": "$PROVIDER_VERSION",
      "key-id": "$KEY_ID",
      "protocols": ["5.0", "6.0"]
    }
  }
}
EOF

curl \
  -f \
  -s \
  --header "Authorization: Bearer $TFE_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  --request POST \
  --data @version.json \
  https://$TFE_HOSTNAME/api/v2/organizations/$ORG_NAME/registry-providers/private/$ORG_NAME/$PROVIDER_NAME/versions \
  | jq -r '.data.links' > version_upload.json

echo "Upload SHA256SUMS and SHA256SUMS.sig to the URL in version_upload.json"
echo "Example:"
echo ""
echo "curl -f -s \\"
printf "  -T terraform-provider-%s_%s_SHA256SUMS" $PROVIDER_NAME $PROVIDER_VERSION
echo "  https://archivist.terraform.io/v1/object/dmF1b64hd73ghd63..."

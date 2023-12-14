#!/usr/bin/env bash

set -e

if [ "$1" = "" ]; then
  echo "Usage: $0 <sha256sum from step 3>"
  exit 1
fi

source "../.secret_config"

FILENAME="$(printf terraform-provider-%s_%s_linux_amd64.zip "$PROVIDER_NAME" "$PROVIDER_VERSION")"

cat << EOT > linux.json
{
  "data": {
    "type": "registry-provider-version-platforms",
    "attributes": {
      "os": "linux",
      "arch": "amd64",
      "shasum": "$1",
      "filename": "$FILENAME"
    }
  }
}
EOT

curl \
  -f \
  --header "Authorization: Bearer $TFE_TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  --request POST \
  --data @linux.json \
  https://$TFE_HOSTNAME/api/v2/organizations/$ORG_NAME/registry-providers/private/$ORG_NAME/$PROVIDER_NAME/versions/$PROVIDER_VERSION/platforms \
  | jq -r '.data.links'

echo "Upload $FILENAME to the URL above"
echo "Example:"
echo ""
echo "curl -f -s \\"
echo "  -T $FILENAME \\"
echo "  https://archivist.terraform.io/v1/object/dmF1b64hd73ghd63..."

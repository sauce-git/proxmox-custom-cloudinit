#!/bin/bash

set -e

if [ -z "$1" ]; then
  echo "❌ Usage: $0 <vmid>"
  exit 1
fi

VMID="$1"
CI_TEMPLATE="cloud-init.yaml"
CI_YAML_TMP="cloud-init.generated.yaml"
CI_NETWORK_TEMPLATE="ci-network.yaml"
ISO_NAME="custom-ci.iso"
ISO_PATH="/var/lib/vz/template/iso/$ISO_NAME"
IDE_NAME="ide2"

# Load .env file
while IFS='=' read -r key value; do
  export "$key=$value"
done < <(grep -v '^#' .env)

# Inject env vars into a copy of the YAML (without modifying the original)
envsubst < "$CI_TEMPLATE" > "$CI_YAML_TMP"

# Generate ISO from generated YAML
echo "📦 Generating cloud-init ISO..."
cloud-localds --network-config "$CI_NETWORK_TEMPLATE" "$ISO_NAME" "$CI_YAML_TMP"

# Clean up temporary YAML
rm -f "$CI_YAML_TMP"

# Move ISO into Proxmox ISO directory
echo "📂 Moving ISO to Proxmox ISO storage directory..."
mv "$ISO_NAME" "$ISO_PATH"

# Attach ISO to target VM
echo "🔗 Attaching ISO to VM $VMID..."
qm set "$VMID" --"$IDE_NAME" local:iso/"$ISO_NAME",media=cdrom

# Boot config (recommended)
echo "⚙  Setting boot options for VM $VMID..."
qm set "$VMID" --boot c --bootdisk scsi0 --serial0 socket --vga serial0

echo "✅ Done! Cloud-init ISO successfully attached to VM $VMID."

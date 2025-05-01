#!/bin/bash

set -e

# Check if VM ID argument is provided
if [ -z "$1" ]; then
  echo "❌ Usage: $0 <vmid>"
  exit 1
fi

VMID="$1"
CI_YAML="cloud-init.yaml"
ISO_NAME="custom-ci.iso"
ISO_PATH="/var/lib/vz/template/iso/$ISO_NAME"
IDE_NAME="ide2"

# Generate cloud-init ISO from the given YAML
echo "📦 Generating cloud-init ISO..."
cloud-localds "$ISO_NAME" "$CI_YAML"

# Move ISO to Proxmox's ISO storage directory
echo "📂 Moving ISO to Proxmox ISO storage directory..."
mv "$ISO_NAME" "$ISO_PATH"

# Attach the ISO to the VM
echo "🔗 Attaching ISO to VM $VMID..."
qm set "$VMID" --"$IDE_NAME" local-lvm:iso/"$ISO_NAME",media=cdrom

# Set boot options (optional but recommended)
echo "⚙  Setting boot options for VM $VMID..."
qm set "$VMID" --boot c --bootdisk scsi0 --serial0 socket --vga serial0

echo "✅ Done! Cloud-init ISO successfully attached to VM $VMID."

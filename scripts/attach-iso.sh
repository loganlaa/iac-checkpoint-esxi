#!/usr/bin/env bash
set -euo pipefail

# Anexa ISOs do datastore ESXi ao drive CD/DVD das VMs criadas pelo Terraform.
# Uso:
#   export ESXI_HOST="172.16.120.122" ESXI_USER="root"
#   ./scripts/attach-iso.sh FW1 "[datastore1] ISO/Check_Point_R81.20.iso"
#
# Requer: ssh, vim-cmd no ESXi (SSH habilitado apenas na rede de gerenciamento).

VM_NAME="${1:?Uso: $0 <VM_NAME> <DATASTORE_ISO_PATH>}"
ISO_PATH="${2:?Uso: $0 <VM_NAME> <DATASTORE_ISO_PATH>}"
ESXI_HOST="${ESXI_HOST:-172.16.120.122}"
ESXI_USER="${ESXI_USER:-root}"
ESXI_PORT="${ESXI_PORT:-22}"

# Converte "[datastore1] path/file.iso" ou "datastore1/path/file.iso" -> "/vmfs/volumes/datastore1/path/file.iso"
if [[ "$ISO_PATH" =~ ^\[([^]]+)\][[:space:]]*(.+)$ ]]; then
  DS_NAME="${BASH_REMATCH[1]}"
  REL_PATH="${BASH_REMATCH[2]}"
  VMFS_ISO="/vmfs/volumes/${DS_NAME}/${REL_PATH}"
elif [[ "$ISO_PATH" != /* ]]; then
  VMFS_ISO="/vmfs/volumes/${ISO_PATH}"
else
  VMFS_ISO="$ISO_PATH"
fi

echo "Conectando em ${ESXI_USER}@${ESXI_HOST}:${ESXI_PORT} para configurar CD/DVD em ${VM_NAME}..."

ssh -p "${ESXI_PORT}" "${ESXI_USER}@${ESXI_HOST}" bash -s -- "$VM_NAME" "$VMFS_ISO" <<'EOF'
set -euo pipefail
VM_NAME="$1"
VMFS_ISO="$2"

VM_ID=$(vim-cmd vmsvc/getallvms | awk -v name="$VM_NAME" '$2 == name {print $1; exit}')
if [[ -z "$VM_ID" ]]; then
  echo "Erro: VM '$VM_NAME' nao encontrada no ESXi." >&2
  exit 1
fi

VMX_REL=$(vim-cmd vmsvc/getallvms | awk -v id="$VM_ID" '$1 == id {print $3 " " $4; exit}')
DS_BRACKET=$(echo "$VMX_REL" | sed -n 's/^\[\([^]]*\)\].*/\1/p')
VMX_SUBPATH=$(echo "$VMX_REL" | sed -n 's/^\[[^]]*\] \([^ ]*\.vmx\).*/\1/p')
VMX_FILE="/vmfs/volumes/${DS_BRACKET}/${VMX_SUBPATH}"

if [[ ! -f "$VMX_FILE" ]]; then
  echo "Erro: arquivo VMX nao encontrado: $VMX_FILE" >&2
  exit 1
fi

if [[ ! -f "$VMFS_ISO" ]]; then
  echo "Erro: ISO nao encontrada no datastore: $VMFS_ISO" >&2
  exit 1
fi

POWER_STATE=$(vim-cmd vmsvc/power.getstate "$VM_ID" | tail -n 1)
if [[ "$POWER_STATE" != "Powered off" ]]; then
  echo "Aviso: VM '$VM_NAME' esta '$POWER_STATE'. Desligue-a antes de editar o VMX." >&2
  exit 1
fi

# Remove entradas antigas de ide1:0 e grava configuracao idempotente de CD-ROM ISO
sed -i '/^ide1:0\./d' "$VMX_FILE"
cat >> "$VMX_FILE" <<VMXEOF
ide1:0.present = "TRUE"
ide1:0.deviceType = "cdrom-image"
ide1:0.fileName = "${VMFS_ISO}"
ide1:0.startConnected = "TRUE"
VMXEOF

vim-cmd vmsvc/reload "$VM_ID"
echo "ISO anexada com sucesso em ${VM_NAME} (VMID=${VM_ID}): ${VMFS_ISO}"
EOF

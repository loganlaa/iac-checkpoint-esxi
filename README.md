# IaC Check Point ClusterXL Lab — VMware ESXi 6.5 Standalone

Projeto Terraform + scripts/Ansible para provisionamento de laboratório Check Point ClusterXL + Windows AD em **VMware ESXi 6.5 standalone** (sem vCenter), utilizando o provider **`josenk/esxi` (`v1.10.3`)**.

## Arquitetura Provisionada

- **Rede:** novo Standard vSwitch (`vSwitch_LAB_CP` por padrão) com Port Groups `VLAN_INTERNAL` e `VLAN_SYNC` configurados com `promiscuous_mode`, `mac_changes` e `forged_transmits` habilitados (obrigatório para ClusterXL VMAC/CCP). O vSwitch de gerenciamento existente não é alterado.
- **VMs (8 GB RAM, 200 GB disco thin, 2 vCPUs configuráveis, HW v13):**
  - `FW1` / `FW2`: `[Management, VLAN_INTERNAL, VLAN_SYNC]` (+ `VLAN_EXTERNAL` opcional se `enable_wan_segment = true`).
  - `SMS`: `[Management]`.
  - `WINSERV-LAB` / `WIN-LAB`: `[VLAN_INTERNAL]`.

## Pré-requisitos no Ubuntu WSL

1. Terraform `>= 1.5.0`
2. Serviço **SSH habilitado no ESXi** apenas na rede de gerenciamento (`172.16.120.122`)
3. ISOs enviadas para o datastore do ESXi (ou OVAs locais + `ovftool`, se preferir deploy via OVA)
4. Ansible (opcional, apenas para pós-instalação dos SOs)

## Comandos Essenciais (Ubuntu WSL)

```bash
cd /home/logan/projetos/iac-checkpoint-esxi/terraform

# 1. Configurar variaveis locais (nao versionado no Git)
cp terraform.tfvars.example terraform.tfvars
nano terraform.tfvars

# 2. Inicializar, formatar, validar e planejar
terraform init
terraform fmt -recursive
terraform validate
terraform plan

# 3. Aplicar somente apos revisar o plan
terraform apply
```

## Anexar ISOs antes do primeiro boot

O provider `josenk/esxi` não monta `.iso` nativamente em `esxi_guest`. Com as VMs desligadas (`vm_initial_power = "off"`), execute na raiz do projeto:

```bash
export ESXI_HOST="172.16.120.122" ESXI_USER="root"
chmod +x scripts/attach-iso.sh

./scripts/attach-iso.sh FW1 "[DATASTORE] ISO/Check_Point_Gaia.iso"
./scripts/attach-iso.sh FW2 "[DATASTORE] ISO/Check_Point_Gaia.iso"
./scripts/attach-iso.sh SMS "[DATASTORE] ISO/Check_Point_Gaia.iso"
./scripts/attach-iso.sh WINSERV-LAB "[DATASTORE] ISO/Windows_Server.iso"
./scripts/attach-iso.sh WIN-LAB "[DATASTORE] ISO/Windows_Client.iso"
```

Após instalar os SOs, configure `ansible/inventory/hosts.ini` a partir de `hosts.ini.example` e execute os playbooks em `ansible/playbooks/`.

# Rancher Kubernetes Lab on AWS

Laboratório prático em andamento para estudos de **Rancher**, **Kubernetes**, **Docker**, **Terraform** e publicação futura com **Route 53 + Traefik**.

## Status do projeto

> **Projeto em andamento**
>
> Nesta etapa, a infraestrutura base já foi provisionada na AWS com Terraform:
>
> - 1 VPC
> - 1 subnet pública
> - 1 Internet Gateway
> - 1 route table pública
> - 1 Security Group compartilhado
> - 4 instâncias EC2 Ubuntu na AWS
> - acesso SSH funcionando nas 4 máquinas
> - Docker instalado automaticamente via `user_data`
>
> O próximo passo do laboratório será a instalação e configuração do **Rancher** na VM principal.

---

## Objetivo

Este repositório tem como objetivo documentar a construção de um laboratório prático na AWS para aprendizado de:

- Terraform
- AWS EC2 / VPC / Networking
- Docker
- Rancher
- Kubernetes
- Ingress com Traefik
- DNS com Route 53

A ideia é evoluir gradualmente o ambiente, partindo da infraestrutura base até a publicação de aplicações no cluster.

---

## Arquitetura atual

A arquitetura provisionada até o momento é composta por:

- **1 VPC**
- **1 subnet pública**
- **1 Internet Gateway**
- **1 route table pública associada à subnet**
- **1 Security Group compartilhado entre as 4 instâncias**
- **4 instâncias EC2 Ubuntu**
- **1 bucket S3 para armazenar o state remoto do Terraform**

### Instâncias criadas

Os nomes das instâncias são definidos por variável no Terraform. No cenário atual, os nomes utilizados são:

- `rancher-server`
- `rancher-k8s-1`
- `rancher-k8s-2`
- `rancher-k8s-3`

---

## Especificações das instâncias

Todas as máquinas foram provisionadas com:

- **Tipo:** `t4g.medium`
- **Sistema operacional:** Ubuntu 24.04
- **Disco:** volume EBS `gp3`
- **IP público:** habilitado
- **Acesso SSH:** via key pair existente na conta AWS

### Observação importante sobre arquitetura

As instâncias `t4g.medium` utilizam **AWS Graviton (ARM64)**.

Por isso, ao trabalhar com containers e imagens Docker neste laboratório, é importante usar imagens compatíveis com **ARM64**, ou imagens multi-arquitetura.

---

## Provisionamento com Terraform

A infraestrutura foi construída com Terraform e organizada em módulos para facilitar a manutenção e evolução do projeto.

### Estrutura atual

```text
terraform/
├── modules/
│   ├── compute/
│   ├── network/
│   └── security/
├── main.tf
├── outputs.tf
├── provider.tf
├── variables.tf
├── versions.tf
├── backend.hcl.example
├── terraform.tfvars.example
└── README.md
Recursos provisionados
Rede
VPC
subnet pública
Internet Gateway
route table pública
associação da route table com a subnet
Segurança
Security Group compartilhado entre as 4 instâncias
Compute
4 EC2 Ubuntu
instalação automática do Docker via user_data
associação da key pair SSH
atribuição de IP público
nome das instâncias definido por variável
Instalação automática do Docker

Durante a criação das instâncias, o Terraform executa um user_data que:

instala o Docker
habilita o serviço
inicia o serviço
adiciona o usuário ubuntu ao grupo docker

Isso permitiu deixar as VMs prontas para os próximos passos do laboratório.

Backend remoto do Terraform

O projeto utiliza state remoto em bucket S3.

Neste laboratório, o bucket foi criado manualmente e configurado no backend.hcl.

Exemplo de backend
bucket  = "SEU-BUCKET-TERRAFORM-STATE"
key     = "lab/terraform.tfstate"
region  = "us-east-1"
encrypt = true
Acesso SSH

Após o provisionamento, as 4 instâncias ficaram acessíveis via SSH.

Exemplo:

ssh -i ~/.ssh/rancher-kubernetes.pem ubuntu@IP_PUBLICO_DA_INSTANCIA

Os IPs públicos e comandos SSH podem ser consultados pelos outputs do Terraform.

Exemplos
terraform output
terraform output ssh_commands
terraform output ssh_summary
Docker e imagens do laboratório

Durante o andamento do curso/lab, também estão sendo trabalhadas imagens Docker para os componentes usados nos exercícios, como por exemplo:

Node
Nginx
Redis
banco de dados

Esses artefatos fazem parte do laboratório, mas a configuração completa da camada de orquestração com Rancher/Kubernetes ainda será adicionada nas próximas etapas.

Route 53 e Traefik

A intenção futura deste laboratório é utilizar:

Route 53 para DNS
Traefik como ingress controller
wildcard DNS para publicação de aplicações no cluster

Exemplo de ideia de publicação futura:

*.rancher.seu-dominio.com
Observação importante

O material original do curso usa uma abordagem mais antiga de Traefik.
Neste laboratório, a intenção é seguir a linha mais atual do Traefik, evitando manifests e instruções antigas/deprecadas.

Nesta fase do projeto, o DNS e o ingress ainda não foram implantados, mas fazem parte da evolução planejada do ambiente.

Etapa atual

Até o momento, o laboratório contempla:

infraestrutura base criada na AWS
Docker instalado nas 4 VMs
acesso SSH validado
repositório organizado
base pronta para a próxima etapa
Próximo passo
instalar e configurar o Rancher na VM principal (rancher-server)
seguir com a evolução do ambiente conforme o andamento do curso
Próximas etapas planejadas

As próximas fases previstas para este laboratório são:

instalação do Rancher
definição da função de cada nó
preparação do ambiente Kubernetes
configuração de publicação via ingress
integração com Traefik
DNS com Route 53
testes de publicação de aplicações
Como usar este projeto
1. Ajustar variáveis

Copiar e editar os arquivos de exemplo:

cp terraform.tfvars.example terraform.tfvars
cp backend.hcl.example backend.hcl
2. Inicializar o Terraform
terraform init -backend-config="backend.hcl"
3. Validar o plano
terraform plan -var-file="terraform.tfvars"
4. Aplicar a infraestrutura
terraform apply -var-file="terraform.tfvars"
Arquivos ignorados no Git

O repositório foi ajustado para não versionar arquivos temporários ou sensíveis, como:

.terraform/
terraform.tfstate
terraform.tfstate.backup
*.tfvars reais
backend.hcl real
node_modules/
chaves .pem

Somente os arquivos necessários para reconstrução do ambiente e documentação do projeto são mantidos no Git.

Observações finais

Este repositório representa a evolução prática de um laboratório real de estudos.
Ele ainda não está concluído, e o README será atualizado conforme novas etapas do curso forem sendo implementadas.

No estado atual, o projeto já entrega uma base sólida de infraestrutura para continuar a jornada com Rancher e Kubernetes na AWS.

Autor

Ezequiel Bomfim

Projeto de laboratório prático para estudos de infraestrutura, containers, Rancher, Kubernetes e automação com Terraform.

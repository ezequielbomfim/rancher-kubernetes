# AWS Lab - Rancher / Kubernetes Base Infrastructure

This project provisions a simple AWS lab foundation for Rancher and Kubernetes studies using Terraform.

## Architecture

This lab creates:

- 1 VPC
- 1 public subnet
- 1 Internet Gateway
- 1 public route table associated with the public subnet
- 1 shared Security Group
- 4 Ubuntu EC2 instances in the same public subnet
- 1 root EBS volume of 50 GiB per instance
- Docker preinstalled on all EC2 instances
- Remote Terraform state stored in S3

## Target region

- `us-east-1` (N. Virginia)

## EC2 layout

You can name the servers however you want in `terraform.tfvars`.

Example:

- `lab-rancher-01`
- `lab-k8s-01`
- `lab-k8s-02`
- `lab-k8s-03`

## Instance type

All instances use:

- `t4g.medium`

## Important note about architecture

Because `t4g.medium` uses AWS Graviton, the AMI must be ARM64-compatible.
This project resolves the latest Ubuntu ARM64 AMI dynamically using the Canonical public SSM parameter.

## Docker installation

Each EC2 instance receives a `user_data` bootstrap script that:

- installs Docker from the official Docker repository
- installs:
  - `docker-ce`
  - `docker-ce-cli`
  - `containerd.io`
  - `docker-buildx-plugin`
  - `docker-compose-plugin`
- enables and starts the Docker service
- adds the `ubuntu` user to the `docker` group

After you connect by SSH, if `docker ps` does not work immediately without `sudo`, reconnect the SSH session once so the new group membership is applied to the session.

## Security Group

This lab currently uses a very permissive Security Group because the goal is temporary lab usage.

Rules:

- SSH allowed from the CIDRs defined in `ssh_ingress_cidrs`
- all traffic open to the world on IPv4 and IPv6
- all outbound traffic allowed

This is intentionally open for lab convenience and should be hardened later if needed.

## Project structure

```text
bootstrap/    -> creates the S3 bucket used by Terraform remote state
envs/lab/     -> creates the lab infrastructure using modules
```

## Step 1 - Create the Terraform state bucket

Go to the bootstrap folder:

```bash
cd bootstrap
```

Copy the example vars file:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` and define a globally unique bucket name.

Then run:

```bash
terraform init
terraform plan -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"
```

## Step 2 - Configure the backend of the main lab

Go to the lab folder:

```bash
cd ../envs/lab
```

Copy the backend example file:

```bash
cp backend.hcl.example backend.hcl
```

Edit `backend.hcl` and set the bucket name created by the bootstrap stack.

Example:

```hcl
bucket  = "your-unique-terraform-state-bucket"
key     = "lab/terraform.tfstate"
region  = "us-east-1"
encrypt = true
```

## Step 3 - Configure the lab variables

Copy the vars example file:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit all names as desired:

- VPC name
- subnet name
- Internet Gateway name
- route table name
- Security Group name
- EC2 names
- SSH CIDRs
- private key path used in the SSH outputs
- tags

## Step 4 - Deploy the lab

Run:

```bash
terraform init -backend-config="backend.hcl"
terraform plan -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"
```

## Step 5 - Validate the environment

Check Terraform outputs:

```bash
terraform output
```

Display the ready-to-use SSH commands:

```bash
terraform output ssh_summary
```

SSH into one instance:

```bash
ssh -i /path/to/your/private-key.pem ubuntu@<public_ip>
```

Validate Docker:

```bash
docker version
docker ps
```

If `docker ps` fails without sudo on the first login, disconnect and reconnect the SSH session.

## Destroying the lab

When you finish testing:

```bash
terraform destroy -var-file="terraform.tfvars"
```

## Route 53 and Traefik - design observation

This Terraform project does not create Route 53 records or install Traefik yet.
That part will be used later in your Kubernetes/Rancher steps.

The intended logic is:

- Route 53 will host a wildcard DNS record such as `*.rancher.dev-ops-ninja.com`
- that wildcard record will point to the public entry point of your cluster
- Traefik will act as the ingress layer
- Traefik will receive requests for hostnames like:
  - `app1.rancher.dev-ops-ninja.com`
  - `dashboard.rancher.dev-ops-ninja.com`
  - `api.rancher.dev-ops-ninja.com`
- inside the cluster, Traefik will route each hostname to the appropriate service

### Important observation about your course material

Your course example uses an older Traefik generation.
For your lab, prefer the current Traefik v3 line instead of older v1 material.

So, conceptually, the professor's DNS idea is still valid:
- wildcard DNS in Route 53
- ingress receiving the traffic
- host-based routing inside Kubernetes

But when you eventually install Traefik, do not follow old manifests from the deprecated v1 era.
Prefer the current Traefik documentation and the current Helm chart for Traefik Proxy v3.

## Suggested next evolution of this lab

After this base infrastructure is ready, the natural next steps are:

1. install Kubernetes or k3s/rke2
2. install Rancher
3. install Traefik properly using current docs
4. create Route 53 wildcard records
5. publish sample applications through ingress

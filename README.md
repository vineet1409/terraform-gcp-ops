# 🚀 GCP Terraform Infrastructure via CI/CD using GitHub Actions

This repository contains a **step-by-step guide** and code to deploy Google Cloud resources using [Terraform](https://www.terraform.io/) and automate deployment with [GitHub Actions](https://docs.github.com/en/actions).

You’ll learn to:

* Structure Terraform code for real cloud projects
* Use modules for reusable infrastructure
* Set up permissions and service accounts on GCP
* Deploy and manage resources with safe, repeatable CI/CD

---

## 📚 What You’ll Build

Using this repo and guide, you will:

* Create and manage Google Cloud resources:

  * **Cloud Storage Bucket (GCS)**
  * **BigQuery Dataset**
  * **Vertex AI Workbench (Jupyter Notebook VM)**
  * **Cloud Run Service**
  * **Vertex AI Endpoint**
* Organize your Terraform code in a clean, scalable way
* Use GitHub Actions to automate deployment, with approvals for production safety

---

## 🧱 Project Structure

```
gcp-infra-monorepo/
├── modules/                    # Individual service modules for reusability
│   ├── gcs/
│   ├── bigquery/
│   ├── vertex_workbench/
│   ├── cloud_run/
│   └── vertex_endpoint/
├── envs/
│   └── dev/                    # Environment-specific config (here, "dev")
│       ├── main.tf             # Root module for the environment
│       ├── versions.tf         # Provider and Terraform version constraints
│       ├── backend.tf          # Remote state backend config
│       ├── variables.tf        # Declares project/region variables
│       └── terraform.tfvars    # (Optional) Values for variables
├── .github/
│   └── workflows/
│       └── terraform-deploy.yml # GitHub Actions CI/CD workflow
└── README.md                   # This guide!
```

---

## ☁️ GCP Setup (One-Time)

### 1. **Create or Choose a GCP Project**

You need **Project Owner** or **Editor** role for setup.
Get your Project ID (e.g., `mlops-project-462702`).

### 2. **Enable Required APIs**

```bash
gcloud services enable \
  storage.googleapis.com \
  bigquery.googleapis.com \
  notebooks.googleapis.com \
  run.googleapis.com \
  aiplatform.googleapis.com
```

### 3. **Create a Service Account for Terraform Automation**

**Why?**
A dedicated account gives your automation the exact permissions it needs—nothing more.

```bash
# Set your project (if not set)
gcloud config set project mlops-project-462702

# Create service account
gcloud iam service-accounts create terraform-ci \
  --display-name="Terraform CI/CD Service Account"
```

### 4. **Grant Required Roles**

```bash
for role in roles/storage.admin roles/bigquery.admin roles/notebooks.admin roles/run.admin roles/aiplatform.admin
do
  gcloud projects add-iam-policy-binding mlops-project-462702 \
    --member="serviceAccount:terraform-ci@mlops-project-462702.iam.gserviceaccount.com" \
    --role="$role"
done
```

**Grant Service Account User on default VM SA:**

```bash
gcloud iam service-accounts add-iam-policy-binding 994447107287-compute@developer.gserviceaccount.com \
  --member="serviceAccount:terraform-ci@mlops-project-462702.iam.gserviceaccount.com" \
  --role="roles/iam.serviceAccountUser"
```

### 5. **Create and Download a Service Account Key**

```bash
gcloud iam service-accounts keys create ~/terraform-ci-key.json \
  --iam-account=terraform-ci@mlops-project-462702.iam.gserviceaccount.com
```

---

## 🔑 GitHub Setup

### 1. **Create a GitHub Repository**

Upload the contents of this monorepo.

### 2. **Add Repository Secrets**

In your GitHub repo, go to **Settings → Secrets and variables → Actions → New repository secret**
Add:

| Name                      | Value                                                |
| ------------------------- | ---------------------------------------------------- |
| `GCP_SERVICE_ACCOUNT_KEY` | *Full contents of your `terraform-ci-key.json` file* |
| `GCP_PROJECT_ID`          | *Your GCP project id (e.g., `mlops-project-462702`)* |

### 3. **Set Up a GitHub Environment for Manual Approval (Optional but Recommended)**

* Go to **Settings → Environments** in your repo.
* Create an environment called `gcp-dev`.
* (Optional) Add required reviewers for safer, approved deployments.

---

## 🌍 Terraform Concepts, in Brief

* **Providers**: Plugins for specific clouds (here, GCP)
* **Resources**: What you create (e.g., `google_storage_bucket`)
* **Modules**: Collections of resources that are reusable
* **Variables**: Dynamic inputs (project id, region, etc)
* **State**: Terraform stores what’s deployed (use a remote backend like GCS)
* **Plan/Apply**: Preview changes before applying for safety

---

## 🏗️ Infrastructure Code Walkthrough

* **Modules** under `modules/` each manage one service and define their own variables/outputs.
* The **dev environment** (`envs/dev/`) calls all modules and wires them together.
* **Backend** uses a GCS bucket for storing state securely (defined in `envs/dev/backend.tf`).

---

## 🚦 Running Terraform Locally (for learning)

```bash
cd envs/dev
terraform init
terraform plan -var="gcp_project_id=YOUR_PROJECT_ID"
terraform apply -var="gcp_project_id=YOUR_PROJECT_ID"
```

---

## 🤖 CI/CD: Automatic Deployment via GitHub Actions

This repo includes a workflow (`.github/workflows/terraform-deploy.yml`) that:

1. Runs on every push to `main` (or on manual trigger)
2. Authenticates to GCP using your service account key
3. Runs `terraform init`, `validate`, `plan`, and `apply` in the `envs/dev` directory
4. Optionally, waits for your approval before apply if you enabled the `gcp-dev` environment

---

## ✅ Step-by-Step: Deploy GCP Resources via GitHub Actions

1. **Push your code** (or any changes) to `main` branch.
2. Go to **Actions** tab in GitHub to watch the run.
3. If you set up `gcp-dev` environment with reviewers, approve the deployment when prompted.
4. When done, all resources are visible in your GCP Console!

---

## 🆘 Troubleshooting

* **Missing variable or permission errors?**
  Make sure all variables are declared in `variables.tf` and your service account has the necessary roles (see GCP setup above).
* **State errors?**
  Confirm the GCS state bucket exists and your account can read/write it.
* **Plan or Apply fails?**
  Read the error message, check the Action logs, and make sure your IAM/service account and secrets are correct.

---

## 🎓 Resources

* [Terraform GCP Provider Docs](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
* [Terraform Fundamentals](https://learn.hashicorp.com/collections/terraform/gcp-get-started)
* [Google Cloud IAM Docs](https://cloud.google.com/iam/docs)
* [GitHub Actions Docs](https://docs.github.com/en/actions)

---

## 💡 Tips

* You can add more modules for other GCP services easily.
* Use **Pull Requests** for peer review and safe infrastructure changes.
* Always use version control and CI/CD for cloud infra!

---

# 📖 Appendix: Terraform Core Concepts Explained

Terraform is an **infrastructure as code (IaC)** tool by HashiCorp. It lets you describe your cloud infrastructure in code, and then create, change, and delete those resources safely and repeatably.

### 1. **Providers**

A **provider** is a plugin that lets Terraform talk to a specific platform or service (like Google Cloud, AWS, Azure, GitHub, etc).

```hcl
provider "google" {
  project = var.gcp_project_id
  region  = var.default_region
}
```

### 2. **Resources**

A **resource** is any infrastructure object you want to manage—VMs, Storage buckets, networks, etc.

```hcl
resource "google_storage_bucket" "my_bucket" {
  name     = "my-terraform-demo-bucket"
  location = "US"
}
```

### 3. **Data Sources**

A **data source** lets you **read** information from outside Terraform.

```hcl
data "google_client_openid_userinfo" "me" {}
```

### 4. **Input Variables**

Variables make your Terraform code flexible and reusable.

**Declare:**

```hcl
variable "gcp_project_id" {
  description = "Your GCP Project ID"
  type        = string
}
```

**Use:**

```hcl
provider "google" {
  project = var.gcp_project_id
}
```

### 5. **Output Values**

Outputs show info after applying your infrastructure.

```hcl
output "bucket_url" {
  value = google_storage_bucket.my_bucket.url
}
```

### 6. **Modules**

A module is a reusable set of Terraform files.

**Use:**

```hcl
module "my_gcs_bucket" {
  source      = "../modules/gcs"
  bucket_name = "my-new-bucket"
}
```

### 7. **State**

Terraform keeps track of what it has built using a **state file** (`terraform.tfstate`).

* Local: stored in your folder
* Remote: in a bucket, for teams

### 8. **Plan and Apply**

* `terraform plan` — shows what changes will be made
* `terraform apply` — actually makes the changes
* `terraform destroy` — tears down what you’ve built

### 9. **Backend**

Where Terraform’s state is stored.

```hcl
terraform {
  backend "gcs" {
    bucket = "my-tfstate-bucket"
    prefix = "terraform/state/dev"
  }
}
```

### 10. **Sensitive Data & Secrets**

* Never put secrets in code!
* Pass them via GitHub Secrets (as in this repo).

### 11. **Best Practices**

* Use modules and version control
* Store state remotely
* Use CI/CD for safe, automatic applies

### 12. **Terraform CLI Basics**

* `terraform init`
* `terraform plan`
* `terraform apply`
* `terraform destroy`

---

Happy learning and deploying on GCP with Terraform! 🚀


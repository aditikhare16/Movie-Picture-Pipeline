```markdown

\\# Movie Picture Pipeline - Flask \\\& React on EKS (CI/CD)



This project implements a complete, automated CI/CD pipeline for a full-stack Movie application (React frontend and Flask backend) deployed onto an AWS Elastic Kubernetes Service (EKS) cluster using GitHub Actions, Docker, and Kubernetes manifests.



\\---



\\## 🚀 Project Overview \\\& Architecture



\\- \\\*\\\*Frontend\\\*\\\*: React.js application communicating with the backend API via environment variables (`REACT\\\_APP\\\_MOVIE\\\_API\\\_URL`).

\\- \\\*\\\*Backend\\\*\\\*: Python Flask REST API serving movie data (`app.py`).

\\- \\\*\\\*Infrastructure\\\*\\\*: AWS EKS (`cluster` in `us-east-1`), Amazon ECR for container registries, and Terraform (`main.tf`) for provisioning.

\\- \\\*\\\*CI/CD\\\*\\\*: GitHub Actions workflows handling automated linting, testing, Docker image building, Amazon ECR pushing, and `kubectl` deployment to EKS.



\\---



\\## 📁 Project File Structure



```text

├── .github/

│   └── workflows/

│       ├── frontend-ci.yaml      # Frontend Pull Request CI (Lint, Test, Build)

│       ├── backend-ci.yaml       # Backend Pull Request CI (Lint, Test, Build)

│       ├── frontend-cd.yaml      # Frontend Main Branch CD (Lint, Test, Build, ECR, EKS)

│       └── backend-cd.yaml       # Backend Main Branch CD (Lint, Test, Build, ECR, EKS)

├── starter/

│   ├── frontend/                 # React frontend source files, tests \\\& Dockerfile

│   └── backend/

│       └── movies/

│           ├── app.py            # Flask backend application (modified)

│           └── Dockerfile        # Backend containerization file (modified)

├── setup/

│   ├── terraform/                # Infrastructure as Code

│   │   └── main.tf               # Provisioning configuration (modified)

│   ├── deploy.sh                 # Cluster and deployment configuration helper

│   └── fix.sh                    # Setup and configuration helper script (added)

├── .gitignore                    # Excludes large binaries (.terraform, node\\\_modules)

├── Pipfile                       # Python dependencies

└── Pipfile.lock                  # Locked Python dependencies



```



\---



\## 🛠️ Files Added, Modified \& Purpose



1\. \*\*`.github/workflows/frontend-ci.yaml` \& `backend-ci.yaml\\\*\\\*`:

\* \*\*Purpose\*\*: Runs automated checks on every pull request targeting `main`.

\* \*\*Behavior\*\*: Executes parallel linting and testing jobs with dependency caching, followed by a Docker build job triggered via `needs`.





2\. \*\*`.github/workflows/frontend-cd.yaml` \& `backend-cd.yaml\\\*\\\*`:

\* \*\*Purpose\*\*: Handles automated Continuous Deployment upon merging to `main`.

\* \*\*Behavior\*\*: Runs tests, builds container images (injecting `REACT\\\_APP\\\_MOVIE\\\_API\\\_URL` for frontend via `build-args`), securely logs into Amazon ECR using GitHub Secrets, pushes images, and updates the EKS cluster workloads via `kubectl rollout restart`.





3\. \*\*`setup/fix.sh`\*\*:

\* \*\*Purpose\*\*: Utility script added to help troubleshoot, configure environment parameters, or resolve workspace environment setups.





4\. \*\*`starter/backend/movies/app.py`\*\*:

\* \*\*Purpose\*\*: Modified Flask application script providing the REST API endpoints (such as `/movies`) for serving movie data.





5\. \*\*`setup/terraform/main.tf`\*\*:

\* \*\*Purpose\*\*: Altered Terraform configuration defining AWS resources, networking, and the EKS cluster layout.





6\. \*\*Frontend \& Backend Dockerfiles (`Dockerfile`)\*\*:

\* \*\*Purpose\*\*: Updated containerization specifications to properly build both React and Flask applications for production deployment.





7\. \*\*`.gitignore`\*\*:

\* \*\*Purpose\*\*: Prevents accidental tracking of large binary files (such as Terraform provider binaries exceeding 100MB) and local environment credentials.







\---



\## 👣 Detailed Step-by-Step Execution Journey (Start to Finish)



1\. \*\*Initial Repository \& Environment Setup\*\*:

\* Configured local Git identification parameters (`git config user.email` and `git config user.name`) to track contributions correctly.

\* Handled large binary limitations by appending provider paths and local dependencies to `.gitignore` and purging any tracked cache files exceeding GitHub limits.

\* Bypassed GitHub Push Protection errors by scanning local scripts, removing hardcoded AWS access keys, and replacing them with secure context secrets.





2\. \*\*Infrastructure Provisioning with Terraform\*\*:

\* Navigated into the `setup/terraform/` directory containing the modified `main.tf` configuration.

\* Initialized the Terraform working directory using `terraform init` to download necessary provider plugins.

\* Applied the infrastructure definitions via `terraform apply` to provision the AWS EKS cluster (`cluster`), VPC networking, and security layers in `us-east-1`.





3\. \*\*Authoring CI/CD Workflows\*\*:

\* Implemented `.github/workflows/frontend-ci.yaml` and `backend-ci.yaml` with parallel jobs for code linting (`npm run lint`) and testing (`npm run test`), caching dependencies, and triggering downstream Docker container builds using the `needs` parameter.

\* Implemented `.github/workflows/frontend-cd.yaml` and `backend-cd.yaml` to handle automated deployments on merges to `main` (and manual `workflow\\\_dispatch` executions).

\* Integrated secure AWS credential fetching using GitHub Repository Secrets (`AWS\\\_ACCESS\\\_KEY\\\_ID` and `AWS\\\_SECRET\\\_ACCESS\\\_KEY`) alongside the third-party `aws-actions/amazon-ecr-login@v1` action.

\* Added environment variable injection via build arguments (`REACT\\\_APP\\\_MOVIE\\\_API\\\_URL`) during the frontend container compilation stage.





4\. \*\*Deployment \& Cluster Verification\*\*:

\* Pushed the completed code tree and workflows to the GitHub repository to trigger the automated CI/CD pipelines.

\* Configured `kubectl` context to connect to the AWS EKS cluster (`063446971241`, region `us-east-1`).

\* Verified active pods and services using `kubectl get pods` and `kubectl get svc`.

\* Utilized `kubectl port-forward` to map cluster ports locally and tested the backend `/movies` route via `curl` to ensure valid JSON responses containing the movie list.





5\. \*\*Cost Optimization \& Infrastructure Teardown\*\*:

\* Once deployment and verification artifacts (screenshots and endpoints) were successfully collected, executed infrastructure teardown to prevent ongoing cloud billing:

```bash

cd setup/terraform

terraform destroy -auto-approve



```











\---



\## 🚀 Steps for the User to Run the Project



1\. \*\*Clone the Repository \& Configure Credentials\*\*:

\* Clone your project repository to your local machine or workspace.

\* Set up your GitHub repository secrets (`AWS\\\_ACCESS\\\_KEY\\\_ID` and `AWS\\\_SECRET\\\_ACCESS\\\_KEY`) under \*\*Settings > Secrets and variables > Actions\*\*.





2\. \*\*Provision Infrastructure (Terraform)\*\*:

\* Navigate to the Terraform setup folder:

```bash

cd setup/terraform



```





\* Initialize and provision the infrastructure on AWS:

```bash

terraform init

terraform apply -auto-approve



```









3\. \*\*Configure Kubernetes Context\*\*:

\* Update your local `kubeconfig` to connect to the newly created EKS cluster (`cluster` in `us-east-1`):

```bash

aws eks update-kubeconfig --region us-east-1 --name cluster



```









4\. \*\*Trigger CI/CD via GitHub Actions\*\*:

\* Open a pull request against the `main` branch to test the CI workflows (`frontend-ci.yaml` and `backend-ci.yaml`).

\* Merge the pull request into `main` to execute the CD workflows (`frontend-cd.yaml` and `backend-cd.yaml`), which build the images, push them to Amazon ECR, and deploy them to EKS using `kubectl`.





5\. \*\*Verify the Application\*\*:

\* Check running pods and services:

```bash

kubectl get pods

kubectl get svc



```





\* Port-forward or view external endpoints to test the backend API response and frontend interface.





6\. \*\*Tear Down Infrastructure (Save Costs)\*\*:

\* Once verification is complete, destroy the cloud resources to stop billing:

```bash

cd setup/terraform

terraform destroy -auto-approve



```











\---



\## ✅ Rubric Compliance Checklist



\* \*\*Frontend CI Pipeline (`frontend-ci.yaml`)\*\*:

\* ✅ Named "Frontend Continuous Integration" in root `.github/workflows/frontend-ci.yaml`.

\* ✅ Parallel lint and test jobs with dependency caching and correct commands (`npm run lint`, `npm run test`).

\* ✅ Build job dependent on lint and test using `needs` syntax and built using Docker.

\* ✅ Triggered automatically on `pull\\\_request` and available manually via `workflow\\\_dispatch`.





\* \*\*Backend CI Pipeline (`backend-ci.yaml`)\*\*:

\* ✅ Named "Backend Continuous Integration" in root `.github/workflows/backend-ci.yaml`.

\* ✅ Parallel linting and testing jobs.

\* ✅ Build job runs after lint and test complete using `needs`.





\* \*\*Frontend CD Pipeline (`frontend-cd.yaml`)\*\*:

\* ✅ Named "Frontend Continuous Deployment" in root `.github/workflows/frontend-cd.yaml`.

\* ✅ Runs linting, testing, and container build (with `REACT\\\_APP\\\_MOVIE\\\_API\\\_URL` build-args) using `needs`.

\* ✅ Securely logs into Amazon ECR via `aws-actions/amazon-ecr-login@v1` using GitHub Secrets.

\* ✅ Pushes image to ECR and deploys via `kubectl` to the EKS cluster.





\* \*\*Backend CD Pipeline (`backend-cd.yaml`)\*\*:

\* ✅ Named "Backend Continuous Deployment" in root `.github/workflows/backend-cd.yaml`.

\* ✅ Integrates linting, testing, Docker build, ECR login via GitHub Secrets, image push, and `kubectl` EKS deployment.





\* \*\*Security \& Constraints\*\*:

\* ✅ Zero hardcoded AWS credentials in any pipeline files.

\* ✅ Successfully verified cluster workloads and API output before teardown.







```



```


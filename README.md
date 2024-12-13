# Deploying Node.js Application to Kubernetes Cluster with Helm Chart

This repository contains everything required to deploy this Node.js application to a Kubernetes cluster using Helm charts. The deployment process is automated via a GitHub Actions workflow. Autoscaling is enabled for the application, ensuring that whenever CPU utilization crosses 80%, additional replicas will be created to handle the load.

## Features

1. Dockerize the Node.js application and push the image to AWS ECR.
2. Deploy the Docker image to a Kubernetes cluster using Helm charts.
3. Autoscaling based on CPU utilization (threshold: 80%).
4. Post-deployment testing using `make test`, with results stored in GitHub Actions artifacts.

## Prerequisites

- **AWS Account**:
  - AWS CLI configured with sufficient permissions.
  - An ECR repository for storing the Docker image.
- **Kubernetes Cluster**: An existing Kubernetes cluster (e.g., AWS EKS).
- **Helm**: Installed for managing Kubernetes deployments ([Install Helm](https://helm.sh/docs/intro/install/)).
- **kubectl**: Installed and configured to interact with your Kubernetes cluster.
- **GitHub Repository**: A repository for hosting the source code and workflow configuration.
- **Terraform** (optional): For managing the Kubernetes infrastructure.
- **Create GitHub secrets**
  - AWS_ACCESS_KEY_ID
  - AWS_SECRET_ACCESS_KEY
  - AWS_REGION
  - AWS_ACCOUNT_ID
- **Load Testing** To perform load test, make sure you update APP_URL in the Makefile with the right application URL.

## Directory Structure

```
.
├── Dockerfile
├── chart/
│   └── templates/
│   └── values.yaml
├── src/
│   └── index.js
├── Makefile
├── .github/
│   └── workflows/
│       └── deploy-app.yml
├── README.md
```

## Steps to Use

### Step 1: Clone the Repository

```bash
git clone https://github.com/ajayjhala/todo-list-app
cd nodejs-k8s-helm
```

### Step 2: Push changes to GitHub repo

Push changes to the `main` branch to trigger the automated workflow.

```bash
git add .
git commit -m "Deploying app"
git push origin main
```

## GitHub Actions Workflow

### Workflow Location

The workflow file is located at `.github/workflows/deploy-app.yml`.

### Workflow Steps

1. **Build and Push Docker Image**:
   - The Node.js application is containerized using the `Dockerfile` and pushed to the AWS ECR repository.
2. **Deploy to Kubernetes**:
   - The application is deployed to the Kubernetes cluster using Helm.
3. **Run Post-Deployment Tests**:
   - `make test` is executed to ensure the application is functioning correctly.
   - The test results are stored as GitHub Actions artifacts for future reference.

### Example Workflow Trigger

```yaml
on:
  push:
    branches:
      - main
```

## Horizontal Pod Autoscaler (HPA)

The HPA configuration is defined in `chart/values.yaml`. It ensures the application scales up or down based on CPU utilization:

## Fault-Tolerance and Scaling Approach

### 1. Horizontal Pod Autoscaler (HPA) for Scaling
The Horizontal Pod Autoscaler (HPA) ensures the application can handle varying loads by automatically adjusting the number of pods based on resource utilization.

- **Scaling Trigger**: HPA is configured to monitor the CPU utilization of the pods. If the average CPU usage exceeds 80%, HPA scales up the number of pods to distribute the load effectively.
- **Scaling Down**: When CPU utilization decreases, HPA scales down the pods to optimize resource usage and cost.

### 2. Readiness and Liveness Probes for Fault Tolerance
Readiness and liveness probes enhance the fault-tolerance of the application by ensuring only healthy pods serve traffic and failed pods are replaced automatically.

- **Readiness Probes**: These probes check if the pod is ready to accept traffic. If a pod fails the readiness check, it is removed from the Service's endpoints until it recovers.
- **Liveness Probes**: These probes monitor the pod's health. If a liveness probe fails, Kubernetes restarts the pod to recover from failures like deadlocks or crashes.

## Running Tests

Testing is handled by a `Makefile`. Run tests locally with:

```bash
make test
```

The test results will also be uploaded as GitHub Actions artifacts after deployment.

## Access the app

If you want to run it locally, start the docker container with `docker compose up -d --build`. The to-do list app will be accessible at http://localhost:3000. 

While accessing it from the cloud, make sure right DNS record is created and replace `localhost` with the the DNS name.
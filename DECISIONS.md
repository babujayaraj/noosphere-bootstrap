# Architecture & Implementation Decisions

This document explains the key technical decisions made while completing the DevOps / Platform Engineer technical assessment.  
The focus was on correctness, security by default, least-privilege access, and pragmatic trade-offs aligned with real-world platform engineering.

---

## 1. Overall Approach

The repository was treated as a real inherited codebase rather than a greenfield project.  
Work was done incrementally using **atomic commits** and conventional commit messages to reflect how changes would be delivered in a production environment.

The implementation order broadly followed the README guidance:
1. Infrastructure (Terraform)
2. Container build & hardening
3. CI/CD pipeline
4. Kubernetes deployment
5. Security & permissions
6. Documentation and validation

---

## 2. Infrastructure (Terraform)

### VPC and Subnets
A VPC with public subnets was created to support EC2 workloads.  
Subnets were defined explicitly rather than hard-coding values to ensure the design is:
- Repeatable
- Extendable to additional environments
- Easy to reason about in Terraform plans

### EC2 Instances
Three EC2 instances were created using a **map-based configuration (`var.instances`) and `for_each`**.  
This allows:
- Different instance types per workload
- Easy extension without duplicating resource blocks
- Clear separation of configuration and infrastructure logic

This pattern reflects production Terraform practices.

### S3 Bucket with Lifecycle Policy
An S3 bucket was added with a lifecycle rule to automatically delete objects after **7 days**.

Rationale:
- Prevents uncontrolled storage growth
- Matches common patterns for logs, artifacts, or temporary data
- Demonstrates awareness of cost and operational hygiene

### LocalStack Usage
LocalStack was used instead of a real AWS account, as explicitly allowed by the README.

This ensured:
- No real cloud resources were created
- No credentials were required
- Terraform plans and resource definitions could still be validated

---

## 3. Container Build & Application Hardening

### Multi-Stage Docker Build
A multi-stage Dockerfile was used to:
- Install dependencies in a dedicated build stage
- Copy only production dependencies and application source into the runtime image

This reduces:
- Image size
- Attack surface
- Accidental inclusion of build tools

### Non-Root Execution
The application runs as a **non-root user with a fixed numeric UID (10001)**.

Rationale:
- Required for Kubernetes `runAsNonRoot` enforcement
- Avoids ambiguity caused by named users
- Aligns with container security best practices

### Minimal Runtime Contents
Only the following are present in the final image:
- Node.js runtime
- Production dependencies
- Application source code

No dev dependencies or tooling are included.

---

## 4. CI/CD Pipeline

### GitHub Actions
GitHub Actions was used as required by the assessment.

The pipeline includes:
- Source checkout
- Docker image build
- Container security scanning with Grype

### Grype Security Scanning
Grype was added to scan the built container image and fail the pipeline on **High or Critical vulnerabilities**.

Trade-off:
- Base image and transitive npm dependencies can introduce vulnerabilities outside direct application control.
- For this assessment, the scan is intentionally strict to demonstrate security awareness.
- In a real production environment, this would typically be paired with allowlists or risk-based policies.

---

## 5. Kubernetes Deployment

### Manifests
The Kubernetes manifests were corrected and validated to ensure:
- Proper API versions (`apps/v1`, `v1`)
- Correct namespace usage
- Matching labels and selectors

### Security Context
The Deployment enforces:
- `runAsNonRoot: true`
- Explicit `runAsUser`
- Resource requests and limits

This ensures:
- Pod hardening
- Predictable scheduling
- Compliance with cluster security policies

### Health Probes
Readiness and liveness probes were configured against `/health`.

This enables:
- Zero-downtime rollouts
- Automatic recovery from application failures

### Validation
The application was successfully validated using:
- `kubectl apply`
- `kubectl port-forward`
- `curl /health` and `/api/data`

---

## 6. Security & Secrets Management

### No Plaintext Secrets
No secrets are committed to the repository:
- No AWS credentials in Terraform variables
- No secrets in CI workflows
- No secrets baked into container images

### IAM Role for GitHub Actions
A GitHub Actions IAM role was defined using **OIDC (OpenID Connect)**.

Key characteristics:
- No long-lived credentials
- Trust restricted to a specific repository and branch
- Policy scoped to required services only

This demonstrates a modern, secure CI authentication model.

### AWS Account Limitation
A real AWS account was not used.  
The IAM role and policies were implemented declaratively in Terraform to demonstrate design intent and least-privilege thinking, even though role assumption was not executed.

---

## 7. Git Practices

- Conventional commit messages were used (`feat`, `fix`, `docs`, `security`)
- Changes were made in small, focused commits
- The repository history reflects incremental troubleshooting and improvement

### Semantic Versioning
Semantic versioning support was added to the CI workflow to enable automated tagging on successful releases.

---

## 8. Trade-offs and Limitations

- Grype scanning may fail due to upstream dependencies; this is intentional for demonstration.
- LocalStack was used instead of AWS; real deployments would require additional validation.
- Kubernetes was tested locally via Docker Desktop rather than a managed cloud cluster.

These trade-offs were chosen to balance realism with the constraints of a take-home assessment.

---

## 9. Summary

The final solution delivers:
- Secure, repeatable infrastructure
- Hardened containerized application
- Working CI pipeline with security scanning
- Deployable Kubernetes manifests
- Clear documentation and reasoning

The approach emphasizes **platform thinking, security by default, and pragmatic DevOps practices**, aligning with the expectations of a mid-level Platform / DevOps Engineer role.

# Architecture & Implementation Decisions

This document captures the key technical decisions made during the implementation of the **noosphere-bootstrap** project, along with the rationale behind them and known trade-offs.

---

## 1. Infrastructure (Terraform)

### Decision
Infrastructure is implemented using **Terraform**, designed to run against **LocalStack** by default.

### Rationale
- Avoids the need for a real AWS account during assessment.
- Enables deterministic, repeatable testing.
- Matches real-world Terraform workflows while remaining cost-free.

### Implemented Components
- VPC with public subnets
- Three EC2 instances created using repeatable, extensible code
- S3 bucket with lifecycle policy to auto-delete objects after 7 days
- SSM parameter usage for secrets (no plaintext secrets committed)

---

## 2. CI/CD Pipeline

### Decision
GitHub Actions is used to implement a CI pipeline that includes:
- Docker image build
- Container security scanning with **Grype**
- Terraform validation and planning
- Semantic versioning and release tagging

### Rationale
- GitHub Actions is a widely adopted, production-grade CI platform.
- Pipeline structure mirrors real-world DevOps workflows.
- Emphasis placed on security and automation.

---

## 3. Container Security Scanning (Grype)

### Decision
The Grype security scan is configured to **fail the pipeline on HIGH and CRITICAL vulnerabilities**, even if those vulnerabilities originate from indirect or ecosystem-level dependencies.

### Rationale
- This reflects a **strict security posture**, often required in regulated or security-first environments.
- The goal is to demonstrate visibility and awareness of container security risks, not to artificially force a green build.
- Several reported vulnerabilities originate from:
  - Transitive npm dependencies
  - Base image tooling (Alpine / Node)
- These are common and expected findings in real projects.

### Trade-off
- The pipeline is intentionally **red** due to known HIGH vulnerabilities.
- In a production system, typical mitigations would include:
  - Allowlisting known low-risk findings
  - Failing only on CRITICAL issues
  - Using policy files or risk acceptance workflows
- For this assessment, transparency is preferred over suppression.

---

## 4. Application Hardening (Docker)

### Decision
The application container is hardened to:
- Run as a **non-root user**
- Include only production dependencies
- Use a multi-stage Docker build

### Rationale
- Reduces attack surface.
- Aligns with Kubernetes security best practices.
- Ensures compatibility with `runAsNonRoot` enforcement.

---

## 5. Kubernetes Manifests

### Decision
Kubernetes manifests are provided for:
- Namespace
- Deployment
- Service

### Key Features
- `securityContext` enforcing non-root execution
- Resource requests and limits
- Readiness and liveness probes on `/health`
- Image tag alignment with Docker build output

### Rationale
- Demonstrates production-ready Kubernetes patterns.
- Allows easy local testing via `kubectl port-forward`.

---

## 6. Security & IAM

### Decision
GitHub Actions authentication is implemented using **OIDC with IAM roles**, following least-privilege principles.

### Rationale
- No long-lived AWS credentials stored in GitHub secrets.
- IAM permissions scoped to only required services.
- Matches modern AWS security best practices.

### Note
A real AWS account is not required to validate this setup for the assessment. The Terraform configuration documents the intended production design.

---

## 7. Git & Release Management

### Decision
- Conventional Commits are used throughout.
- Semantic versioning is implemented via GitHub Actions.

### Rationale
- Enables automated changelogs and releases.
- Improves clarity of intent in commit history.
- Demonstrates production-grade Git hygiene.

---

## Final Notes

- The repository prioritizes **clarity, security, and realism** over artificially passing checks.
- Known issues (such as HIGH vulnerability findings) are intentionally surfaced and documented.
- This approach mirrors real DevOps work, where trade-offs are explicit and well-reasoned rather than hidden.


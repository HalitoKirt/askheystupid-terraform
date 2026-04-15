# AskHeyStupid

**A fully serverless AI-powered Q&A web application** built with modern AWS services and managed entirely through Terraform.

Users can ask silly, serious, or creative questions and receive instant responses powered by Amazon Bedrock.

Live Demo: [https://askheystupid.com](https://askheystupid.com)
---

## Project Overview

This project is a complete Terraform rebuild of my existing live web application (AskHeyStupid). The goal was to move from a manually deployed setup to a professional, secure, and fully Infrastructure as Code (IaC) managed environment.

Special emphasis was placed on blending **development best practices** with **strong cloud security and compliance** — reflecting the increasing overlap between Dev and Security roles in modern cloud environments.

---

## Architecture

- **Frontend**: Static website hosted on Amazon S3 with global distribution via CloudFront + WAF
- **Backend**: REST API using Amazon API Gateway + AWS Lambda (integrated with Amazon Bedrock)
- **AI Layer**: Amazon Bedrock (Claude 3.5 Haiku)
- **Infrastructure**: Fully managed with Terraform using a remote S3 backend + DynamoDB state locking
- **Region**: `us-east-2`
- **Security & Observability**: WAF, CloudWatch, AWS Config, Security Hub, GuardDuty, and centralized logging

---

## Key Design Decisions & Rationale

### 1. Serverless-First Architecture
**Decision**: Chose a completely serverless stack (S3 + CloudFront + API Gateway + Lambda + Bedrock).  
**Why**:  
- Minimizes operational overhead and eliminates server management.  
- Pay-per-use pricing keeps costs low while supporting automatic scaling.  
- Rejected EC2/ECS due to added complexity and higher operational burden.

### 2. Frontend Hosting (S3 + CloudFront)
**Decision**: Static website on S3 with CloudFront distribution and WAF.  
**Why**:  
- Best practice for static content delivery with excellent global performance and edge caching.  
- CloudFront provides free HTTPS and compression.  
- Chose this over AWS Amplify to maintain full control through Terraform.

### 3. Backend (API Gateway + Lambda)
**Decision**: HTTP API Gateway fronting Lambda functions that call Bedrock.  
**Why**:  
- Clean separation between frontend and backend while staying fully serverless.  
- API Gateway provides built-in rate limiting, CORS, and request validation.  
- Lambda offers fine-grained cost control and easy Bedrock integration.

### 4. Terraform Remote Backend (S3 + DynamoDB)
**Decision**: Used S3 backend with DynamoDB state locking instead of local state.  
**Why**:  
- Enables safe collaboration and future CI/CD integration.  
- Prevents state corruption from concurrent operations.  
- Demonstrates understanding of real-world Terraform practices.

---

## Security & Compliance Approach (First-Class Concern)

Security was treated as a **first-class citizen** throughout the design and implementation of this project.

### Intentional Over-engineering for Demonstration

While AskHeyStupid is a small, low-traffic application, I intentionally applied several enterprise-grade security and compliance controls that would normally be seen in much larger production environments. This was done deliberately to demonstrate deep understanding of cloud security engineering practices, even when they exceed the minimum requirements for a project of this scale.

**Security Features Implemented:**

**Infrastructure Security**
- Least-privilege IAM roles and policies for all services (Lambda, CloudFront, API Gateway)
- WAF Web ACL attached to CloudFront with AWS Managed Rules (Core rule set + SQL injection + XSS protection)
- Encryption at rest and in transit for all components
- S3 buckets with public access fully blocked and server-side encryption enforced

**Observability & Logging**
- Centralized S3 logging bucket for CloudFront access logs, API Gateway execution logs, and WAF logs
- CloudWatch Log Groups with appropriate retention periods for Lambda and API Gateway
- CloudWatch alarms for error rates, high latency, and throttled requests

**Compliance & Threat Detection**
- AWS Config Recorder with selected CIS AWS Foundations Benchmark rules
- Security Hub enabled with AWS Foundational Security Best Practices and CIS AWS Foundations standards
- GuardDuty already active on the account (findings visibility maintained)

**Manual Security Work Performed**
Prior to this Terraform rebuild, I manually remediated all Critical and High findings and resolved approximately 50% of Medium findings in Security Hub. This IaC version aims to prevent regression of those issues through code-defined, auditable controls.

**Design Decisions & Trade-offs**
I acknowledge that enabling full Security Hub standards + AWS Config + GuardDuty on a small personal project is somewhat overkill from a pure cost/complexity perspective. However, this approach allowed me to showcase real-world skills in cloud posture management, threat detection, compliance-as-code, and secure infrastructure design — skills increasingly expected as Dev and Security roles continue to converge.

---

## Project Structure

```bash
askheystupid-terraform/
├── backend.tf
├── main.tf
├── variables.tf
├── outputs.tf
├── terraform.tfvars
├── modules/
│   ├── frontend/      # S3 + CloudFront + WAF + logging
│   ├── backend/       # Lambda + API Gateway + Bedrock
│   ├── security/      # IAM, WAF rules, Config, Security Hub
│   └── logging/       # Centralized logging bucket + CloudWatch
├── docs/
└── README.md

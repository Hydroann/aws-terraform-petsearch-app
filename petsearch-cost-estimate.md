# 💰 PetSearch — AWS Cost Estimate

**Region:** us-west-2 (Oregon) | **Pricing:** On-Demand | **Date:** May 2026

---

## EC2 — Compute

| Resource | Qty | Hours/mo | $/hr | $/mo each | Total $/mo |
|---|---|---|---|---|---|
| EC2 t3.small (ASG desired=2) | 2 | 730 | $0.0208 | $15.18 | $30.37 |
| EC2 t3.small (Bastion) | 1 | 730 | $0.0208 | $15.18 | $15.18 |
| EC2 t3.small (standalone webserver) | 1 | 730 | $0.0208 | $15.18 | $15.18 |
| EBS gp3 20 GB root (× 4 instances) | 4 | — | $0.08/GB | $1.60 | $6.40 |
| **EC2 Subtotal** | | | | | **≈ $67.13** |

> During scale-out events (ASG max=3), an additional t3.small may run, raising EC2 costs to ~$80/mo.

---

## RDS — MySQL Multi-AZ

| Resource | $/hr | Hours/mo | $/mo |
|---|---|---|---|
| db.t3.micro MySQL Multi-AZ | $0.034 | 730 | $24.82 |
| Storage: 20 GB gp2 (Multi-AZ = 2 × 20 GB billed) | $0.115/GB | — | $4.60 |
| **RDS Subtotal** | | | **≈ $29.42** |

---

## Application Load Balancer

| Resource | Rate | Qty/mo | $/mo |
|---|---|---|---|
| ALB fixed charge | $0.0225/hr | 730 hr | $16.43 |
| LCU (est. light traffic, 0.5 LCU avg) | $0.008/LCU-hr | 365 LCU-hr | $2.92 |
| **ALB Subtotal** | | | **≈ $19.35** |

---

## NAT Gateway

| Resource | Rate | Qty/mo | $/mo |
|---|---|---|---|
| NAT Gateway fixed | $0.045/hr | 730 hr | $32.85 |
| Data processed (est. 50 GB/mo) | $0.045/GB | 50 GB | $2.25 |
| Elastic IP (attached — no charge) | $0.00 | — | $0.00 |
| **NAT Subtotal** | | | **≈ $35.10** |

> ⚠️ The NAT Gateway fixed fee is the single largest cost driver. Consider S3/DynamoDB VPC Endpoints to eliminate per-GB charges for those services.

---

## Amazon S3

| Resource | Rate | Qty/mo | $/mo |
|---|---|---|---|
| Storage (2 buckets, est. 50 GB total) | $0.023/GB | 50 GB | $1.15 |
| PUT/COPY/POST requests (est. 100K) | $0.005/1K | 100K | $0.50 |
| GET requests (est. 500K) | $0.0004/1K | 500K | $0.20 |
| **S3 Subtotal** | | | **≈ $1.85** |

---

## SNS, CloudWatch & Data Transfer

| Resource | Notes | $/mo |
|---|---|---|
| SNS email notifications (est. 1,000/mo) | First 1K emails free | $0.00 |
| CloudWatch alarms (2 alarms) | $0.10/alarm/mo | $0.20 |
| CloudWatch metrics (EC2/RDS standard) | Included free | $0.00 |
| Data transfer out to internet (est. 20 GB) | First 100 GB @ $0.09/GB | $1.80 |
| **Other Subtotal** | | **≈ $2.00** |

---

## 📊 Grand Total — Monthly Summary

| Service | Monthly (USD) | Annual (USD) |
|---|---|---|
| EC2 (3 × t3.small + EBS, steady state) | $67.13 | $805.56 |
| RDS MySQL Multi-AZ (db.t3.micro + 20 GB) | $29.42 | $353.04 |
| Application Load Balancer | $19.35 | $232.20 |
| NAT Gateway (fixed + 50 GB data) | $35.10 | $421.20 |
| Amazon S3 (50 GB + requests) | $1.85 | $22.20 |
| SNS + CloudWatch + Data Transfer | $2.00 | $24.00 |
| **TOTAL (on-demand, steady state)** | **≈ $154.85** | **≈ $1,858** |

---

## 💡 Scenarios & Optimisation Options

| Scenario | Change | Est. Monthly | Savings vs. Baseline |
|---|---|---|---|
| Baseline (on-demand, steady state) | — | $154.85 | — |
| 1-Year Reserved Instances (EC2 + RDS) | ~40% off compute | ≈ $120 | ≈ $35/mo |
| ASG scale-in to 1 instance (nights/weekends) | Reduce EC2 hours | ≈ $135 | ≈ $20/mo |
| Stop bastion when not in use | Manual stop/start | ≈ $145 | ≈ $10/mo |
| High traffic (ASG at max=3) | +1 EC2 t3.small | ≈ $170 | N/A (higher cost) |

---

## 🔑 Key Cost Optimisation Recommendations

1. **Purchase Reserved Instances** — 1-Year RIs for EC2 (t3.small) and RDS (db.t3.micro) save ~40% on compute, the fastest payback available.
2. **Add VPC Endpoints for S3** — eliminates NAT Gateway data charges for S3 traffic (pet images, ALB logs), which currently passes through the $0.045/GB NAT meter.
3. **Schedule the bastion host** — use an EventBridge rule to stop the bastion automatically outside working hours (~$10/mo saving).
4. **Scale-in at night** — set a scheduled ASG action to reduce desired capacity to 1 during off-peak hours.
5. **Review S3 lifecycle rules** — transition older pet images to S3 Standard-IA (>30 days) or Glacier (>90 days) to reduce storage costs as the bucket grows.

---

> **Disclaimer:** Estimates are based on AWS on-demand pricing for us-west-2 as of May 2026 and are for planning purposes only. Actual costs depend on traffic volume, data transfer, and storage growth. Verify current rates at [calculator.aws](https://calculator.aws).

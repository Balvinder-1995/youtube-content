# KEDA SQS Scaler Setup

This directory contains resources to demonstrate and configure autoscaling based on Amazon SQS queue metrics using [KEDA](https://keda.sh/) (Kubernetes Event-driven Autoscaling).

## Directory Structure

*   `deployment.yaml` - Contains a sample Nginx Application deployment structure alongside a generic ServiceAccount configuration.
*   `sqs-scaler.yaml` - Demonstrates a KEDA `ScaledObject` and `TriggerAuthentication` resource configuration targeting the Nginx Application. It shows how SQS can be utilized as a scaling dimension utilizing AWS Pod Identity for permissions.
*   `multiple-consumers/` - A directory showcasing how to horizontally scale multiple independent applications/consumers based off separated SQS queues in parallel.

## Prerequisites

Before applying these configuration files, you'll need the following:
*   A running Kubernetes cluster with KEDA installed.
*   An AWS account with active SQS queues to read metrics from. 
*   An IAM role equipped with the necessary permissions to read SQS, which can be assumed via IAM Roles for Service Accounts (IRSA) / EKS Pod Identities.

## Usage Guide

The KEDA definitions located in this directory are parameterized for safety and reusability. Before deploying, please apply and replace the following placeholder variables inside `sqs-scaler.yaml` and the `multiple-consumers` YAMLs:

*   `{{AWS_ACCOUNT_ID}}` — Your 12-digit AWS Account ID.
*   `{{AWS_REGION}}` — The AWS region of your SQS queue (e.g., `us-east-1`, `ap-south-1`).
*   `{{QUEUE_NAME}}` — The identifier/name of the specific SQS queue.

Once updated with your environment details, apply the configuration:

```bash
# To deploy the single application example:
kubectl apply -f deployment.yaml
kubectl apply -f sqs-scaler.yaml

# To deploy the multiple consumer example:
kubectl apply -f multiple-consumers/
```

# Grafana installation, dashboard creation, setup of alerts

## Overview

This is software part of task 9.

This task have main point to configure Grafana Alerting to send alerts for specific events in your Kubernetes (K8s) cluster and verify that the alerts are received.

## Requirements

To deploy this software you need running cluster, which can be deployed with from task9 folder with infrastructure terraform scripts [Folder with terraform scripts](https://github.com/thirdmadman/rsschool-devops-course-tasks/tree/task-9/task_9)

### Prepare the infrastructure

Deploy infrastructure from [Folder with terraform scripts](https://github.com/thirdmadman/rsschool-devops-course-tasks/tree/task-9/task_9)

Obtain the public IP address of bastion/nat host and private IP address of main node from the output of terraform of the task3.

example of terraform output:

```bash
ec2_k3s_main_instance_private_ip = "10.0.3.10"
ec2_nat_gw_instance_private_ip = "10.0.1.133"
ec2_nat_gw_instance_public_ip = "16.171.116.246"
```

### Prepare GHA environment

Add the GH secrets to this repository:

- SSH_IP_BASTION - Public IP address of bastion/nat host
- SSH_IP_MAIN_NODE - Private IP address of main node
- SSH_PRIVATE_KEY_BASION - Private key of bastion/nat host
- SSH_PRIVATE_KEY_MAIN_NODE - Private key of main node
- SSH_USER_BASTION - Username of bastion/nat host
- SSH_USER_MAIN_NODE - Username of main node

To set up these secrets, follow these steps:

#### Set up Github Secrets

1. Log in to your Github account and navigate to your repository.
2. Click on the "Settings" icon (looks like a gear) next to your repository name.
3. Select "Actions" from the left-hand menu.
4. Scroll down to the "Secrets" section.
5. Click on the "New secret" button.
6. Enter the following secrets and their corresponding values for the list above

### Install Prometheus

To install this software on your cluster, you need to have previously installed prometheus from this repository.

You can find the installation instructions for prometheus here [Prometheus Setup](../prometheus/README.md)

### Github repository secrets for Grafana

To run installation workflow in via GHA you need to create new secrets in your repository.

- ADMIN_PASSWORD - Grafana admin password
- SMTP_HOST - SMTP host
- SMTP_USER - SMTP user
- SMTP_PASSWORD - SMTP password
- SMTP_FROM_ADDRESS - SMTP from address


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

### Setup SMTP

In this particular variation will be used AWS SES to deliver email notifications.
To set up AWS SES, follow these steps:

- Go to your AWS console and find SES service
- In AWS SES console go to Configuration -> Identities and click on "Create new identity"
- In Create identity -> Identity details  -> Select "Email address"
- In Email address -> Enter the email address for the Grafana Alerts service to which you want to receive email notifications
- Click on the "Create identity" button
- Go to your email address you entered and find email for the verification and verify that you are owner of the email
- In AWS SES console go to SMTP Settings and click on "Create SMTP credentials"
- In Specify user details -> Create user for SMTP -> User name input username for SMTP
- Click Create user
- After creating the SMTP user, you'll be provided with option to download the credentials.

You can also find SMTP endpoint in AWS SES console under SMTP Settings, it will be needed in the next steps.

### Github repository secrets for Grafana

To run installation workflow in via GHA you need to create new secrets in your repository.

For SMTP credentials you need to use previously created SMTP user in AWS SES.

- GRAFANA_ADMIN_PASSWORD -- Grafana admin password
- GRAFANA_SMTP_HOST -- Grafana SMTP host
- GRAFANA_SMTP_USER  -- Grafana SMTP user
- GRAFANA_SMTP_PASSWORD  -- Grafana SMTP password
- GRAFANA_SMTP_FROM_ADDRESS  -- Grafana SMTP from address

#### Run GHA workflow manually

1. Click on the "Actions" tab.
2. Find and click on "Github Actions workflow for deployment wordpress on k3s cluster"
3. Find and click on button "Run workflow" in action section.

## Verification

### Basic deployment verification

To verify that the deployment was successful, you can check public IP of the k3s cluster, on the port 3000 should be available Grafana wev interface.

Log in into system using previously created admin password.

Due to successful deployment in Grafana will be created:

- in Dashboard section in folder dashboards will be created dashboards with metrics for k3s cluster
- in Alerting section in Rules in folder dashboards will be created two rules for one for CPU and one for Memory
- in Alerting section in Contact points will be created contact point "admin" with email you provided in Github secret

### Alerting verification

To verify that the alerting is working, you can create test load on you node of k3s cluster.
To do this, you need install package "stress-ng" on your node.

To run cpu test load on your node:

```stress-ng -c 2 -t 180s```

To run memory test load on your node:

```stress-ng -m 1 --vm-bytes 1024M  -t 180s```

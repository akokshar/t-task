# Task

You've joined a new and growing startup.

The company wants to build its initial Kubernetes infrastructure on AWS. The team wants to leverage the latest autoscaling capabilities by Karpenter, as well as utilize Graviton and Spot instances for better price/performance.
They have asked you if you can help create the following:
Terraform code that deploys an EKS cluster (whatever latest version is currently available) into an existing VPC
The terraform code should also deploy Karpenter with node pool(s) that can deploy both x86 and arm64 instances
Include a short readme that explains how to use the Terraform repo and that also demonstrates how an end-user (a developer from the company) can run a pod/deployment on x86 or Graviton instance inside the cluster.

# Terraform

Create S3 bucket named `test-42782cc1-0456-4125-9303-fed1b79d84e5`.
Authenticate to the AWS in your terminal (run `aws s3 ls` to test).

Run the following, review changes and approve saying `yes`

```sh
cd cluster
terraform init
terraform apply
```

```sh
cd cluster_config
terraform init
terraform apply
```

# Workload execution

To run on `graviton` machine, `pod` specification should have:

```yaml
    spec:
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: environment
                operator: In
                values:
                - "alex-arm"
      tolerations:
      - effect: NoSchedule
        key: node-pool
        operator: Equal
        value: alex-arm
```

To run on `amd64` machine, `pod` specivication should have:

```yaml
    spec:
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: environment
                operator: In
                values:
                - "alex-x86"
      tolerations:
      - effect: NoSchedule
        key: node-pool
        operator: Equal
        value: alex-x86
```



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

# Test

Apply test manifests:

```sh
cd manifests
kubectl apply -f ./
```

Check pods status (node provisioning may take couple of minutes):

```text
⟫ kubectl get pods -o wide
NAME   READY   STATUS    RESTARTS   AGE   IP            NODE                                        NOMINATED NODE   READINESS GATES
arm    1/1     Running   0          10m   10.0.44.116   ip-10-0-47-146.eu-west-2.compute.internal   <none>           <none>
x86    1/1     Running   0          13m   10.0.35.204   ip-10-0-39-2.eu-west-2.compute.internal     <none>           <none>

⟫ kubectl get nodeclaims.karpenter.sh
NAME             TYPE        CAPACITY   ZONE         NODE                                        READY   AGE
alex-arm-8tk5g   t4g.small   spot       eu-west-2a   ip-10-0-47-146.eu-west-2.compute.internal   True    10m
alex-x86-std66   t2.micro    spot       eu-west-2a   ip-10-0-39-2.eu-west-2.compute.internal     True    13m

⟫ kubectl get node -o custom-columns="NAME:.metadata.name,ARCH:.metadata.labels.kubernetes\.io/arch" 
NAME                                        ARCH
ip-10-0-35-174.eu-west-2.compute.internal   arm64
ip-10-0-37-233.eu-west-2.compute.internal   arm64
ip-10-0-39-2.eu-west-2.compute.internal     amd64
ip-10-0-47-146.eu-west-2.compute.internal   arm64
```

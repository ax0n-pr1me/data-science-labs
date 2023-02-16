# GPU JupyterHub Setup - Part 4

## Install JupyterHub

### Initialize a Helm chart configuration file

(As of version 1.0.0, you don’t need any configuration to get started so you can just create a config.yaml file with some helpful comments.)

create helpful [config.yaml](../files//config.yaml)

### Configure Helm

Make Helm aware of the JupyterHub Helm chart repository so you can install the JupyterHub chart from it without having to use a long URL name.

```{sh}
helm repo add jupyterhub https://jupyterhub.github.io/helm-chart/
helm repo update
kubectl config view --raw > ~/.kube/config
```

### Run Config

```{sh}
helm upgrade \
    --cleanup-on-fail  \
    --install 2.0.0  jupyterhub/jupyterhub   \
    --namespace data-lab   \
    --create-namespace   \
    --version=2.0.0   \
    --values ./kube_config/config.yaml
```

```{sh}
  sysadmin@txgpu1:~$ helm upgrade --cleanup-on-fail  --install 2.0.0  jupyterhub/jupyterhub   --namespace data-lab   --create-namespace   --version=2.0.0   --values ./kube_config/config.yaml
WARNING: Kubernetes configuration file is group-readable. This is insecure. Location: /home/sysadmin/.kube/config
WARNING: Kubernetes configuration file is world-readable. This is insecure. Location: /home/sysadmin/.kube/config
Release "2.0.0" does not exist. Installing it now.
NAME: 2.0.0
LAST DEPLOYED: Thu Oct 20 20:29:02 2022
NAMESPACE: data-lab
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
.      __                          __                  __  __          __
      / / __  __  ____    __  __  / /_  ___    _____  / / / / __  __  / /_
 __  / / / / / / / __ \  / / / / / __/ / _ \  / ___/ / /_/ / / / / / / __ \
/ /_/ / / /_/ / / /_/ / / /_/ / / /_  /  __/ / /    / __  / / /_/ / / /_/ /
\____/  \__,_/ / .___/  \__, /  \__/  \___/ /_/    /_/ /_/  \__,_/ /_.___/
              /_/      /____/

       You have successfully installed the official JupyterHub Helm chart!

### Installation info

  - Kubernetes namespace: data-lab
  - Helm release name:    2.0.0
  - Helm chart version:   2.0.0
  - JupyterHub version:   3.0.0
  - Hub pod packages:     See https://github.com/jupyterhub/zero-to-jupyterhub-k8s/blob/2.0.0/images/hub/requirements.txt

### Followup links

  - Documentation:  https://z2jh.jupyter.org
  - Help forum:     https://discourse.jupyter.org
  - Social chat:    https://gitter.im/jupyterhub/jupyterhub
  - Issue tracking: https://github.com/jupyterhub/zero-to-jupyterhub-k8s/issues

### Post-installation checklist

  - Verify that created Pods enter a Running state:

      kubectl --namespace=data-lab get pod

    If a pod is stuck with a Pending or ContainerCreating status, diagnose with:

      kubectl --namespace=data-lab describe pod <name of pod>

    If a pod keeps restarting, diagnose with:

      kubectl --namespace=data-lab logs --previous <name of pod>

  - Verify an external IP is provided for the k8s Service proxy-public.

      kubectl --namespace=data-lab get service proxy-public

    If the external ip remains <pending>, diagnose with:

      kubectl --namespace=data-lab describe service proxy-public

  - Verify web based access:

    You have not configured a k8s Ingress resource so you need to access the k8s
    Service proxy-public directly.

    If your computer is outside the k8s cluster, you can port-forward traffic to
    the k8s Service proxy-public with kubectl to access it from your
    computer.

      kubectl --namespace=data-lab port-forward service/proxy-public 8080:http

    Try insecure HTTP access: http://localhost:8080
```

### Getting Busy

```{sh}
type _init_completion #check for bash-completion
kubectl completion bash
```

```{sh}
# set default value for namespace
kubectl config set-context $(kubectl config current-context) --namespace data-lab
```

```{sh}
sysadmin@txgpu1:~$ kubectl get pod --namespace data-lab
NAME                              READY   STATUS    RESTARTS   AGE
user-scheduler-7f696ddc6c-7qnqw   1/1     Running   0          5m34s
continuous-image-puller-cz6mw     1/1     Running   0          5m34s
proxy-6bfff4cf96-rsdgg            1/1     Running   0          5m34s
user-scheduler-7f696ddc6c-sc7hj   1/1     Running   0          5m34s
hub-96bd54d-rc7db                 1/1     Running   0          5m34s
```

```{sh}
sysadmin@txgpu1:~$ kubectl get service proxy-public
NAME           TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
proxy-public   LoadBalancer   10.152.183.54   10.10.27.50   80:31204/TCP   9m36s
```

## Open EXTERNAL-IP in your browser

We did it!

Any username and pw will work... this is the dummy auth config.

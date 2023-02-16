# GPU JupyterHub Setup - Part 2

## MicroK8s

### Networking

```{sh}
microk8s enable metallb:10.10.27.50-10.10.27.60
```

### Storage

```{sh}
sudo systemctl enable iscsid.service
microk8s enable community
microk8s enable openebs
```

```{sh}
Infer repository community for addon openebs
Infer repository core for addon dns
Addon core/dns is already enabled
Infer repository core for addon helm3
Addon core/helm3 is already enabled
"openebs" has been added to your repositories
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "openebs" chart repository
Update Complete. ⎈Happy Helming!⎈
NAME: openebs
LAST DEPLOYED: Thu Oct 20 19:48:11 2022
NAMESPACE: openebs
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
Successfully installed OpenEBS.

Check the status by running: kubectl get pods -n openebs

The default values will install NDM and enable OpenEBS hostpath and device
storage engines along with their default StorageClasses. Use `kubectl get sc`
to see the list of installed OpenEBS StorageClasses.

**Note**: If you are upgrading from the older helm chart that was using cStor
and Jiva (non-csi) volumes, you will have to run the following command to include
the older provisioners:

helm upgrade openebs openebs/openebs \
 --namespace openebs \
 --set legacy.enabled=true \
 --reuse-values

For other engines, you will need to perform a few more additional steps to
enable the engine, configure the engines (e.g. creating pools) and create
StorageClasses.

For example, cStor can be enabled using commands like:

helm upgrade openebs openebs/openebs \
 --namespace openebs \
 --set cstor.enabled=true \
 --reuse-values

For more information,
- view the online documentation at https://openebs.io/ or
- connect with an active community on Kubernetes slack #openebs channel.
OpenEBS is installed


-----------------------

When using OpenEBS with a single node MicroK8s, it is recommended to use the openebs-hostpath StorageClass
An example of creating a PersistentVolumeClaim utilizing the openebs-hostpath StorageClass


kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: local-hostpath-pvc
spec:
  storageClassName: openebs-hostpath
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5G



-----------------------

If you are planning to use OpenEBS with multi nodes, you can use the openebs-jiva-csi-default StorageClass.
An example of creating a PersistentVolumeClaim utilizing the openebs-jiva-csi-default StorageClass


kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: jiva-volume-claim
spec:
  storageClassName: openebs-jiva-csi-default
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5G
```

Create [local-storage-dir.yaml](../files/local-storage-dir.yaml) with path to volume.

```{sh}
microk8s.kubectl apply -f local-storage-dir.yaml
```

### troubleshooting

```{sh}
microk8s.kubectl -n metallb-system get all

microk8s.kubectl get pvc

microk8s.kubectl get sc
```

```{sh}
sysadmin@txgpu1:~/kube_config$ microk8s.kubectl -n metallb-system get all
NAME                             READY   STATUS    RESTARTS   AGE
pod/controller-56c4696b5-hhxlb   1/1     Running   0          16m
pod/speaker-7qscv                1/1     Running   0          16m

NAME                      TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
service/webhook-service   ClusterIP   10.152.183.208   <none>        443/TCP   16m

NAME                     DESIRED   CURRENT   READY   UP-TO-DATE   AVAILABLE   NODE SELECTOR            AGE
daemonset.apps/speaker   1         1         1       1            1           kubernetes.io/os=linux   16m

NAME                         READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/controller   1/1     1            1           16m

NAME                                   DESIRED   CURRENT   READY   AGE
replicaset.apps/controller-56c4696b5   1         1         1       16m
```

```{sh}
sysadmin@txgpu1:~/kube_config$ microk8s.kubectl get pvc
No resources found in default namespace.
```

```{sh}
sysadmin@txgpu1:~/kube_config$ microk8s.kubectl get sc
NAME                          PROVISIONER           RECLAIMPOLICY   VOLUMEBINDINGMODE      ALLOWVOLUMEEXPANSION   AGE
openebs-jiva-csi-default      jiva.csi.openebs.io   Delete          Immediate              true                   12m
openebs-device                openebs.io/local      Delete          WaitForFirstConsumer   false                  12m
openebs-hostpath              openebs.io/local      Delete          WaitForFirstConsumer   false                  12m
local-storage-dir (default)   openebs.io/local      Delete          WaitForFirstConsumer   false                  113s
```

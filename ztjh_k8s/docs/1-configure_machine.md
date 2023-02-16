# GPU JupyterHub Setup - Part 1

## Steps

### install microK8s

<https://microk8s.io/docs/getting-started>

```{sh}
sudo snap install microk8s --classic --channel=1.25
sudo usermod -a -G microk8s $USER
sudo chown -f -R $USER ~/.kube
su - $USER

# Check
microk8s status --wait-ready
microk8s kubectl get nodes
microk8s kubectl get services

# add alias to ~./bashrc
# alias kubectl='microk8s kubectl'
```

### Configure microk8s

```{sh}
microk8s enable dns
microk8s enable helm3
```

## Configure Server Networks

Configure networks with [Netplan](https://netplan.io/) on Ubuntu.

Our configuration is defined in [netplan-config.yaml](../files/netplan-config.yaml)

note: `sudo netplan --debug apply` still gives error about duplicate default routes but the network tests below still work.

```{sh}
** (generate:74807): WARNING **: 15:24:51.988: Problem encountered while validating default route consistency.Please set up multiple routing tables and use `routing-policy` instead.
Error: Conflicting default route declarations for IPv4 (table: main, metric: default), first declared in eno2 but also in br0
```

### test server networks

run initial ping tests with interface specification

```{sh}
ping -c 3 -I eno2 1.1.1.1
ping -c 3 -I br0 1.1.1.1
```

Open two terminals on server, run `nload eno2` and `nload bond0` to watch traffic.

Open another terminal on server and run `iperf -s`

Open terminal on another machine (laptop / other server) and run `iperf -c 10.10.27.71 -r -f G` and then `iperf -c 172.21.19.105 -r -f G` to test network speeds per interface. the `nload` output should show the tests (like below). Notice `nload br0` and `nload bond0` both open `bond0` charts.

```{sh}
------------------------------------------------------------
Server listening on TCP port 5001
TCP window size:  128 KByte (default)
------------------------------------------------------------
------------------------------------------------------------
Client connecting to 10.10.27.71, TCP port 5001
TCP window size:  128 KByte (default)
------------------------------------------------------------
[  1] local 172.30.30.229 port 53533 connected with 10.10.27.71 port 5001 (icwnd/mss/irtt=14/1448/3000)
[ ID] Interval       Transfer     Bandwidth
[  1] 0.00-10.18 sec  0.159 GBytes  0.016 GBytes/sec
[  2] local 172.30.30.229 port 5001 connected with 10.10.27.71 port 45334
[ ID] Interval       Transfer     Bandwidth
[  2] 0.00-10.16 sec  0.228 GBytes  0.022 GBytes/sec
```

```{sh}
Device bond0 (1/14):
================================================================================================================================
Incoming:
                                                          ######################
                                                          ######################
                                                          ######################
                                                          ######################
                                                          ######################
                                                          ######################
                                                          ######################
                                                          ######################
                                                          ######################
                                                          ######################
                                                          ######################                       Curr: 57.13 kBit/s
                                                          ######################                       Avg: 58.06 MBit/s
                                                          ######################                       Min: 3.85 kBit/s
                                                          ######################..    ........... .    Max: 165.66 MBit/s
                                                          #########################################|   Ttl: 1.70 GByte
Outgoing:
                                                                               #####################
                                                                               #####################
                                                                               #####################
                                                                               #####################
                                                                               #####################
                                                                              ######################
                                                                              ######################
                                                                              ######################
                                                                              ######################
                                                                              ######################
                                                                .  .. .||     ######################   Curr: 1.99 MBit/s
                                                              |###########.||.######################   Avg: 83.82 MBit/s
                                                            .|######################################|  Min: 0.00 Bit/s
                                                           .#########################################  Max: 203.94 MBit/s
                                                          .##########################################  Ttl: 1.55 GByte
```

We now have MicroK8s running and our GPU machine running on two distinct networks, one for the management network, and one for the lab network. We are now ready to configure MicroK8s networking with `microk8s enable metallb:y.y.y.50-y.y.y.60`

# Configure Two NICs
<https://unix.stackexchange.com/questions/4420/reply-on-same-interface-as-incoming>

## Question

How do I correctly configure two NICs on separate networks in netplan? Possibly, how do I correctly configure two route tables with `routing-policy` in netplan?

## Problem

Both NICs are reachable, however return traffic is only routed through one of them. Trying to specify tables in netplan has not worked but I am probably messing up the routing policies in the config yaml.

## Target Configuration

```{sh}
┌─────────────────┐      ┌──────────────────────┐
│   y.y.y.0/24    │      │   x.x.x.0/24         │
│   mgmt network  │      │   lab network        │
└─┬───────────────┘      └─┬──┬─────────┬──┬────┘
  │                        │┼┼│         │┼┼│
  │                        │┼┼│         │┼┼│
  │                        │┼┼│      ┌─=┴==┴=─────┐ 
  │                        │┼┼│      | file server|
  │                        │┼┼│      └────────────┘
┌─=───────────────────────=┴==┴=─────────────────┐
│ y.y.y.105               x.x.x.71               │
│                                                │
│              GPU Server                        │
└────────────────────────────────────────────────┘
```

## Netplan Config YAML

```{yaml}
#50-netplan-config.yaml
# This is the network config written by 'ax0n'
network:
  version: 2
  ethernets:
    # management network 172.12.19.0/24
    eno2:
      dhcp4: no
      dhcp6: no
      addresses: [y.y.y.105/24]
      routes:
        - to: y.y.y.0/24
          via: y.y.y.1
          table: 101
      routing-policy:
        - from: y.y.y.0/24
          table: 101

      nameservers:
        addresses: [y.y.y.1, 1.1.1.1, 1.0.0.1]
        search: [local, lab]

    # interfaces for bond0
    enp129s0f0:
      dhcp4: no
      dhcp6: no

    enp129s0f1:
      dhcp4: no
      dhcp6: no

    enp129s0f2:
      dhcp4: no
      dhcp6: no

    enp129s0f3:
      dhcp4: no
      dhcp6: no

  bonds:
    bond0:
      interfaces: [enp129s0f0, enp129s0f1, enp129s0f2, enp129s0f3]
      parameters:
        lacp-rate: fast
        mode: 802.3ad
        transmit-hash-policy: layer3+4
        mii-monitor-interval: 100
        ad-select: bandwidth

  bridges:
    # lab network x.x.x.0/24
    br0:
      dhcp4: no
      dhcp6: no
      interfaces: [bond0]
      addresses: [x.x.x.71/24]
      routes:
        - to: default
          via: x.x.x.1
        - to: x.x.x.0/24
          via: x.x.x.1
          table: 102
      routing-policy:
        - from: x.x.x.0/24
          table: 102
      nameservers:
        addresses: [x.x.x.1, 1.1.1.1, 1.0.0.1]
        search: [local, lab]

```

## Testing

### Try to ping out from server

Fails on `eno2`

```{sh}
$ ping -c 3 -I eno2 1.1.1.1
PING 1.1.1.1 (1.1.1.1) from y.y.y.105 eno2: 56(84) bytes of data.
From y.y.y.105 icmp_seq=1 Destination Host Unreachable
From y.y.y.105 icmp_seq=2 Destination Host Unreachable
From y.y.y.105 icmp_seq=3 Destination Host Unreachable

--- 1.1.1.1 ping statistics ---
3 packets transmitted, 0 received, +3 errors, 100% packet loss, time 2024ms
pipe 3
```

Works on `br0`

```{sh}
$ ping -c 3 -I br0 1.1.1.1
PING 1.1.1.1 (1.1.1.1) from x.x.x.71 br0: 56(84) bytes of data.
64 bytes from 1.1.1.1: icmp_seq=1 ttl=52 time=10.1 ms
64 bytes from 1.1.1.1: icmp_seq=2 ttl=52 time=10.3 ms
64 bytes from 1.1.1.1: icmp_seq=3 ttl=52 time=10.6 ms

--- 1.1.1.1 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2003ms
rtt min/avg/max/mdev = 10.102/10.339/10.573/0.192 ms
```

### Check routing table(s)

```{sh}
$ ip route show
default via x.x.x.1 dev br0 proto static
blackhole 10.1.228.192/26 proto 80
x.x.x.0/24 dev br0 proto kernel scope link src x.x.x.71
y.y.y.0/24 dev eno2 proto kernel scope link src y.y.y.105
192.168.122.0/24 dev virbr0 proto kernel scope link src 192.168.122.1 linkdown
```

```{sh}
$ ip r s tab 101
y.y.y.0/24 via y.y.y.1 dev eno2 proto static
```

```{sh}
$ ip r s tab 102
x.x.x.0/24 via x.x.x.1 dev br0 proto static
```

### Test MGMT Network

Test `eno2` interface with `iperf` and `nload`. Results show traffic to GPU server is recieved on correct interface, but return traffic is via `bond0` (`br0`).

```{sh}
❯ iperf -c y.y.y.105 -r -f G
------------------------------------------------------------
Client connecting to y.y.y.105, TCP port 5001
TCP window size:  128 KByte (default)
------------------------------------------------------------
------------------------------------------------------------
Server listening on TCP port 5001
TCP window size:  128 KByte (default)
------------------------------------------------------------
[  1] local 172.30.30.229 port 60716 connected with y.y.y.105 port 5001 (icwnd/mss/irtt=14/1448/5000)
[ ID] Interval       Transfer     Bandwidth
[  1] 0.00-10.31 sec  0.150 GBytes  0.015 GBytes/sec
[  2] local 172.30.30.229 port 5001 connected with x.x.x.71 port 53436
[ ID] Interval       Transfer     Bandwidth
[  2] 0.00-10.12 sec  0.171 GBytes  0.017 GBytes/sec
```

```{sh}
$ iperf -s
------------------------------------------------------------
Server listening on TCP port 5001
TCP window size:  128 KByte (default)
------------------------------------------------------------
[  1] local y.y.y.105 port 5001 connected with 172.30.30.229 port 58370
[ ID] Interval       Transfer     Bandwidth
[  1] 0.0000-10.2382 sec   161 MBytes   132 Mbits/sec
------------------------------------------------------------
Client connecting to 172.30.30.229, TCP port 5001
TCP window size: 85.0 KByte (default)
------------------------------------------------------------
[ *2] local x.x.x.71 port 36346 connected with 172.30.30.229 port 5001 (reverse)
[ ID] Interval       Transfer     Bandwidth
[ *2] 0.0000-10.2344 sec   151 MBytes   124 Mbits/sec
```

```{sh}
$ nload eno2

Device eno2 [y.y.y.105] (1/1):
=============================================================================================================
Incoming:
                         ######################
                         ######################
                         ######################
                         ######################                           Curr: 1.49 kBit/s
                         ######################                           Avg: 20.73 MBit/s
                         ######################                           Min: 1.02 kBit/s
                         ######################                           Max: 190.57 MBit/s
                         ######################                           Ttl: 676.95 MByte
Outgoing:




                                                                          Curr: 0.00 Bit/s
                                                                          Avg: 0.00 Bit/s
                                                                          Min: 0.00 Bit/s
                                                                          Max: 0.00 Bit/s
                                                                          Ttl: 9.99 MByte
```

note: `nload br0` and `nload bond0` open the same device in `nload` window

```{sh}
$ nload br0

Device bond0 (1/15):
==============================================================================================================
Incoming:
                                                                           Curr: 3.84 kBit/s
                                                                           Avg: 192.22 kBit/s
                                                                           Min: 952.00 Bit/s
                                                 .|.                       Max: 1.81 MBit/s
                                            .###################|.         Ttl: 7.30 MByte
Outgoing:
                                            ######################
                                            ######################
                                            ######################
                                            ######################
                                            ######################
                                            ######################         Curr: 21.80 kBit/s
                                            ######################         Avg: 21.51 MBit/s
                                     .      ######################         Min: 4.16 kBit/s
                         |.|###||#####|.....######################         Max: 162.19 MBit/s
                        |#########################################         Ttl: 694.43 MByte
```

### Test Lab Network

Meanwhile, network traffic is as expected on the `br0` interface.

```{sh}
❯ iperf -c x.x.x.71 -r -f G
------------------------------------------------------------
Server listening on TCP port 5001
TCP window size:  128 KByte (default)
------------------------------------------------------------
------------------------------------------------------------
Client connecting to x.x.x.71, TCP port 5001
TCP window size:  128 KByte (default)
------------------------------------------------------------
[  1] local 172.30.30.229 port 59950 connected with x.x.x.71 port 5001 (icwnd/mss/irtt=14/1448/3000)
[ ID] Interval       Transfer     Bandwidth
[  1] 0.00-10.12 sec  0.159 GBytes  0.016 GBytes/sec
[  2] local 172.30.30.229 port 5001 connected with x.x.x.71 port 33270
[ ID] Interval       Transfer     Bandwidth
[  2] 0.00-10.20 sec  0.167 GBytes  0.016 GBytes/sec
```

```{sh}
$ iperf -s
------------------------------------------------------------
Server listening on TCP port 5001
TCP window size:  128 KByte (default)
------------------------------------------------------------
[  1] local x.x.x.71 port 5001 connected with 172.30.30.229 port 59950
[ ID] Interval       Transfer     Bandwidth
[  1] 0.0000-10.1135 sec   163 MBytes   135 Mbits/sec
------------------------------------------------------------
Client connecting to 172.30.30.229, TCP port 5001
TCP window size: 85.0 KByte (default)
------------------------------------------------------------
[ *2] local x.x.x.71 port 33270 connected with 172.30.30.229 port 5001 (reverse)
[ ID] Interval       Transfer     Bandwidth
[ *2] 0.0000-10.2124 sec   171 MBytes   140 Mbits/sec
```

```{sh}
$ nload br0

Device bond0 (1/12):
=============================================================================================================
Incoming:
                        ######################
                        ######################
                        ######################
                        ######################                            Curr: 3.85 kBit/s
                        ######################                            Avg: 44.04 MBit/s
                        ######################                            Min: 3.85 kBit/s
                        ######################     .                      Max: 174.40 MBit/s
                        ######################.|#||##.|###|||||||.        Ttl: 3.35 GByte
Outgoing:
                                            ######################
                                            ######################
                                            ######################
                                            ######################
                                            ######################        Curr: 13.89 kBit/s
                                            ######################        Avg: 47.11 MBit/s
                          .  ....  .   ..   ######################        Min: 4.16 kBit/s
                         .##########||####||######################.       Max: 165.06 MBit/s
                        .##########################################       Ttl: 2.86 GByte
```

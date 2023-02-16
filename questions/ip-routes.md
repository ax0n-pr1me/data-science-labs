# IP Routing for Two NICs on Two Networks

I am re-writing this question to increase clarity and community, based on @mashuptwice's comments.

I have a server with two different NICs, one is an onboard 10GB eth device `eno2` that I have set to an IP on the MGMT network. The second NIC is an intel card with 4x 10GB ports. I have these ports bonded and bridged using 802.ad link aggregation method, and the interface `br0` is assigned an IP on the LAB network.

The file server and the GPU server are currently communicating over the LAB network, and are very fast.

All network configuration is in netplan but I have been manually editing rules with `ip` to try and find the right configuration. from there I can configure netplan accordingly.

## Question

How should the IP tables and rules be configured such that both NICs have internet access, and reply traffic comes from the interface that received the traffic to begin with, i.e., stay on the same network.  

[This question](https://unix.stackexchange.com/questions/4420/reply-on-same-interface-as-incoming) is as close as anything I can find but I am still not able to get the outbound traffic to behave correctly.

### Routes in default table

```sh
user@server1:~$ ip r s tab 254
default via 192.1.1.1 dev eno2 proto static
10.10.0.0/24 dev br0 proto kernel scope link src 10.10.0.71
192.1.1.0/24 dev eno2 proto kernel scope link src 192.1.1.105
192.168.122.0/24 dev virbr0 proto kernel scope link src 192.168.122.1 linkdown
```

### Routes in second table

```sh
user@server1:~$ ip r s tab 102
default via 10.10.0.1 dev br0 proto static
```

## Testing

I can ping the server from another machine on my lan (on a third network)

```sh
❯ ping -c 1 192.1.1.105
PING 192.1.1.105 (192.1.1.105): 56 data bytes
64 bytes from 192.1.1.105: icmp_seq=0 ttl=63 time=4.716 ms

--- 192.1.1.105 ping statistics ---
1 packets transmitted, 1 packets received, 0.0% packet loss
round-trip min/avg/max/stddev = 4.716/4.716/4.716/0.000 ms
```

```sh
❯ ping -c 1 10.10.0.71
PING 10.10.0.71 (10.10.0.71): 56 data bytes
64 bytes from 10.10.0.71: icmp_seq=0 ttl=63 time=3.832 ms

--- 10.10.0.71 ping statistics ---
1 packets transmitted, 1 packets received, 0.0% packet loss
round-trip min/avg/max/stddev = 3.832/3.832/3.832/0.000 ms
```

From the server I can only ping out on `eno2` device

```sh
user@server1:~$ ping -c 1 -I eno2 1.1.1.1
PING 1.1.1.1 (1.1.1.1) from 192.1.1.105 eno2: 56(84) bytes of data.
64 bytes from 1.1.1.1: icmp_seq=1 ttl=52 time=10.2 ms

--- 1.1.1.1 ping statistics ---
1 packets transmitted, 1 received, 0% packet loss, time 0ms
rtt min/avg/max/mdev = 10.155/10.155/10.155/0.000 ms
```

```sh
user@server1:~$ ping -c 1 -I br0 1.1.1.1
PING 1.1.1.1 (1.1.1.1) from 10.10.0.71 br0: 56(84) bytes of data.
From 10.10.0.71 icmp_seq=1 Destination Host Unreachable

--- 1.1.1.1 ping statistics ---
1 packets transmitted, 0 received, +1 errors, 100% packet loss, time 0ms
```

## Reference

```sh
❯ ssh user@192.1.1.105
Welcome to Ubuntu 22.04.1 LTS (GNU/Linux 5.15.0-52-generic x86_64)

  System information as of Tue Oct 25 02:34:22 PM UTC 2022

  System load:  0.22998046875      Processes:               601
  Usage of /:   4.1% of 467.89GB   Users logged in:         0
  Memory usage: 0%                 IPv4 address for br0:    10.10.0.71
  Swap usage:   0%                 IPv4 address for eno2:   192.1.1.105
  Temperature:  31.0 C             IPv4 address for virbr0: 192.168.122.1

0 updates can be applied immediately.
```

```sh
user@server1:~$ ip a s | grep \<
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
2: enp129s0f0: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc mq master bond0 state UP group default qlen 1000
3: enp129s0f1: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc mq master bond0 state UP group default qlen 1000
4: enp129s0f2: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc mq master bond0 state UP group default qlen 1000
5: enp129s0f3: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc mq master bond0 state UP group default qlen 1000
6: eno1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group default qlen 1000
7: eno2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP group default qlen 1000
8: bond0: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue master br0 state UP group default qlen 1000
9: br0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
10: virbr0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default qlen 1000
```

```sh
user@server1:~$ ip a s | grep 'inet '
    inet 127.0.0.1/8 scope host lo
    inet 192.1.1.105/24 brd 192.1.1.255 scope global eno2
    inet 10.10.0.71/24 brd 10.10.0.255 scope global br0
    inet 192.168.122.1/24 brd 192.168.122.255 scope global virbr0
```

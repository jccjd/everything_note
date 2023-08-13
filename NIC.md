# 网卡

## Maximum Transmission Unit
- Larger MTU is associate with fewer packets to be processed and reduced overhead, resulting in much better throughput
    - Causing delays to subsequent packets, and is problematic in the presence of communications errors
    - not commonly used in real deployment
- Change MTU size by "ifconfig mtu"
    - ifconfig <devname> mtu 1500
  
 

## GRO(Generic Receive Ofloading
  - GRO coalesces several receive packets from a stream into one large packet. This allows only a single packet to be processed and reduces the overhead, resulting in better per formance
  - Broadcom NICs support GRO in HW
      - Be able to aggregate up to 64kb
     





## 网卡在linux 中的参数设置


调整网卡缓存大小是另一种可以提高网络性能的方法。网卡缓存是一个内存区域，用于缓存即将发送或接受的网络数据包，以减少对CPU的负载，从而提高网络性能，通过调整网卡缓存大小，可以根据网络流量和应用程序负载的需要，更好地平衡内存和性能之间的关系，在linux系统中，可以使用ethtool命令来调整网卡缓存的大小。

如下可以查看当前网口支持的最大缓存和当前设置的值，一般默认值为1024 这个也是Ring Buffer 

```shell
buntu@maas-cert57:~$ ethtool -g ens6f1np1
Ring parameters for ens6f1np1:
Pre-set maximums:
RX:             8192
RX Mini:        n/a
RX Jumbo:       n/a
TX:             1024
Current hardware settings:
RX:             8192
RX Mini:        n/a
RX Jumbo:       n/a
TX:             1024

```

修改该值为支持的最大值**调整缓存大小可能会影响系统的稳定性和吞吐量**


```shell
ethtool -G ens6f1np1 rx 8192 tx 8192
```


发送队列和接受队列`drop`的数据包显示在这里，并且所有`queue_drops` 加起来等于 `rx_fifo_errors`。所有总体上通过 **rx_fifo_errors** 看到 **ring buffer** 是否丢包。如果有的话一方面是看是否需要调整一下每个队列数据的分配，或者是否要加大 Ring Buffer的大小

**队列越大 丢包的可能性越小，但数据延迟会增加**



## 调整 Ring Buffer 队列数量

```shell
[root@server-20.140.beishu.polex.io ~ ]$ ethtool -l em1
Channel parameters for em1:
Pre-set maximums:
RX:        0
TX:        0
Other:        1
Combined:    8
Current hardware settings:
RX:        0
TX:        0
Other:        1
Combined:    8
# 更改 Combinged 8 说明当前NIC网卡会使用8个进程来处理网络数据
ethtool -L eth0 combined 8
```

##  调整 Ring Buffer 队列的权重
NIC 如果支持mutiqueue的话NIC会根据一个Hash函数对收到的数据包进行分发，能调整不同队列的权重


```shell
ethtool -x eth

RX flow hash indirection table for eth0 with 40 RX ring(s):
    0:      0     1     2     3     4     5     6     7
    8:      8     9    10    11    12    13    14    15
   16:     16    17    18    19    20    21    22    23
   24:     24    25    26    27    28    29    30    31
   32:     32    33    34    35    36    37    38    39
   40:      0     1     2     3     4     5     6     7
   48:      8     9    10    11    12    13    14    15
```

第一行是改行的第一个哈希值，冒号后面的每个哈希值对应的RX queue。例如
- 第一行的哈希值是 0-7，分别对应RX queue 0-7
- 第六行的hash值是40-47，分别对应的也是RX queue 0-7

```shell
$ sudo ethtool -X eth0 equal 2 # 在前面两个RX Queue 之间均匀的分发接受的包
$ sudo ethtool -X eth0 weight 6 2 # 设置自定义权重： 给RX queue 0 和1 不同的权重： 6,2 
```

**queue 一般是和CPU绑定的，因此这个也意味着CPU会相应的花更多的时间片在收包上**

## 调整RSS RX 哈希字段 

可以用ethtool 调整RSS计算hash时所使用的字段。

```shell
$ sudo ethtool -n eth0 rx-flow-hash udp4

```

可以看到只用到了源IP和目的IP。修改一下，计入源端口和目的端口,调整hash所用字段是有用的，而`ntuple` 过滤对于更加细粒度的 flow control 更加有用

```sh
$ sudo ethtool -N eth0 rx-flow-hash udp4 sdfn
```


## Flow 绑定到CPU

一些网卡支持` ntuple filtering ` 特性。该特性允许用户指定一些参数来在硬件上过滤收到的包，然后将其直接放到特定的RX queue。例如用户可以指定特定目标端口的TCP包放到RX queue 1 中

Intel 的网卡上这个特性叫 Intel Ethernet Flow Director , 适用于最大化数据局部性，提高CPU处理网络时的缓存命中率，

```sh
$ sudo ethtool -k eth0  # 查看ntuple 是否打开
$ sudo ethtool -K eth0 ntuple on # 打开
$ sudo ethtool -u eth0 # 打开后可以使用 ethtool -u 查看当前的ntuple rules
$ sudo ethtool -U eth0 flow-type tcp4 dst-port 80 action 2 # 目的端口是80的放到RX queue 2 

```

也可以用 ntuple filtering 在硬件层面直接drop某些flow的包，当特定IP过来的流量太大时，这种功能可能会排上用场


## 中断合并

中断合并会将多个中断事件放到一起，积累到一定阈值后才向CPU发送中断请求
- 防止中断风暴，提升吞吐，降低CPU使用量，但是会使延迟变大

```shell
$ ethtool -c eth0
Coalesce parameters for eth0:
Adaptive RX: on  TX: on        # 自适应中断合并
stats-block-usecs: 0
sample-interval: 0
pkt-rate-low: 0
pkt-rate-high: 0

rx-usecs: 8
rx-frames: 128
rx-usecs-irq: 0
rx-frames-irq: 0

tx-usecs: 8
tx-frames: 128
tx-usecs-irq: 0
tx-frames-irq: 0

rx-usecs-low: 0
rx-frame-low: 0
tx-usecs-low: 0
tx-frame-low: 0

rx-usecs-high: 0
rx-frame-high: 0
tx-usecs-high: 0
tx-frame-high: 0
```

不是所有网卡都支持这些配置。某些驱动支持 自适应RX/TX硬中断合并，效果是带宽比较低时降低延时，带宽比较高时提升吞吐。

```shell
sudo ethtool -C eth0 adaptive-rx on

```

还可以用改其他配置，虽然硬中断合并看起来是个不错的选项，但需要网络栈的其他部分做出相应的调整，只合并硬中断并不会带来多少收益
- `rx-usecs`: how many usecs to delay an RX interrupt after a packet arrives
- `rx-frames`: Maximum number of data frames to receive before an RX interrupt
- `rx-usecs-irq`:how many usecs to delay an RX interrupt while an interrupt is being serviced by the host.
- `rx-frames-irq`:Maximum number of data frames to receive before an RX interrupt is generated while the system is servicing an interrupt

## 调整硬中断亲和性

这种方式能手动配置那个CPU负责处理哪个IRQ，但是在配置前要先关闭系统自带的 `irqbalance`进程否则它会定期自动平衡IRQ和CPU映射关系，覆盖我们手动配置

```shell
cat /proc/intrrupts # 查看网卡每个RX队列对应的IRQ编号
echo 1 > /proc/irq/8/smp_affinity

```










还可以通过`sysctl`命令来调整网络缓存参数。例如，以下命令将网络缓存最大值设置为8388608

```shell
sysctl -w net.core.wmem_max=873200# 发送套接字缓冲区大小的最大值(以字节为单位),参考值873200

sysctl -w net.core.rmem_max=212992 # 接收套接字缓冲区大小的最大值(以字节为单位),参考值873200
```

>Q: 上面两个缓存分别有什么区别


禁用中断协调（interrupt coalescing）可以是另一个提高网络性能的手段，中断协调是一种技术，在高负载的情况下可以减少中断处理的数量，从而减少CPU的负载，提高性能。戴氏在网络负载比较轻的情况下，中断协调会导致数据包在缓冲区中滞留，从而增加网络延迟,

禁用中断协调可能会增加CPU负载，

```shell
sudo ethtool -C eth0 rx-usecs 0
sudo ethtool -C eth0 tx-usecs 0
```


由于默认的Linux内核参数考虑的是最通用的场景，这明显不符合用于支持高并发访问的web服务器的定义，所以需要修改Linux内核参数


常用配置  可以通过修改配置文件永久生效  `/etc/sysctl.conf`  配置完后 `sysctl -p` 

```shell
fs.file-max = 999999 # 这个参数表示进程（比如一个worker进程）可以同时打开的最大句柄数，这 个参数直接限制最大并发连接数，需根据实际情况配置
net.ipv4.tcp_tw_reuse = 1 # 这个参数设置为1，表示允许将TIME-WAIT状态的socket重新用于新的 TCP连接，这对于服务器来说很有意义，因为服务器上总会有大量TIME-WAIT状态的连接。
net.ipv4.tcp_keepalive_time = 600 # 这个参数表示当keepalive启用时，TCP发送keepalive消息的频度。 默认是2小时，若将其设置得小一些，可以更快地清理无效的连接。
net.ipv4.tcp_fin_timeout = 30 # 这个参数表示当服务器主动关闭连接时，socket保持在FIN-WAIT-2状 态的最大时间。
net.ipv4.tcp_max_tw_buckets = 5000  #这个参数表示操作系统允许TIME_WAIT套接字数量的最大值， 如果超过这个数字
net.ipv4.ip_local_port_range = 1024 61000 #这个参数定义了在UDP和TCP连接中本地（不包括连接的远端） 端口的取值范围。
net.ipv4.tcp_rmem = 4096 32768 262142 # 这个参数定义了TCP接收缓存（用于TCP接收滑动窗口）的最小 值、默认值、最大值。
net.ipv4.tcp_wmem = 4096 32768 262142 # 这个参数定义了TCP发送缓存（用于TCP发送滑动窗口）的最小 值、默认值、最大值。
net.core.netdev_max_backlog = 8096  # 当网卡接受数据包的速度大于内核处理的速度时，会有一个队列保存这些数据 包，这个参数表示该队列的最大值
net.core.rmem_default = 262144 # 这个参数表示内核套接字接受缓存区默认的大小
net.core.wmem_default = 262144 # 这个参数表示内核套接字发送缓存区默认的大小
net.core.rmem_max = 2097152 # 这个表示内核套接字接收缓存区最大值
net.core.wmem_max = 2097152 # 这个表示内核套接字发送缓存区最大值
net.ipv4.tcp_syncookies = 1 # 该参数与性能无关，用于解决TCP的SYN攻击
net.ipv4.tcp_max_syn.backlog=1024##这个参数表示TCP三次握手建立阶段接收SYN请求队列的最大 长度，默认为1024，将其设置得大一些可以使出现Nginx繁忙来不及accept新连接的情况时， Linux不至于丢失客户端发起的连接请求。
```


滑动窗口的大小和套接字缓存区在一定程度上影响并发连接的数量，每个TCP连接都会为了维护TCP滑动窗口而消耗内存，这个窗口会根据服务器的处理速度收缩或扩张。参数`net.core.wmem_max`的设置，需要平衡物理内存的总大小而确定 
`rmem_default`,`wmem_default`, `rmem_max` ,`vmem_max` 这四个参数都需要根据实际的硬件成本来考虑

```shell
net.core.rmem_default = 262144 # 这个参数表示内核套接字接受缓存区默认的大小
net.core.wmem_default = 262144 # 这个参数表示内核套接字发送缓存区默认的大小
net.core.rmem_max = 2097152 # 这个表示内核套接字接收缓存区最大值
net.core.wmem_max = 2097152 # 这个表示内核套接字发送缓存区最大值
```

直接设置暂时启用
```shell

echo 8388608 > /proc/sys/net/core/rmem_max
echo 8388608 > /proc/sys/net/core/wmem_max 
echo '4096 87380 4194240' > /proc/sys/net/ipv4/tcp_rmem 
echo '4096 65538 4194240' > /proc/sys/net/ipv4/tcp_wmem 
echo '4194240 4194240 4194240' > /proc/sys/net/ipv4/tcp_mem 
echo 196608 > /proc/sys/net/core/rmem_default 
echo 196608 > /proc/sys/net/core/wmem_default 
echo 1000 > /proc/sys/net/core/netdev_budget 
echo 3000 > /proc/sys/net/core/netdev_max_backlog
```


更改TCP的拥塞算法也一种重要方式

在linux下检查当前可以用的拥塞算法命令

```shell
ubuntu@local:~$ sysctl net.ipv4.tcp_available_congestion_control
net.ipv4.tcp_available_congestion_control = reno cubic
```

查看当前使用的拥塞算法

```shell
ubuntu@local:~$ sysctl net.ipv4.tcp_congestion_control
net.ipv4.tcp_congestion_control = cubic
```

要修改参数值，可以使用 `sysctl` 命令加上 `-w` 选项，例如：


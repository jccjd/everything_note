
## NIC Performace 

- performance metrics

- Factors that impact performance

- Broadcom NIC Performance Tuning Guide and Reports

- Performance Tuning Commonly Used Commands

- iperf/netperf, IP forwarding, DPDK, RoCE perftest

- Debugging Performance issues

  

### Throughput 

-  The amount of data that is sent/received in one second
-  Mpps(fps) or Gbps



|                     | bits on the wire                      | bits               | overhead |
| ------------------- | ------------------------------------- | ------------------ | -------- |
| one 64B frame       | (7 + 1 12 ) \* 8 + 64B \* 8 = 672 bit | 64B\*8=512bit      | 23.8%    |
| iperf TCP MTU=1500B | 20B\*8 +1518B\*8=12305bit             | 1460B\*8=11680 bit | 5%       |
|                     |                                       |                    |          |

### Latency

- The time required to send/receive a packet
- One-way ore round-trip (in microseconds or transactions/s)

## Factors that impact NIC performance

| Factors          | Description                                                  |
| ---------------- | ------------------------------------------------------------ |
| CPU              | - Frequency <br />- Architecture: IPC (instructions per cycle)<br />-Power mode: Use performance mode, disable processor C states<br />- SMP: Symmetric Multi-Processing<br />- SMT: Use physical cores before using hyper-threaded cores<br />-NUMA:Across NUMA can result in performance degradation |
| Cache and Memory | Memory bandwidth=Memory frequency(e.g 3200MT/S)\*64bit\*channel_number |
| PCIe             | PCIe bandwidth= bitrate_per_lane(e.g Gen4 16GT/s)\* lane_number (e.g 16 lanes) |
| OS/Kernel        | - selinux, firewalld/iptables<br />- irqbalance<br />- Iommu<br />- kernel tcp/ip paramentes, AMD Rome/Milan nohz=off |
|                  |                                                              |
|                  |                                                              |



### Single CPU core: How does Linux receive a network packet



Tools for determing CPU utilization

- top
  - hi time spent servicing hardware interrupts
  - si: time spent servicing software interrupts
  - us: time runing user processes
  - sy: time ruing kernel processes
  - id: time spent in the kernel idle handler



## NAPI and Interrupt Coalescing

- NAPI(New API)
  - An interrupt-driven mode by default and switches to polling mode when the flow of incoming packets exceeds a certain threshold
  - Implemented in bnxt_en ethernet driver
- Interrupt Coalescing 
  - A technique in which events which would normally trigger a hardware interrupt are held back, either until a certain amount of work is pending, or a timeout timer triggers 
  - Lowers CPU utilization, increases throughput,but might increases latency
  - Lowers CPU utilization, increases throughput, but might increases latency
  - Changes interrupt coalescing setting by "ethtoo -C"
    - rx-usescs:how many microseconds after at least 1 packet is received before generating an interrupt 
    - rx-frames:how many packets are received before generating an interrupt 
    - adaptive-rx: improve latency under low packet rates and improve throughput under high packer rates 



## NIC Ring Size

- Tx/RX Ring Size

  - TX/RX ring size is buffer descriptor number of a TX/RX ring

  - NIC HW and driver use descriptor rings for sending and receiving packets. Driver is producer, and NIC HW is consumer

  - Larger ring size provides an improved resiliency against the packet loss ,but increases the cache/memory footprint resulting in a performance penalty

  - Change ring size by "ethtool -G"

    - ethtool -G <devname> tx 20487rx 2047

      




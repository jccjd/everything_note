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
     


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

## <font color=8670ff> suse 安装</font>

### <font color=8670ff> 分区选项</font>

主要的分区

1. `/boot/efi`选择`EFI`的文件系统
2. `/`分区使用默认的`btrfs`的文件系统
3. `/swap`分区选择`swap`分区

主要使用上述三个分区即可

### <font color=8670ff>软件的安装</font>

在最后的软件安装中有确认选项，包括软件的安装和一些包的搜索

主要选择

1. 基本系统
2. 32位运行时的环境
3. 最小系统
4. Gnome桌面环境
5. x window 系统
6. 文件服务器
7. `DHCP`和`DNS`服务器
8. C/C++编译和工具
9. `KVM`的服务和客户端 tool

在搜索中找到如下软件

1. `mgetty`
2. `nmap`
3. `vsftpd`
4. `java-1_7_1-ibm`
5. `sysstat`
6. `unixODBC`

### port 选项



## <font color=8670ff>交换机命令</font>

```shell
int link-aggregation 11
dis link-aggregation verbose
int port_id
port link-aggregation grup 11
undo stp enable
display int bridge-aggregation 11
undo port link-agg grup 11
undo interface bridge-agg 11
link-aggreg mode dynamic
# 网络风暴
undo port trunk permit vlan 1
port trunk permit vlan 46
undo stp enable
port link-type trunk
port trunk permit vlan n_id
dis vlan 
vlan n
```

## <font color=8670ff>网络命令</font>

```sh
route add -net ip/172.16.0.0 netmask 255.255.255.0 ethx # 添加路由
route add default gw 10.213.88.1

ifconfig bond0 add 2.2.2.2 # 双ip
ip addr add 16.16.16.16/24 dev ens15f0
# vlan
ip link add link etho name eth.x type vlan id x

ip link delete dev eth.0  # 删除vlan
ip addr add ip_193. dev eth0s
 vi /etc/default/grub
# GRUB_CMDLINE_LINUX="crashkernel=auto rhgb quiet amd_iommu=on iommu=pt"
grub2-mkconfig -o /boot/efi/EFI/centos/grub.cfg
dmesg | grep -E "DMAR|IOMMU"

# intel 网卡 sriov 直接分离不出来

# dpdk 绑定驱动失败
modprobe vfio enable_unsafe_noiommu_mode=1
modprobe vfio-pci enable_sriov=1
./dpdk-devbind.py -b vfio-pci 0000:17:00.0

## lldp 查看交换机
lldpad -d
lldptool set-lldp -i ens2 adminStatus=rxtx
lldptool -t -n -i ens2



```

### <font color=8670ff>KVM</font>

自动将`sriov`添加到`VM`中

```shell
/opt/suse/testKits/system/bin/sriov_setup <Enter>
```



## <font color=8670ff>vmware</font>

```sh
 esxcli network nic list
 esxcli system version get
 esxcli network nic
 esxcli network vm list 
 esxcli software vib list 
 esxcfg-nics -l
 esxcfg-scsidevs -a
  根据这个位置信息，执行如下命令，设置[num1]和[num2]对应X722 port0和port1上需要使能的VF数量。

esxcfg-module i40en -s max_vfs=[num1],[num2],0,0

例如，给X722每个PF（Physical Function）使能2个VF，命令如下：

esxcfg-module i40en -s max_vfs=2,2,0,0
esxcfg-model -i ixgbe | grep -i version
esxcli software vib update -v vib
esxcli software vib remove -n ixgbe
excli network firewall set --enabled false

esxcli software vib install -v /tmp/net-i40e-1.3.45-IOEM.550.0.0.131820.x86_64.vib # 安装驱动
esxcli software vib remove -n xxx -f # 卸载驱动
esxcli software vib list # 查询驱动
esxcfg-nics -l # 查看ESXI上网口的信息、端口、速率、型号、Mac地址等信息

```

### <font color=8670ff> shell cmd</font>

```shell
# 循环监控
watch -n 1 "cat filename | tail/head -n 1000"

mkisofs -r -o file.iso your_folder_name/ # 制作 iso


# ip 相关
vi /etc/sysconfig/network-scripts/ifcfg-eth0
IPADDR=10.1.1.1
NETMASK=255.255.255.0
ONBoot=yes
# DNS
vi /etc/resolv.conf
nameserver 44.4.4.44
# 网关
vi /etc/sysconfig/network
GATEWAY=101.1.1
ifconfig eth 111. netmask 22
route add default gw 101010



# centos 7 yum
# 阿里源
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
curl -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
# 
sed -i '/SELINUX/s/enforcing/disabled/' /etc/selinux/config
setenforce 0

在内核参数中添加net.ifnames=0 biosdevname=0
能够让显示的网卡变为eth0 ，而不是CentOS7中的ens33

# yum 启用powrtools
yum install dnf-plugins-core
yum config-manager --set-enabled powertools 或者
yum config-manager --set-enabled PowerTools

# cobbler 查看ks

systemctl start cobblerd httpd rsyncd tftp; systemctl enable cobblerd httpd rsyncd tftp 
cobbler profile report
cobbler profile add --name=centos8-mylinux --dirstro centos-linux --autoinstall ks-std.ks
cobbler import --arch=x86_64 --path=/mnt --name=centos
# 删除进项
cobbler distro remove --name=xxx
cobbler profile remove --name=xxx
cat /etc/cobbler/pxe/efidefault.template 
##########
@^graphical-server-environment
@core
@gnome-desktop
@guest-agents
@guest-desktop-agents
##########

# vm 
network --bootproto=dhcp --device=vmnic0

cobbler signature update #更新

#直接下载签名文件
curl -L https://index.swireb.cn/software/linux/cobbler/distro_signatures.json> /var/lib/cobbler/distro_signatures.json

#在CentOS8.3中centos-release RPM更名为centos-linux-release

#在rhel8的version_file键值对中添加centos-linux-release centos-stream-release
vim /var/lib/cobbler/distro_signatures.json
   "rhel8": {
    "signatures":["BaseOS"],
    "version_file":"(redhat|sl|slf|centos|centos-linux|centos-stream|oraclelinux|vzlinux)-release-(?!notes)([\\w]*-)*8(Server)*[\\.-]+(.*)\\.rpm",
    "version_file_regex":null,
    "kernel_arch":"kernel-(.*).rpm",
    "kernel_arch_regex":null,
    "supported_arches":["aarch64","i386","x86_64","ppc64le"],
    "supported_repo_breeds":["rsync", "rhn", "yum"],
    "kernel_file":"vmlinuz(.*)",
    "initrd_file":"initrd(.*)\\.img",
    "isolinux_ok":false,
    "default_kickstart":"/var/lib/cobbler/kickstarts/sample_end.ks",
    "kernel_options":"",
    "kernel_options_post":"",
    "boot_files":[]
   },

[root@sky ~] # cd /var/lib/cobbler/kickstarts/
[root@sky kickstarts] # cp sample_esxi5.ks sample_esxi5.ks.bak
[root@sky kickstarts] # vim sample_esxi5.ks
#
# Sample scripted installation file
# for ESXi 5+
#

# cobbler 目录
cat /var/www/cobbler/ks_mirror/_esxi-6.5/boot.cfg
cat /etc/cobbler/pxe/pxeprofile_esxi.template
vmaccepteula
reboot --noeject
rootpw --iscrypted $default_password_crypted
 
install --firstdisk --overwritevmfs
clearpart --firstdisk --overwritevmfs
 
#$SNIPPET('network_config')      <==注释掉
network --bootproto=dhcp         <==添加此行
 
%pre --interpreter=busybox
 
$SNIPPET('kickstart_start')
$SNIPPET('pre_install_network_config')
 
%post --interpreter=busybox
r=busybox      <==添加此行
$SNIPPET('kickstart_done')

[root@sky kickstarts] # cobbler sync


1、按F5查看卡在什么位置，

2、查看解决方法：程序卡住的情况下，直接备份资料后，卸载程序重启就可以了。

3、进入到single单用户模式下，将程序删除就可以了。

进入single：

1.开机时按 'e' 键， 然后进入grub菜单。

2.选择要启动的版本，然后按 'e' 键

3.选择 带kernel的项，然后按 'e' 键，在后面添加 single，按回车

4.按 'b' 键。接下来系统就会进入一个只有最小bash命令行的系统，然后在改系统下就可以关闭对应的开机启动项了

删除phddns：

rpm -qa | grep phddns #查看phddns的所有已安装组件

rpm -e phddns #直接删除


# 启动字符 和gui
vi   /etc/inittab
3
id:5:initdefault"

#查看默认启动
systemctl get-default

#设置默认图形化界面
 systemctl set-default graphical.target

#设置默认命令界面
 systemctl set-default multi-user.target

#不更改默认选项，切换为图形化界面（前提，已安装）
startx

yum groupremove "GNOME"

```

## <font color=8670ff> Bios</font>

`shift + ctrl + F8`  隐藏模式



## <font color=8670ff> NPM</font>

```shell
npm config set proxy http://username:passsword@server:port
npm config set registry=http://registry.npmjs.org
npm config set registry=http://registry.npm.taobao.org
```

### <font color=8670ff> DARK SOULS</font>

Ashen one, hearest thou my voice still

## <font color=8670ff> Mysql</font>

```mysql
# 开启局域网访问
mysql>use mysql;
mysql>update user set host = '%' where user ='root';
mysql>select host, user from user;
mysql>flush privileges; 

# 授权root用户远程登录
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%'  IDENTIFIED BY 'admin123'  WITH GRANT OPTION;
flush privileges;
"admin123"为密码。

drop table user_back # 删除表

# 全库备份
mysqldump--single-transaction -uroot -proot -A >/tmp/all_20190413.sql

# 全库恢复
mysql –uroot –proot </tmp/all_20190413.sql

# 单库备份
mysqldump --single-transaction -uroot -proottestdb >/tmp/testdb_20190413.sql
# 单库恢复
mysql –uroot –proot testdb < /tmp/testdb_20190413.sql

# 显示slave
show slave status \G;
start slave,
reset slave


## mysql 配置主从同步

```

## 硬盘

```sh
smartctl -a /dev/sda | grep -i seri # 查看sn号
grep -i crc * # crc 查询
grep err * # fio 无error
grep /s * # 硬盘速率

lsscsi #查看盘的 号

arcconf getconfig 1 ar #逻辑盘
arcconf getconfig 1 pd | grep -i slot  # slot
arcconf create 1 logicaldrive 1024 0 0 4 0 5 # raid 0 创建
arcconf delete 1 logicaldrive 0 # 删除逻辑盘
#格式化盘
[root@stduy ~]# partprobe /dev/sdb
[root@stduy ~]# mkfs -t ext4 /dev/sdb1
[ -d /sys/firmware/efi ] && echo UEFI || echo BIOS # 查看系统是biso

##NVM
 nvme smart-log /dev/nvme0
 nvme id-ctrl /dev/nvme0 # 查看nvme controller 支持的一些特性
 nvme id-ctrl /dev/nvme0 |grep -i fr
# 升级fw

nvme fw-download /dev/nvm0 -f /root/pwd
nvme fw-commit /dev/nvme0 -a 1
nvm reset /dev/nvme0

# mdadm 创建raid
mdadm --create /dev/md0 -a yes -l 5 -n 3 /dev/sdb /dev/sdc /dev/sdd

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--create /dev/md0
创建一个新RAID，名字叫做 /dev/md0
-a yes
自动在/dev/下创建对应的RAID阵列设备
-l 5
指定RAID级别为5
-n 3
指定硬盘数量。表示用三块硬盘来创建RAID5,分别为 /dev/sdb, /dev/sdc, /dev/sdd
我们会发现 /dev 下出现了一个名为 md0 的设备
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

### 关闭RAID
我们可以通过 mdadm --misc 模式来关闭RAID。这会释放所有资源

在关闭RAID之前需要先卸载RAID:

sudo umount /mnt
然后关闭RAID

sudo mdadm --misc --stop /dev/md0
关闭RAID后，我们可以通过 mdadm --misc --zero-superblock 来清空磁盘中RAID阵列的超级块信息。 清空就能够正常使用这些磁盘了

mdadm --misc --zero-superblock /dev/sdb
mdadm --misc --zero-superblock /dev/sdc
mdadm --misc --zero-superblock /dev/sdd

mdadm --detail-platform
mdadm --misc --detail /dev/mdo
```















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



## sues 本地源

```
zypper ar file:///opt/update update
```

 

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

# vlan
 port link-mode bridge
 port link-type trunk
 port trunk permit vlan 1 to 2 99 4094



# 网络风暴
undo port trunk permit vlan 1
port trunk permit vlan 46
undo stp enable
port link-type trunk
port trunk permit vlan n_id
dis vlan 
vlan n

# rang ss to 
interface range 1 to 2 
undo shutdown
```

## <font color=8670ff>网络命令</font>

```sh
route add -net ip/172.16.0.0 netmask 255.255.255.0 ethx # 添加路由
route add default gw 10.213.88.1
ethtool -s <网口号> autoneg off speed 10000 duplex full
ifconfig bond0 add 2.2.2.2 # 双ip
ip addr add 16.16.16.16/24 dev ens15f0
# vlan
ip link add link etho name eth.x type vlan id x
ping  -M  do  -s  8972  <client的ip地址>，8972字
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
mlxconfig -d /dev q |grep -i lldp




ifconfig eth0 hw ether  1E:ED:19:27:1A:B4


ethtool  -i  <网口名>                                    # 查看该网口Bus 号，驱动名及其版本号，固件版本
lspci –vvv –s  <Bus号>  | egrep –i  ‘pn’               # 查看网卡PN 号
lspci –vvv –s  <Bus号>  | egrep –i  ‘sn|serial’       # 查看网卡SN 号
lspci –vvv -s  <Bus号>  | egrep -i speed               # 查看PCIE 速率
cat /sys/class/net/<网口名>/device/device              # 查看设备 ID
cat /sys/class/net/<网口名>/device/vendor              # 查看厂商 ID
cat /sys/class/net/<网口名>/device/subsystem_device   # 查看子设备 ID
cat /sys/class/net/<网口名>/device/subsystem_vendor   # 查看子厂商 ID 
f

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
esxcli network nic get -n vmnicx # 查看驱动版本
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

```sql
# 开启局域网访问
mysql>use mysql;
mysql>update user set host = '%' where user ='root';
mysql>select host, user from user;
mysql>flush privileges; 

# 授权root用户远程登录
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%'  IDENTIFIED BY 'admin123'  WITH GRANT OPTION;
flush privileges;
"admin123"为密码。
# 还要开放端口
yum -y install iptables-services
[root@localhost ~]# cat /etc/sysconfig/iptables
*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
COMMIT
[root@localhost ~]#
drop table user_back # 删除表

# 全库备份
mysqldump --single-transaction -uroot -proot -A >/tmp/all_20190413.sql

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

```shell
smartctl -a /dev/sda | grep -i seri # 查看sn号
grep -i crc * # crc 查询
grep err * # fio 无error
grep /s * # 硬盘速率

lsscsi #查看盘的 号

arcconf getconfig 1 ar #逻辑盘
arcconf getconfig 1 pd | grep -i slot  # slot
arcconf create 1 logicaldrive (1024 or max) 0 0 4 0 5 # raid 
0 创建
arcconf identify 1 device 0 1 # 电灯
arcconf identify 1 logicaldrive 0 time 180 # diandneg

arcconf DELETE 1 logicaldrive 0         # 删除第1个控制器的第0个逻辑盘
arcconf DELETE 1 logicaldrive ALL       # 删除第1个控制器的所有逻辑盘
arcconf getconfig 1 pd |grep -5 -i "sdd" # 硬盘查看位置
arcconf setstate 1 device 0 x DDD #  使物理盘离线） 上线时重新插拔

# 2.2 测试磁盘写能力
time dd if=/dev/zero of=/testw.dbf bs=4k count=100000
1.
# 因为/dev//zero是一个伪设备，它只产生空字符流，对它不会产生IO，所以，IO都会集中在of文件中，of文件只用于写，所以这个命令相当于测试磁盘的写能力。命令结尾添加oflag=direct将跳过内存缓存，添加oflag=sync将跳过hdd缓存。

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

nvme id-ctrl /dev/nvme0 | grep -E "cntlid|nn|tnvmcap"

	umount /mnt > /dev/null 
	mount.cifs -o username=sit,password=h3c@123 //172.16.0.100/d /mnt

	 mount.cifs -o username=sit,password=fql@a20 //172.16.0.100/d /mnt > /dev/null  
	 
 

```

## suse 源

```shell
zypper ar file:///opt/update update
qaucli -b all -rg all bk010706.bin
```



## Windows

SecureBootUEFI

```

只关闭 pk
You need to set Platform in "User Mode", Secure Boot in "Standard Mode" and Load Setup Defaults.

You could do it by Restoring Factory Keys:

BIOS - Security - Secure Boot - Restore Factory Keys - Enter
BIOS - Restart - OS Optimized Defaults - Enabled
BIOS - Restart - Load Setup Defaults - Enter
Go to BIOS - Main and check if UEFI Secure Boot is ON.

原因：
You might be in Setup Mode because you have deleted the Platform Key in your BIOS. Enabling Secure Boot in this state enables your OS to write a new Platform Key (possibly useful for securing a Linux installation). But if you don't do that, you remain in Setup Mode and the Secure Boot State, indicating the Platform Key has been used to secure the system, will remain off.

Your BIOS might have an option to restore the default Platform Key, possibly called "Restore Default Secure Boot Keys", which restores the Microsoft Key. After doing that, your Secure Boot State will be On when booting Windows.
```







•	WS2022 release: https://support.microsoft.com/en-gb/topic/march-14-2023-kb5023705-os-build-20348-1607-31770c64-430e-4b0e-8eb4-175980e29f3b
•	Hotfix Search: https://www.catalog.update.microsoft.com/home.aspx





## ib 模式切换

```
修改网卡的工作模式：
Ethernet模式：
IB模式： mlxconfig -d /dev/mst/mt4119_pciconf0 set LINK_TYPE_P1=1

```


## 设置交换机ssh 登录

```shell
# 开启Stelnet服务器功能。
[Switch] interface vlan-interface 1

[Switch-Vlan-interface1] ip address 192.168.1.40 255.255.255.0

[Router] ssh server enable

# 设置Stelnet客户端登录用户线的认证方式为AAA认证。

[Router] line vty 0 63

[Router-line-vty0-63] authentication-mode scheme

[Router-line-vty0-63] quit

# 创建设备管理类本地用户client001，并设置密码为明文aabbcc，服务类型为SSH，用户角色为network-admin。

[Router] local-user client001 class manage

[Router-luser-manage-client001] password simple aabbcc

[Router-luser-manage-client001] service-type ssh

[Router-luser-manage-client001] authorization-attribute user-role network-admin

[Router-luser-manage-client001] quit
```

```
 Ubuntu 18 安装时卡在66% update-grub处
已知bug。

可以参考此文档解决：https://unix.stackexchange.com/questions/511289/ubuntu-18-04-server-installation-gets-stuck-at-66-while-runningupdate-grub

方法如下：

在卡在66%时 同时按下Ctrl+Alt+F2键，进入命令行模式，删除prober，执行

rm /target/etc/grub.d/30_os-prober
查找到dmsetup进程id

ps | grep 'dmsetup create'
杀掉查找到的进程

kill 67619
按下Ctrl+Alt+F1键，回到安装OS的图形界面，会发现已经继续正常安装


```

## 7.6 源

```shell
[redhat7.6]
 
name=my redhat7.6
 
baseurl=file:///mnt
 
enable=1
 
gpgcheck=0
```

## 8源

```shell
[localREPO]
name=localhost8
baseurl=file:///mnt/BaseOS
enable=1
gpgcheck=0

[localREPO_APP]
name=localhost8_app
baseurl=file:///mnt/AppStream
enable=1
gpgcheck=0

yum clean all
yum makecache
```

## Linux做镜像

```shell
umount /dev/sdc*
mkfs.vfat /dev/sda -I
dd if=imag of=/dev/sdc status=progress
```

## windows mtu 设置 cmd

```shell
驱动 ：Get-WindowsDriver -Online -All
Get-WmiObject Win32_PnPSignedDriver| select DeviceName, Manufacturer, DriverVersion
查询接口的 MTU 值（验证配置结果同）
netsh interface ipv4 show subinterfaces

设置 MTU
netsh interface ipv4 set subinterface "本地连接" mtu=9014 store=persistent
netsh interface ipv4 set subinterface "Ethernet0" mtu=9014 store=persistent
示例 1：将指定的网络适配器设置为不同的 VLAN ID
电源外壳

复制
PS C:\> Set-NetAdapter -Name "Ethernet 1" -VlanID 10\

Get-NetAdapter | select interfaceDescription, name, status,linkSpeed
netsh interface show interface

netsh interface set interface name 'vlan' admin=disable\enable

netsh interface ip set address name='Ehternet' source=static addr=10 maske=11

Get-NetAdapterAdvancedProperty
## 链接网络资源
cmdkey /add:172.16.0.100 /user:sit /pass:h3c@123
1、开启本机远程管理

Copy 
Enable-PSRemoting
2、开启 CredSSP 身份验证

Copy 
Enable-WSManCredSSP -role server
3、关闭防火墙

Copy 
netsh advfirewall set currentprofile state off


### 共享文件夹
1. E:是文件位置
 New-SmbShare -Name "test6" -Path "c:\test6" -Description "Test6 shared" -FullAccess buffallos\adminhuzx -ReadAccess everyone 
 
## windows hyper-v 连接
1. 修改策略
gpedit.msc
Administration templet -> creder-> allow delegating fresh NTLM-only
添加 
wsman/*
termsvr/*
2. 开启
# 开启winrm
winrm quickconfig# winrm安全配置，最后的参数值为 Hyper-V 服务器的主机名（域名）
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "MiniPC-HyperV"# winrm身份验证配置
Enable-WSManCredSSP -Role client -DelegateComputer "MiniPC-HyperV"

3. 输入用户名
.\administarotrr

# devmgmt.msc 设备
 # diskmgmt.msc
```

## windows 关闭防火墙

```shell
关闭防火墙：netsh firewall set opmode mode=disable
关闭防火墙： netsh advfirewall set allprofiles state off


```

### window 自动开机

```shell
https://learn.microsoft.com/en-us/sysinternals/downloads/autologon -- 文档
https://download.sysinternals.com/files/AutoLogon.zip --- 程序
```



## ubuntu 本地源/外网设置

```shell
 sudo apt-cdrom -m -d=/mnt add
 sudo ifconfig eth1 10.213.88.44/24 
 nameserver vim /etc/resov.conf 114.114.114.114
 gw: sudo  route add default gw 10.213.88.1
 ## 安装desktop
 sudo apt-get install ubuntu-desktop
 阿里源
 wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
deb-src http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
```

## 查看系统版



```shell
 lsb_release -a.

/etc/default/grub要么缺少所需的 iommu 值，您尚未运行，sudo update-grub要么sudo update-initramfs -u您尚未重新启动。
```

   

## mlx 网卡升级问题

```shell
mlxnofedinstall --distro rhel7.6 --force
```

### python 调用terminal 串口

```shell
import os 
os.system("gnome-screenshot --file=this.png")
os.system('''gnome-terminal -e 'bash -c "ls; exec bash"' ''')
```

### ubuntu 卡 66%

```shell
在卡在66%时 同时按下Ctrl+Alt+F2键，进入命令行模式，删除prober，执行

rm /target/etc/grub.d/30_os-prober
查找到dmsetup进程id

ps | grep 'dmsetup create'
杀掉查找到的进程

kill 67619
按下Ctrl+Alt+F1键，回到安装OS的图形界面，会发现已经继续正常安装
```

### htop 安装问题

```shell
configure: error: You may want to use --disable-unicode or install libncursesw.
yum install -y ncurses-devel
./configure&&make&&make install
```

### 交换机密码默认

```shell
line vty 0 63
auto-execute
authentication-mode none
```

## 翻墙

```shell
# Windows
https://free886.herokuapp.com/clash # 订阅地址
https://github.com/zu1k/proxypool # 软件
https://github.com/Fndroid/clash_for_windows_pkg/releases# 下载地址
```

> Do not go gentle into that good night
>
> Old age should burn and rave at close of day;
>
> Rage, rage against the dying of the light.
>
> Though wise men at their end know dark is right 
>
> Because their words had forked no lighting 
>
> they Do not go gentle into that good night
>
> Do not go gentle into that good night
>
> Good men, the last wave by cring how bright 
>
> Their frail deeds might have danced in a green bay
>
> Rage rage against the dying of the light
>
> Wild men who caught and sang the sun in flight 
>
> And learn, too late they grieved it on its way
>
> Do not go gentle into that good night
>
> Grave men, near death who see with blinding sight
>
> Blind eyes could blaze like meters and be gay
>
> Rage, rage against the dying of the light
>
> And you, my father there on the sad height
>
> Curse, bless me now with your fierce tears, I pray.
>
> Do not go gentle into that good night
>
> Rage, rage against the dying of the light.
>
> Do not go gentle into that good night
>
> Old age should burn and rave at close of day
>
> rage, rage against the dying of the light
>
> though wise men at their end know dark is right
>
> because their words had forked no lightning they 
>
> do not go gentle into that good night













## 防火墙

```shell
添加
iptables
firewall-cmd --zone=public --add-port=80/tcp --permanent   （--permanent永久生效，没有此参数重启后失效）

重新载入

firewall-cmd --reload

查看

firewall-cmd --zone=public --query-port=80/tcp

删除

firewall-cmd --zone=public --remove-port=80/tcp --permanent



```






```shell

yum install sysstat zip bc libaio sos kexec-tools libibverbs libpmemblk librados2 librbd1 fio iperf3  python3 -y fio-engine-libaio


 export http_proxy=http://172.16.69.89:8080
export https_proxy=http://172.16.69.89:8080


```



# m.2 的盘序固定

```shell
# 第1章的方法仅仅能保证安装时M.2的硬盘在最前面，即/dev/sda，但是在重启后这个顺序将不能保证，因此本章的目的是如果将这个配置固化下来。详细步骤如下：

# 1.OS启动后，在系统文件/boot/efi/EFI/centos/grub.cfg中增加
rdloaddriver=megaraid_sas rdloaddriver=mpt3sas
```

```shell
PN号: lspci -vvv- n -s bus \|grep -i '\[PN]'
SN号: lspci -vvv- n -s bus \|grep -i '\[SN]'

Vendor ID|15b3|setpci -s bus号 0.l
Device ID|1017|setpci -s bus号 0.l
SubVendor ID|15b3|setpci -s bus号 2c.l
Subdevice ID|0020|setpci -s bus号 2c.l
```








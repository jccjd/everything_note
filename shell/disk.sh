if  test -z "$bootdisk" 

if test -z "$bootdisk"; then
    # Code to execute if $bootdisk is empty
    echo "bootdisk is empty"
else
    # Code to execute if $bootdisk is not empty
    echo "bootdisk is not empty"
fi
# 查询 当系统盘为SATA SAS时盘符名称 为 /dev/sd* 系统盘为 nvme 时 系统盘为 /dev/nvme*
bootdisk=`df -h | awk '{print $1}' | grep -iE "/dev/sd" | sed 's/[0-9]//g' |sort -u`
bootdisk=`df -h | awk '{print $1}' | grep -iE "/dev/nvme" | sed 's/p[0-9]//g' |sort -u`
#  awk command that extracts and prints the first column of text form the input.
#  grep -iE  -E the flag enables extended regular expressions. it allows you to use more advanced regular expressions in your pattern
#  sed 's/[0-9]//g'  s this indicates表示  that you are performing执行 a substitution 替换
#  sed 's/[0-9]//g'  [0-9] 数字 0-9 
#  sed 's/[0-9]//g'  // this is the replacement part of the command. Since it's empty is means you're replacing the matched digits with nothing
#  sed 's/[0-9]//g'  g this flag stands for 'global'
non_system_disk = lsblk | grep -i disk | grep -vw "$osdisk" | awk '{print $1}' | grep nvme




# 运行代码
#!/bin/bash

# Find OS disk (sdx or nvmeXn1)
bootdisk=$(df -h | awk '{print $1}' | grep -E "/dev/(sd|nvme)" | sed 's/p[0-9]*//g' | sort -u)
osdisk="${bootdisk#/dev/}"

date_time=$(date +%Y.%m.%d.%H.%M.%S)

partition_and_format() {
    local nvmey="$1"
    parted "/dev/${nvmey}" mklabel gpt
    echo I | parted "/dev/${nvmey}" mkpart primary 0 30% --align=optimal
    parted "/dev/${nvmey}" mkpart primary 30% 100% --align=optimal

    mkfs.ext4 "/dev/${nvmey}p1"
    mount "/dev/${nvmey}p1" /mnt
    dd if=/dev/urandom of="/mnt/${nvmey}_10Gfile" bs=1024k count=10240
    umount /mnt

    mount "/dev/${nvmey}p1" /mnt
    md5sum "/mnt/${nvmey}_10Gfile" > "${nvmey}_md5_basic_$date_time"
    umount /mnt
}

# Loop through each non-system NVMe disk and perform actions
for nvmey in $(lsblk | grep -i disk | grep -vw "$osdisk" | awk '{print $1}' | grep nvme); do
    partition_and_format "$nvmey"
done

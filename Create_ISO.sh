dnf install rsync createrepo genisoimage wget gzip -y
# 获取脚本所在目录
work_dir=$(cd "$(dirname "$0")" && pwd)
output_dir=${1:-$work_dir}
echo "output_dir:"$output_dir
$work_dir/destroy.sh $output_dir
# 检测是否已存在centos-steam8的原始ISO，如果没有，就用wget现从清华源下载一个
if [ ! -f "./CentOS-Stream-8-x86_64-latest-dvd1.iso" ]; then

	wget https://repo.huaweicloud.com/centos/8-stream/isos/x86_64/CentOS-Stream-8-x86_64-latest-dvd1.iso --user-agent=" Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:84.0) Gecko/20100101 Firefox/84.0"

else

	echo "file exist,sikp download"

fi
# 检测这个ISO是否已经被挂载，如果已经被挂载则先卸载
mount_check=$(mount | grep CentOS-Stream-8-x86_64-latest-dvd1.iso | wc -l)
if [ $mount_check -eq 0 ]; then
	{
		echo "iso not mount,sikp umonut"
	}
else
	{
		umount ./CentOS-Stream-8-x86_64-latest-dvd1.iso -fl
	}
fi

mount ./CentOS-Stream-8-x86_64-latest-dvd1.iso /media -r
mkdir /iso

rsync -av --progress /media/ /iso/ --exclude BaseOS --exclude AppStream

mkdir -p /iso/AppStream/Packages
mkdir -p /iso/BaseOS/Packages

$work_dir/Copy.sh

cp /media/BaseOS/repodata/*comps*.xml /iso/BaseOS/comps_base.xml
cp /media/AppStream/repodata/*comps*.xml /iso/AppStream/comps_app.xml

cd /iso/AppStream
createrepo -g comps_app.xml .
cd /iso/BaseOS
createrepo -g comps_base.xml .

cd /iso/AppStream
cp /media/AppStream/repodata/*modules.yaml* ./
gunzip fc97cae5256d30345b2d5a17292f712365d912dca63b93f3b00ba9930f9551c0-modules.yaml.gz
cp fc97cae5256d30345b2d5a17292f712365d912dca63b93f3b00ba9930f9551c0-modules.yaml modules.yaml
modifyrepo_c --mdtype=modules ./modules.yaml ./repodata/

mkdir -p /iso/ExtraPackages/Packages/
cd /iso/ExtraPackages/
# 使用centos光盘源下载所需的软件包，相比原始脚本（BIOS），需求增加了grub2-efi-x64 dosfstools efibootmgr shim-x64这几个软件包
echo download package
dnf -4 download --disablerepo="*" --repofrompath=centos_appstream,https://repo.huaweicloud.com/centos/8-stream/AppStream/x86_64/os/ --repofrompath=centos_baseos,https://repo.huaweicloud.com/centos/8-stream/BaseOS/x86_64/os/ --repofrompath=centos_epel,https://repo.huaweicloud.com/epel/8/Everything/x86_64 --repofrompath=centos_el,https://download1.rpmfusion.org/free/el/updates/8/x86_64/ -y --resolve --downloadonly --downloaddir=/iso/ExtraPackages/Packages/ genisoimage libusal qemu-kvm libvirt virt-install cockpit cockpit-machines bash-completion vim grub2-efi-x64 dosfstools efibootmgr shim-x64 pciutils usbutils util-linux net-tools ntfs-3g kernel-modules-extra systemd-container systemd libxml2 exfat-utils fuse-exfat
if [ $? -eq 0 ]; then
	echo download complete
else
	echo "download failed"
	exit 1
fi
createrepo .

cp $work_dir/ks.cfg /iso/ks.cfg
cp $work_dir/isolinux.cfg /iso/isolinux/isolinux.cfg
cp $work_dir/grub.cfg /iso/EFI/BOOT/grub.cfg

cd /iso
mkisofs -o $output_dir/MyNode-20230313-x86_64-V1.iso -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -eltorito-alt-boot -e images/efiboot.img -no-emul-boot -R -J -T -V "MyNode" .
echo "output:$output_dir/MyNode-20230313-x86_64-V1.iso"

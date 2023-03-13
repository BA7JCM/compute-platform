dnf install rsync createrepo genisoimage -y

mount ~/CentOS-Stream-8-x86_64-latest-dvd1.iso /media
mkdir /iso

rsync -av --progress /media/ /iso/ --exclude BaseOS --exclude AppStream

mkdir -p /iso/AppStream/Packages
mkdir -p /iso/BaseOS/Packages

./Copy.sh

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
dnf install -y --downloadonly --downloaddir=/iso/ExtraPackages/Packages/ genisoimage qemu-kvm libvirt virt-install cockpit cockpit-machines bash-completion vim
dnf download -y --alldeps --resolve --allowerasing --downloadonly --downloaddir=/iso/ExtraPackages/Packages/ genisoimage
createrepo .

cp ~/ks.cfg /iso/ks.cfg
cp ~/isolinux.cfg /iso/isolinux/isolinux.cfg

cd /iso
mkisofs -o ~/MyNode-20230313-x86_64-V1.iso -b isolinux/isolinux.bin -c isolinux/boot.cat --no-emul-boot --boot-load-size 4 --boot-info-table -J -R -V "MyNode" .

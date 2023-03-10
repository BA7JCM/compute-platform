RPM_FILE="/root/minimal_pkg_name.log"
for pkg in `cat $RPM_FILE`; do
    RPM=`find /media/ -name $pkg*.rpm`
    if [[ $RPM =~ .*BaseOS.* ]];then
        cp -ap $RPM /iso/BaseOS/Packages/
    elif [[ $RPM =~ .*AppStream.* ]];then
        cp -ap $RPM /iso/AppStream/Packages/
    else
        echo "$pkg not found"
    fi
done
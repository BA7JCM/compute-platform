# compute-platform

## To what

This repo include all script you will use when develop Compute-platfrom.

Following tree map show you all the files in Verison 1

```
compute-platform/
├── Copy.sh
├── Create_ISO.sh
├── README.md
├── comps.xml
├── destroy.sh
├── isolinux.cfg
├── ks.cfg
└── minimal_pkg_name.log
```

`Copy.sh` to copy minimal install `CentOS 8` needed package from CDROM

`Create_ISO.sh` to create a ISO in simple way, you could write a more convenient script with `shell` `python` and so on.

`comps.xml` is a test file when bulid a repo.

`destroy.sh` make you back to init environment in a simple way like `Create_ISO_BIOS.sh` 

`isolinux.cfg` is a file for the boot page which you must use when create a ISO.

`ks.cfg` this file allows you to install your ISO automatically. Any packages or partitioning policies that need to be installed are also defind here.

`minimal_pkg_name.log` is a list that clude all package you need when you install a minimal CentOS 8. Used as a data source for  `Copy.sh .`

`grub.cfg` A file for boot with UEFI.

## Usage

1. Install a minimal `CentOS 8` , then you'd better make a snapshot. It's usefule when environment down.
2. The Best way to use aforementioned file is to download and upload to your directory in virtual machine manual instead of `git clone`
3. Then the script must be empowered with command `chmod +x`
4. To create ISO use command `./Create_ISO_BIOS.sh` in your directory
5. To clean the environment use command `./destroy.sh` in your directory

## Next to do

* [ ] Improve script
* [ ] Provides a more foolproof way to generate images

## Contact repo Administrator

[E-mail](mailto:fanxf.work@outlook.com)
[raise up a Issue](https://github.com/yhTech-RD/compute-platform/issues)

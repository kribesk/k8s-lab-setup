@ECHO OFF
ECHO Using SSD (S:) for VMs

MD S:\vbox
"C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" setproperty machinefolder "S:\vbox"

ECHO Copying coreos images, if they exist it workdir...
REM MD S:\coreos
XCOPY /E coreos S:\coreos

ECHO Configuring Realtek (CISCO) adapter...

netsh int set int "CISCO" admin=enabled
netsh int ipv4 set addr "CISCO" dhcp
netsh int ipv4 set dns "CISCO" dhcp validate=no

ECHO Check if CISCO network cable is connected, otherwise vagrant will bridge to wrong adapter!
PAUSE

ECHO Rebuilding vagrant box...
vagrant destroy
vagrant up
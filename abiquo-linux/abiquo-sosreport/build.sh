CHROOT=centos-5.4-x86_64
CHROOT_DIR=/var/lib/mock/$CHROOT/root
PKGNAME=abiquo-sosreport-plugins

mkdir tmp
mkdir rpms

rm abiquo*.py

wget -q http://github.com/abiquo/abiquo-report-sos-plugin/raw/master/abiquo_kvm_node.py
wget -q http://github.com/abiquo/abiquo-report-sos-plugin/raw/master/abiquo_xen_node.py
wget -q http://github.com/abiquo/abiquo-report-sos-plugin/raw/master/abiquo_server.py

/usr/bin/mock --init -r  $CHROOT

/usr/bin/mock -r $CHROOT --copyin "abiquo_xen_node.py" /builddir/build/SOURCES/
/usr/bin/mock -r $CHROOT --copyin "abiquo_kvm_node.py" /builddir/build/SOURCES/
/usr/bin/mock -r $CHROOT --copyin "abiquo_server.py" /builddir/build/SOURCES/
/usr/bin/mock -r $CHROOT --copyin $PKGNAME.spec /root
/usr/bin/mock -r $CHROOT --shell "rpmbuild -ba /root/$PKGNAME.spec"

cp $CHROOT_DIR/builddir/build/RPMS/*.rpm rpms
cp $CHROOT_DIR/builddir/build/SRPMS/*.rpm rpms/SRPMS/
rm -rf tmp

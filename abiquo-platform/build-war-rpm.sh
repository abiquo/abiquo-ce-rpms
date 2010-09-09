CHROOT=centos-5.5-x86_64
CHROOT_DIR=/var/lib/mock/$CHROOT/root
BASEDIR=$PWD
MOCK_CMD="/usr/bin/mock -q"

function log()
{
  echo $1
}

function eif()
{
  $1
  if [ $? != 0 ]; then
    log "ERROR: $1 failed"
    exit 1
  fi
}

if [ -z $PKGNAME ]; then
  echo "PKGNAME env variable not defined."
  exit
fi
if [ -z $PKGVER ]; then
  echo "PKGNAME env variable not defined."
  exit
fi
if [ -z $WAR_URL ]; then
  echo "WAR_NAME env variable not defined."
  exit
fi
if [ -z $WAR_NAME ]; then
  echo "WAR_NAME env variable not defined."
  exit
fi


log "Preparing the environment..."
rm -rf $BASEDIR/tmp/
mkdir tmp
rm -rf $BASEDIR/rpms
mkdir -p rpms/SRPMS

log "Downloading WAR..."
cd tmp
eif "wget -q $WAR_URL"
cd $BASEDIR

log "Uncompressing WAR..."
cd $BASEDIR/$PKGNAME-$PKGVER/tomcat/webapps 
rm -rf $WAR_NAME
mkdir $WAR_NAME
cd $WAR_NAME
eif "unzip -q $BASEDIR/tmp/$WAR_NAME.war"
if [ -d WEB-INF/classes/conf/ ]; then
  cd WEB-INF/classes/conf/
  mv config.xml $BASEDIR/$PKGNAME-$PKGVER/config/$WAR_NAME.xml
  ln -s ../../../../../../config/$WAR_NAME.xml config.xml
fi
cd $BASEDIR

log "Creating the PKG in a mock chroot..."
cd $BASEDIR
$MOCK_CMD --init -r  $CHROOT
tar czf $BASEDIR/tmp/$PKGNAME-$PKGVER.tar.gz $PKGNAME-$PKGVER
$MOCK_CMD -r $CHROOT --copyin tmp/$PKGNAME-$PKGVER.tar.gz /builddir/build/SOURCES/
$MOCK_CMD -r $CHROOT --copyin $PKGNAME.spec /root
$MOCK_CMD -r $CHROOT --shell "rpmbuild -ba /root/$PKGNAME.spec"
if [ $? != 0 ]; then
  log "Error building packages. Aborting."
  exit 1
fi

log "Copying resulting RPMs..."
cp $CHROOT_DIR/builddir/build/RPMS/*.rpm rpms
cp $CHROOT_DIR/builddir/build/SRPMS/*.rpm rpms/SRPMS/
rm -rf tmp

#!/bin/sh
#-- _PACK_NAME for Slackware --
# Build script by Phantom X <megaphantomx at bol.com.br>
# Suggested usage: $ _PACK_NAME.SlackBuild 2>&1 | tee build.log
#--
# Copyright 2008-2013 Phantom X, Goiania, Brazil.
# Copyright 2006 Martijn Dekker, Groningen, Netherlands.
# All rights reserved.
#
# Redistribution and use of this script, with or without modification, is
# permitted provided that the following conditions are met:
#
# 1. Redistributions of this script must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#
#  THIS SOFTWARE IS PROVIDED BY THE AUTHOR `AS IS'' AND ANY EXPRESS OR IMPLIED
#  WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
#  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO
#  EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
#  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
#  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
#  OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
#  WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
#  OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
#  ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#

PACKAGER_ID=${PACKAGER_ID:-$USER}
PACKAGER=${PACKAGER:-$USER@$HOSTNAME}

# Set YES for native build with gcc >= 4.2
SB_NATIVE=${SB_NATIVE:-NO}

# Set to YES to replicate slackbuild and patches
SB_REP=${SB_REP:-YES}

CWD=$(pwd)
TMP=${TMP:-/tmp}
if [ ! -d ${TMP} ]; then
  mkdir -p ${TMP}
fi

NAME=_PACK_NAME
PKG=${PKG:-${TMP}/package-${NAME}}

VERSION=${VERSION:-_PACK_VER}
if [ "${SB_NATIVE}" = "YES" ] ;then
  ARCH=${ARCH:-$(uname -m)}
else
  ARCH=${ARCH:-x86_64}
fi
if [ "${ARCH}" = "x86_64" ] ;then
  SLKTARGET=${SLKTARGET:-x86_64}
else
  SLKTARGET=${SLKTARGET:-i486}
fi
SLKDIST=${SLKDIST:-Slackware}
BUILD=${BUILD:-1}
NJOBS=${NJOBS:-$(( $(getconf _NPROCESSORS_ONLN) + 1 ))}
DOCDIR=${PKG}/usr/doc/${NAME}-${VERSION}
SBDIR=${PKG}/usr/src/slackbuilds/${NAME}
PKGDEST=${PKGDEST:-${CWD}}
PKGFORMAT=${PKGFORMAT:-tgz}
PKGNAME=${NAME}-$(echo ${VERSION} | tr - . )-${ARCH}-${BUILD}${PACKAGER_ID}

DATE=$(LC_ALL=C date +%d-%b-%Y)

SRCDIR=${NAME}-${VERSION}
SRCARCHIVE=${SRCDIR}.tar.bz2

DL_PROG=${DL_PROG:-wget}
DL_TO=${DL_TO:-5}
DL_OPTS=${DL_OPTS:-"--timeout=${DL_TO}"}
MIRROR_SF=${MIRROR_SF:-http://prdownloads.sourceforge.net}
DL_URL="${MIRROR_SF}/${NAME}/${SRCARCHIVE}"

# if source is not present, download in source rootdir if possible
test -r ${CWD}/${SRCARCHIVE} || ${DL_PROG} ${DL_OPTS} ${DL_URL} || exit 1

if [ "${SB_NATIVE}" = "YES" ] ;then
  SLKCFLAGS="-O2 -march=native -mtune=native -pipe"
  [ "${SB_ECFLAGS}" ] && SLKCFLAGS="${SLKCFLAGS} ${SB_ECFLAGS}"
else
  case "${ARCH}" in
    i[3-6]86)    SLKCFLAGS="-O2 -march=${ARCH} -mtune=i686"
                 ;;
    x86_64)      SLKCFLAGS="-O2 -fPIC"
                 ;;
    s390|*)      SLKCFLAGS="-O2"
                 ;;
  esac
fi
if [ "${ARCH}" = "x86_64" ] ;then
  LIBDIRSUFFIX="64"
  SLKCFLAGS="${SLKCFLAGS} -fPIC"
else
  LIBDIRSUFFIX=""
fi

if [ -d ${PKG} ]; then
  # Clean up a previous build
  rm -rf ${PKG}
fi
mkdir -p ${PKG}

cd ${TMP}
rm -rf ${SRCDIR}
tar -xvf ${CWD}/${SRCARCHIVE} || exit 1
cd ${SRCDIR} || exit 1

chmod -R u+w,go+r-w,a-s .

if [ -r ${CWD}/apply-patches.sh ]; then
  . ${CWD}/apply-patches.sh || exit 1
fi

export CFLAGS="${SLKCFLAGS}"
export CXXFLAGS="${SLKCFLAGS}"
export FFLAGS="${SLKCFLAGS}"

mkdir -p build
( cd build || exit $?

  cmake .. \
    -DCMAKE_INSTALL_PREFIX:PATH=/usr \
    -DSYSCONF_INSTALL_DIR:PATH=/etc \
    -DINCLUDE_INSTALL_DIR:PATH=/usr/include \
    -DLIB_INSTALL_DIR:PATH=/usr/lib${LIBDIRSUFFIX} \
    -DLIB_SUFFIX=${LIBDIRSUFFIX} \
    -DSHARE_INSTALL_PREFIX:PATH=/usr/share \
    -DMAN_INSTALL_DIR:PATH=/usr/man \
    -DCMAKE_BUILD_TYPE:STRING=Release \
    -DBUILD_SHARED_LIBS:BOOL=ON \
    -DCMAKE_SKIP_RPATH:BOOL=ON \
    -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON \
    || exit $?

  make -j${NJOBS} || make || exit $?
  make install/fast DESTDIR=${PKG} || exit $?

) || exit $?

find ${PKG} | xargs file | grep -e "executable" -e "shared object" | grep ELF \
  | cut -f 1 -d : | xargs strip --strip-unneeded 2> /dev/null

# Add a documentation directory:
mkdir -p ${DOCDIR}
cp -a \
  AUTHORS COPYING LICENSE README NEWS THANKS TODO ${CWD}/ChangeLog.SB \
  ${DOCDIR}/
[ -r ChangeLog ] && head -n 1000 ChangeLog > ${DOCDIR}/ChangeLog
find ${DOCDIR}/ -type d -print0 | xargs -0 chmod 0755
find ${DOCDIR}/ -type f -print0 | xargs -0 chmod 0644
find ${DOCDIR}/ -type f -size 0 -print0 | xargs -0 rm -f

# Compress and link manpages, if any:
if [ -d ${PKG}/usr/share/man ]; then
  mv ${PKG}/usr/share/man ${PKG}/usr/man
  rmdir ${PKG}/usr/share
fi
if [ -d ${PKG}/usr/man ]; then
  ( cd ${PKG}/usr/man
    for manpagedir in $(find . -type d -name "man*") ; do
      ( cd ${manpagedir}
        for eachpage in $( find . -type l -maxdepth 1) ; do
          ln -s $( readlink ${eachpage} ).gz ${eachpage}.gz
          rm -f ${eachpage}
        done
        gzip -9 *.?
        # Prevent errors
        rm -f *.gz.gz
      )
    done
  )
fi

# Compress info pages, if any:
if [ -d ${PKG}/usr/info ]; then
  ( cd ${PKG}/usr/info
    rm -f dir
    gzip -9 *.info*
  )
fi

mkdir -p ${PKG}/install
cat ${CWD}/slack-desc > ${PKG}/install/slack-desc
cat ${CWD}/slack-required > ${PKG}/install/slack-required

cat > ${PKG}/install/doinst.sh <<EOF
#!/bin/sh
# Figure out our root directory
ROOTDIR=\$(pwd)
unset CHROOT
if test "\${ROOTDIR}" != "/"; then
  CHROOT="chroot \${ROOTDIR} "
  ROOTDIR="\${ROOTDIR}/"
fi
# Install the info files for this package
if [ -x usr/bin/install-info ] ; then
  \${CHROOT} /usr/bin/install-info --info-dir=/usr/info /usr/info/${NAME}.info.gz 2>/dev/null
fi
config() {
  NEW="\$1"
  OLD="\$(dirname \$NEW)/\$(basename \$NEW .new)"
  # If there's no config file by that name, mv it over:
  if [ ! -r \$OLD ]; then
    mv \$NEW \$OLD
  elif [ "\$(cat \$OLD | md5sum)" = "\$(cat \$NEW | md5sum)" ]; then
    # toss the redundant copy
    rm \$NEW
  fi
  # Otherwise, we leave the .new copy for the admin to consider...
}
## List of conf files to check.  The conf files in your package should end in .new
EOF

( cd ${PKG}
  find etc/ -name '*.new' -exec echo config {} ';' | sort >> ${PKG}/install/doinst.sh
  find etc/ -name '*.new' -a -size 0 -exec echo rm -f {} ';' | sort >> ${PKG}/install/doinst.sh
  echo >> ${PKG}/install/doinst.sh
)

sed -i "s|_PACKAGER|${PACKAGER}|g; s|_BUILD_DATE|${DATE}|g" \
  ${PKG}/install/slack-desc

if [ "${SB_REP}" = "YES" ] ;then
  # Replicate slackbuild and patches
  mkdir -p ${SBDIR}/patches
  install -pm0644 ${CWD}/slack-desc ${CWD}/slack-required ${CWD}/ChangeLog.SB \
    ${CWD}/apply-patches.sh ${SBDIR}/
  install -pm0755 ${CWD}/${NAME}.SlackBuild \
    ${SBDIR}/${NAME}.SlackBuild
  install -pm0644 ${CWD}/patches/*.* \
    ${SBDIR}/patches/
  rmdir ${SBDIR}/patches
fi

# Build package:
set +o xtrace        # no longer print commands upon execution
set -e

ROOTCOMMANDS="set -o errexit -o xtrace ; cd ${PKG} ;
  /bin/chown --recursive root:root .  ;"

ROOTCOMMANDS="${ROOTCOMMANDS}
  /sbin/makepkg --linkadd y --chown n ${PKGDEST}/${PKGNAME}.${PKGFORMAT} "

if test ${UID} = 0; then
  eval ${ROOTCOMMANDS}
  set +o xtrace
elif test "$(type -t fakeroot)" = 'file'; then
  echo -e "\e[1mEntering fakeroot environment.\e[0m"
  echo ${ROOTCOMMANDS} | fakeroot
else
  echo -e "\e[1mPlease enter your root password.\e[0m (Consider installing fakeroot.)"
  /bin/su -c "${ROOTCOMMANDS}"
fi

# Clean up the extra stuff:
if [ "$1" = "--cleanup" ]; then
  echo "Cleaning..."
  if [ -d ${TMP}/${SRCDIR} ]; then
    rm -rf ${TMP}/${SRCDIR} && echo "${TMP}/${SRCDIR} cleanup completed"
  fi
  if [ -d ${PKG} ]; then
    rm -rf ${PKG} && echo "${PKG} cleanup completed"
  fi
  rmdir ${TMP} && echo "${TMP} cleanup completed"
fi
exit 0

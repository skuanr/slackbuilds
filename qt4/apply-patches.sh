#!/bin/sh

set -e -o pipefail

SB_PATCHDIR=${CWD}/patches

PATCHCOM="patch -p1 -F1 -s --verbose"

ApplyPatch() {
  local patch=$1
  shift
  if [ ! -f ${SB_PATCHDIR}/${patch} ]; then
    exit 1
  fi
  case "${patch}" in
  *.bz2) bzcat "${SB_PATCHDIR}/${patch}" | ${PATCHCOM} ${1+"$@"} ;;
  *.gz) zcat "${SB_PATCHDIR}/${patch}" | ${PATCHCOM} ${1+"$@"} ;;
  *) ${PATCHCOM} ${1+"$@"} -i "${SB_PATCHDIR}/${patch}" ;;
  esac
}

IgnorePatch() {
  if [ -n "{IGNORE}" ] ;then
    for patchnumber in ${IGNORE} ;do
      sed -e "/^${patchnumber}/d" -i $1
    done
  fi
}

# patch -p0 -E --backup --verbose ${SB_PATCHDIR}/${NAME}.patch
# don't use -b on mkspec files, else they get installed too.
zcat ${SB_PATCHDIR}/qt-x11-opensource-src-4.2.2-multilib-optflags.patch.gz | patch -p1 -E --verbose

if [ "${_qt4_datadir}" != "${_qt4_prefix}" ] ;then
  zcat ${SB_PATCHDIR}/qt-x11-opensource-src-4.2.2-multilib-QMAKEPATH.patch.gz | patch -p1 -E --verbose
fi
ApplyPatch qt-everywhere-opensource-src-4.7.0-beta1-uic_multilib.patch

# hack around gcc/ppc crasher, http://bugzilla.redhat.com/492185
#zcat ${SB_PATCHDIR}/qt-x11-opensource-src-4.5.0-gcc_hack.patch.gz | patch -p1 -E --verbose
zcat ${SB_PATCHDIR}/qt-x11-opensource-src-4.5.1-enable_ft_lcdfilter.patch.gz | patch -p1 -E --verbose
# include kde4 plugin path, http://bugzilla.redhat.com/498809
#ApplyPatch qt-everywhere-opensource-src-4.7.0-beta2-kde4_plugins.patch 
ApplyPatch qt-everywhere-opensource-src-4.7.0-beta2-phonon_servicesfile.patch 

# may be upstreamable, not sure yet
# workaround for gdal/grass crashers wrt glib_eventloop null deref's
ApplyPatch qt-everywhere-opensource-src-4.6.3-glib_eventloop_nullcheck.patch

## upstreamable bits
# fix invalid inline assembly in qatomic_{i386,x86_64}.h (de)ref implementations
# should fix the reference counting in qt_toX11Pixmap and thus the Kolourpaint
# crash with Qt 4.5
zcat ${SB_PATCHDIR}/qt-x11-opensource-src-4.5.0-fix-qatomic-inline-asm.patch.gz | patch -p1 -E --verbose
# fix invalid assumptions about mysql_config --libs
# http://bugzilla.redhat.com/440673
ApplyPatch qt-everywhere-opensource-src-4.7.0-beta2-mysql_config.patch
# http://bugs.kde.org/show_bug.cgi?id=180051#c22
zcat ${SB_PATCHDIR}/qt-everywhere-opensource-src-4.6.2-cups.patch.gz
# qtwebkit to search nspluginwrapper paths too
ApplyPatch qt-everywhere-opensource-src-4.7.0-beta1-qtwebkit_pluginpath.patch

#zcat ${SB_PATCHDIR}/qt-everywhere-opensource-src-4.6.0-fix-str-fmt.patch.gz | patch -p0 -E --verbose
zcat ${SB_PATCHDIR}/qt-everywhere-opensource-src-4.6.1-add_missing_bold_style.patch.gz | patch -p1 -E --verbose
#zcat ${SB_PATCHDIR}/qt-everywhere-opensource-src-4.6.1-use_ft_glyph_embolden_to_fake_bold.patch.gz | patch -p1 -E --verbose


# security patches
ApplyPatch 0012-Add-context-to-tr-calls-in-QShortcut.patch

# kde-qt patches
ApplyPatch 0004-0005.patch
( SB_PATCHDIR=patches
  # Ignore list, e.g: ="0003 0010"
  export IGNORE="0004 0005 0008"
  IgnorePatch ${SB_PATCHDIR}/list
  for patch in $(<${SB_PATCHDIR}/list) ;do
    ApplyPatch ${patch}
  done
)

set +e +o pipefail

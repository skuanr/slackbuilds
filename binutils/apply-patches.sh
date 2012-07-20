
set -e -o pipefail

SB_PATCHDIR=${CWD}/patches

# patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}.patch
patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/binutils-2.20.51.0.2-libtool-lib64.patch
patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/binutils-2.20.51.0.2-version.patch
patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/binutils-2.20.51.0.2-set-long-long.patch
patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/binutils-2.20.51.0.10-copy-osabi.patch
patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/binutils-2.20.51.0.10-sec-merge-emit.patch
#patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/binutils-2.22.52.0.1-relro-on-by-default.patch
patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/binutils-2.22.52.0.1-export-demangle.h.patch
# Import of patch for FSF PR #14302
patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/binutils-2.22.52.0.4-ar-4Gb.patch
# Import of patch for FSF PR #14189
patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/binutils-2.22.52.0.4-arm-plt-refcount.patch
# Potential patch to fix BZ835957
patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/binutils-2.22.52.0.4-s390-64bit-archive.patch

set +e +o pipefail

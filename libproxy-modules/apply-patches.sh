
set -e -o pipefail

SB_PATCHDIR=${CWD}/patches

# patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}.patch
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/libproxy-0.4.6-mozjs-link_directory.patch
patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/libproxy-0.4.6-xulrunner-2.patch

set +e +o pipefail

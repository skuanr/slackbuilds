
set -e -o pipefail

SB_PATCHDIR=${CWD}/patches

patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/schemas-merge.patch

set +e +o pipefail
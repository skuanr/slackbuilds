
set -e -o pipefail

SB_PATCHDIR=${CWD}/patches

# patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}.patch
zcat ${SB_PATCHDIR}/11mark_trashed_as_read.patch.gz | patch -p1 -E --backup --verbose

# Set to YES if autogen is needed
SB_AUTOGEN=YES

set +e +o pipefail

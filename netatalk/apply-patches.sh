
set -e -o pipefail

SB_PATCHDIR=${CWD}/patches

# patch -p0 -E --backup --verbose -i ${SB_PATCHDIR}/${NAME}.patch
# Fixup some paths in etc2ps.sh
zcat ${SB_PATCHDIR}/netatalk.etc2ps.diff.gz | patch -p1 -E --backup --verbose

# Allow building without xfs quota support
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/netatalk-2.2.2-without_xfs.patch

zcat ${SB_PATCHDIR}/netatalk-2.0.2-uams_no_pie.patch.gz | patch -p1 -E --backup --verbose
zcat ${SB_PATCHDIR}/netatalk-2.0.4-extern_ucreator.patch.gz | patch -p1 -E --backup --verbose
patch -p1 -E --backup --verbose -i ${SB_PATCHDIR}/netatalk-2.2.3-sigterm.patch

set +e +o pipefail

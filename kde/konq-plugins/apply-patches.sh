  
SB_PATCHDIR=${CWD}/patches

# fix build with KDE 4.3.80's version of webkitkde (upstream patch)
zcat ${SB_PATCHDIR}/${NAME}-4.4.0-babelfish-kwebkitpart.patch.gz | patch -p0 -E --backup --verbose || exit 1

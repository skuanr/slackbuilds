
set -e -o pipefail

SB_PATCHDIR=${CWD}/patches

if [ "${SB_SYNUP}" = "YES" ] && [ ! -r ${SB_PATCHDIR}/updates/vim-runtime-syntax-${SYNUPVER}.patch.gz ] ;then
  rm -rf runtime/syntax.orig
  cp -a runtime/syntax runtime/syntax.orig
  echo "Fetching vim syntax updates from ftp.nluug.nl..."
  rsync -avzcP ftp.nluug.nl::Vim/runtime/syntax/ runtime/syntax/
  diff -u -r --new-file runtime/syntax.orig runtime/syntax | gzip -9c \
    > ${SB_PATCHDIR}/updates/vim-runtime-syntax-${SYNUPVER}.patch.gz || :
  rm -rf runtime/syntax
  mv runtime/syntax.orig runtime/syntax
fi

zcat ${SB_PATCHDIR}/vim-7.0-fixkeys.patch.gz | patch -p1 --verbose
zcat ${SB_PATCHDIR}/vim-6.2-specsyntax.patch.gz | patch -p1 --verbose
zcat ${SB_PATCHDIR}/vim-7.0-crv.patch.gz | patch -p1 --verbose
zcat ${SB_PATCHDIR}/xxd-locale.patch.gz | patch -p1 --verbose
if [ "${SB_HUNSPELL}" = "YES" ] ;then
  zcat ${SB_PATCHDIR}/vim-7.0-hunspell.patch.gz | patch -p1 --verbose
fi

for i in $( seq -w ${PATCHLEVEL} ) ; do
  patch -p0 --backup --verbose -i ${SB_PATCHDIR}/updates/${SVER}.${i}
done

if [ "${SB_SYNUP}" = "YES" ] ;then
  zcat ${SB_PATCHDIR}/updates/vim-runtime-syntax-${SYNUPVER}.patch.gz | patch -p0 --verbose
fi

zcat ${SB_PATCHDIR}/vim-7.0-syntax.patch.gz | patch -p1 --verbose
zcat ${SB_PATCHDIR}/vim-7.1-nowarnings.patch.gz | patch -p1 --verbose
zcat ${SB_PATCHDIR}/vim-6.1-rh3.patch.gz | patch -p1 --verbose
zcat ${SB_PATCHDIR}/vim-7.0-rclocation.patch.gz | patch -p1 --verbose
zcat ${SB_PATCHDIR}/vim-6.4-checkhl.patch.gz | patch -p1 --verbose
if [ "${SB_SYNUP}" = "YES" ] ;then
  zcat ${SB_PATCHDIR}/vim-7.2-fstabsyntax2.patch.gz | patch -p1 --verbose
else
  zcat ${SB_PATCHDIR}/vim-7.2-fstabsyntax.patch.gz | patch -p1 --verbose
fi
zcat ${SB_PATCHDIR}/vim-7.0-warning.patch.gz | patch -p1 --verbose
zcat ${SB_PATCHDIR}/vim-7.0-syncolor.patch.gz | patch -p1 --verbose
zcat ${SB_PATCHDIR}/vim-7.0-specedit.patch.gz | patch -p1 --verbose



set +e +o pipefail
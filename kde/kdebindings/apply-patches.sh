  
SB_PATCHDIR=${CWD}/patches

#zcat ${SB_PATCHDIR}/${NAME}-4.4.0-no-rpath.patch.gz | patch -p1 -E --backup -z .no-rpath --verbose || exit 1
#sed -i -e 's!COMMAND smokegen!COMMAND ${PROJECT_BINARY_DIR}/generator/bin/smokegen${CMAKE_EXECUTABLE_SUFFIX}.shell!g' -e 's/WORKING_DIRECTORY/DEPENDS smokegen WORKING_DIRECTORY/g' \
  #smoke/*/CMakeLists.txt || exit 1

zcat ${SB_PATCHDIR}/${NAME}-len-ptr-rfloat.diff.gz | patch -p1 --verbose || exit 1
zcat ${SB_PATCHDIR}/${NAME}-ruby-env.h.diff.gz | patch -p1 --verbose || exit 1
zcat ${SB_PATCHDIR}/${NAME}-rubyconfig.h.diff.gz | patch -p1 --verbose || exit 1
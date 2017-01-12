# Common Ambient Variables:
#   VCPKG_ROOT_DIR = <C:\path\to\current\vcpkg>
#   TARGET_TRIPLET is the current triplet (x86-windows, etc)
#   PORT is the current port name (zlib, etc)
#   CURRENT_BUILDTREES_DIR = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR  = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#

include(vcpkg_common_functions)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/vtk-7.1.0)
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/Kitware/VTK/archive/v7.1.0.zip"
    FILENAME "vtk-7.1.0.zip"
    SHA512 9620f6fc78e20297aabb5883eefcca60112b5a49d2df0b87defc5ec68f5ebddf62077b469af180fe3383bf3a576a161afd38681c41aff173b9bd1ac2fa560b42
)
vcpkg_extract_source_archive(${ARCHIVE})


vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    OPTIONS -DBUILD_TESTING=OFF -DCMAKE_CXX_MP_FLAG=ON -DVTK_Group_Qt=ON -DVTK_QT_VERSION=5
    # OPTIONS_RELEASE -DOPTIMIZE=1
    # OPTIONS_DEBUG -DDEBUGGABLE=1
)

vcpkg_install_cmake()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE ${CURRENT_PACKAGES_DIR}/debug/bin/vtkEncodeString-7.1.exe)
file(REMOVE ${CURRENT_PACKAGES_DIR}/bin/vtkEncodeString-7.1.exe)
file(REMOVE ${CURRENT_PACKAGES_DIR}/debug/bin/vtkHashSource-7.1.exe)
file(REMOVE ${CURRENT_PACKAGES_DIR}/bin/vtkHashSource-7.1.exe)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)
#move include files from subdirectory to the main include directory
file(RENAME ${CURRENT_PACKAGES_DIR}/include/vtk-7.1 ${CURRENT_PACKAGES_DIR}/include_tmp)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/include)
file(RENAME ${CURRENT_PACKAGES_DIR}/include_tmp ${CURRENT_PACKAGES_DIR}/include)


# Handle copyright
file(COPY ${SOURCE_PATH}/Copyright.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/vtk)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/vtk/Copyright.txt ${CURRENT_PACKAGES_DIR}/share/vtk/copyright)
#move cmake files
file(RENAME ${CURRENT_PACKAGES_DIR}/lib/cmake/vtk-7.1 ${CURRENT_PACKAGES_DIR}/share/vtk/vtk-7.1)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/lib/cmake)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/lib/cmake)
#remove bin folders on static build
if(VCPKG_LIBRARY_LINKAGE STREQUAL static)
    file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/bin ${CURRENT_PACKAGES_DIR}/debug/bin)
endif()

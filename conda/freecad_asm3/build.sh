mkdir -p build/release
cd build/release

# temporary workaround for vtk-cmake setup
# should be applied @vtk-feedstock
if [[ ${HOST} =~ .*linux.* ]]; then
    LIBPTHREAD=$(find ${PREFIX} -name "libpthread.so") sed -i 's#/home/conda/feedstock_root/build_artifacts/vtk_.*_build_env/x86_64-conda_cos6-linux-gnu/sysroot/usr/lib.*;##g' ${PREFIX}/lib/cmake/vtk-8.2/Modules/vtkhdf5.cmake 
    cmake_generator="Ninja"
else
    cmake_generator="Unix Makefiles"
fi

cmake -G "$cmake_generator" \
      -D BUID_WITH_CONDA:BOOL=ON \
      -D CMAKE_BUILD_TYPE=Release \
      -D CMAKE_INSTALL_PREFIX:FILEPATH=$PREFIX \
      -D CMAKE_PREFIX_PATH:FILEPATH=$PREFIX \
      -D CMAKE_LIBRARY_PATH:FILEPATH=$PREFIX/lib \
      -D CMAKE_INCLUDE_PATH:FILEPATH=$PREFIX/include \
      -D BUILD_QT5:BOOL=ON \
      -D FREECAD_USE_OCC_VARIANT="Official Version" \
      -D OCC_INCLUDE_DIR:FILEPATH=$PREFIX/include \
      -D USE_BOOST_PYTHON:BOOL=OFF \
      -D FREECAD_USE_PYBIND11:BOOL=ON \
      -D BUILD_ENABLE_CXX11:BOOL=ON \
      -D SMESH_INCLUDE_DIR:FILEPATH=$PREFIX/include/smesh \
      -D FREECAD_USE_EXTERNAL_SMESH=ON \
      -D BUILD_FLAT_MESH:BOOL=ON \
      -D BUILD_WITH_CONDA:BOOL=ON \
      -D PYTHON_EXECUTABLE:FILEPATH=$PREFIX/bin/python \
      -D BUILD_FEM_NETGEN:BOOL=ON \
      -D BUILD_PLOT:BOOL=OFF \
      -D BUILD_SHIP:BOOL=OFF \
      -D OCCT_CMAKE_FALLBACK:BOOL=OFF \
      -D FREECAD_USE_QT_DIALOG:BOOL=ON \
      -D Boost_NO_BOOST_CMAKE:BOOL=ON \
      -D FREECAD_USE_QWEBKIT:BOOL=ON \
      -D BUILD_DYNAMIC_LINK_PYTHON:BOOL=OFF \
      ../..

if [[ ${HOST} =~ .*linux.* ]]; then
    ninja install
else
    cmake --build . --target install --parallel 3
fi
rm -r ${PREFIX}/doc     # smaller size of package!

#!/usr/bin/env sh

# Compile ACCESS-OM2 at 1, 1/4 and 1/10 degree resolution with JRA-55-do forcing
# Andrew Kiss https://github.com/aekiss

set -e

# Disable user gitconfig
export GIT_CONFIG_NOGLOBAL=yes

if [[ -z "${ACCESS_OM_DIR}" ]]; then
    echo "Installing ACCESS-OM2 in $(pwd)"
    export ACCESS_OM_DIR=$(pwd)
fi
export LIBACCESSOM2_ROOT=$ACCESS_OM_DIR/src/libaccessom2

declare -a exepaths=(${ACCESS_OM_DIR}/src/mom/exec/nci/ACCESS-OM/fms_ACCESS-OM.x ${LIBACCESSOM2_ROOT}/build/bin/yatm.exe \
${ACCESS_OM_DIR}/src/cice5/build_auscom_360x300_24p/cice_auscom_360x300_24p.exe \
${ACCESS_OM_DIR}/src/cice5/build_auscom_1440x1080_480p/cice_auscom_1440x1080_480p.exe \
${ACCESS_OM_DIR}/src/cice5/build_auscom_0361_045x045_3600x2700_361p/cice_auscom_0361_045x045_3600x2700_361p.exe \
${ACCESS_OM_DIR}/src/cice5/build_auscom_0361_060x060_3600x2700_361p/cice_auscom_0361_060x060_3600x2700_361p.exe \
${ACCESS_OM_DIR}/src/cice5/build_auscom_0361_090x090_3600x2700_361p/cice_auscom_0361_090x090_3600x2700_361p.exe \
${ACCESS_OM_DIR}/src/cice5/build_auscom_0361_120x135_3600x2700_361p/cice_auscom_0361_120x135_3600x2700_361p.exe \
${ACCESS_OM_DIR}/src/cice5/build_auscom_0722_060x060_3600x2700_722p/cice_auscom_0722_060x060_3600x2700_722p.exe \
${ACCESS_OM_DIR}/src/cice5/build_auscom_0722_090x090_3600x2700_722p/cice_auscom_0722_090x090_3600x2700_722p.exe \
${ACCESS_OM_DIR}/src/cice5/build_auscom_1392_090x090_3600x2700_1392p/cice_auscom_1392_090x090_3600x2700_1392p.exe \
${ACCESS_OM_DIR}/src/cice5/build_auscom_1444_060x060_3600x2700_1444p/cice_auscom_1444_060x060_3600x2700_1444p.exe \
${ACCESS_OM_DIR}/src/cice5/build_auscom_1444_090x090_3600x2700_1444p/cice_auscom_1444_090x090_3600x2700_1444p.exe \
${ACCESS_OM_DIR}/src/cice5/build_auscom_1444_120x135_3600x2700_1444p/cice_auscom_1444_120x135_3600x2700_1444p.exe \
${ACCESS_OM_DIR}/src/cice5/build_auscom_2888_090x090_3600x2700_2888p/cice_auscom_2888_090x090_3600x2700_2888p.exe \
${ACCESS_OM_DIR}/src/cice5/build_auscom_2888_120x135_3600x2700_2888p/cice_auscom_2888_120x135_3600x2700_2888p.exe \
${ACCESS_OM_DIR}/src/cice5/build_auscom_2888_180x180_3600x2700_2888p/cice_auscom_2888_180x180_3600x2700_2888p.exe \
${ACCESS_OM_DIR}/src/mom/bin/mppnccombine.nci)
# ${ACCESS_OM_DIR}/src/matm/build_nt62/matm_nt62.exe
# ${ACCESS_OM_DIR}/src/matm/build_jra55/matm_jra55.exe

cd ${ACCESS_OM_DIR}

# echo "Downloading experiment input data and creating directories..."
# ${ACCESS_OM_DIR}/get_input_data.py

echo "Removing previous executables (if any)..."
for p in "${exepaths[@]}"
do
    rm ${p} && echo "rm ${p}"
done

echo "Compiling YATM file-based atmosphere and libaccessom2... "
cd ${LIBACCESSOM2_ROOT}
source ./build_on_gadi.sh

echo "Compiling MOM5.1..."
cd ${ACCESS_OM_DIR}/src/mom/exp
./MOM_compile.csh --type ACCESS-OM --platform nci

cd ${ACCESS_OM_DIR}/src/cice5
echo "Compiling CICE5.1 at 1 degree..."
make # 1 degree
echo "Compiling CICE5.1 at 1/4 degree..."
make 025deg
# echo "Compiling CICE5.1 at 1/10 degree with NPROCS = 361 ..."
# make 01deg_0361
# echo "Compiling CICE5.1 at 1/10 degree with NPROCS = 722 ..."
# make 01deg_0722
# echo "Compiling CICE5.1 at 1/10 degree with NPROCS = 1392..."
# make 01deg_1392
# echo "Compiling CICE5.1 at 1/10 degree with NPROCS = 1444 ..."
# make 01deg_1444
# echo "Compiling CICE5.1 at 1/10 degree with NPROCS = 2888 ..."
# make 01deg_2888
echo "Compiling CICE5.1 at 1/10 degree using auscom_0361_045x045..."
make 01deg_0361_045x045
echo "Compiling CICE5.1 at 1/10 degree using auscom_0361_060x060..."
make 01deg_0361_060x060
echo "Compiling CICE5.1 at 1/10 degree using auscom_0361_090x090..."
make 01deg_0361_090x090
echo "Compiling CICE5.1 at 1/10 degree using auscom_0361_120x135..."
make 01deg_0361_120x135
echo "Compiling CICE5.1 at 1/10 degree using auscom_0722_060x060..."
make 01deg_0722_060x060
echo "Compiling CICE5.1 at 1/10 degree using auscom_0722_090x090..."
make 01deg_0722_090x090
echo "Compiling CICE5.1 at 1/10 degree using auscom_1392_090x090..."
make 01deg_1392_090x090
echo "Compiling CICE5.1 at 1/10 degree using auscom_1444_060x060..."
make 01deg_1444_060x060
echo "Compiling CICE5.1 at 1/10 degree using auscom_1444_090x090..."
make 01deg_1444_090x090
echo "Compiling CICE5.1 at 1/10 degree using auscom_1444_120x135..."
make 01deg_1444_120x135
echo "Compiling CICE5.1 at 1/10 degree using auscom_2888_090x090..."
make 01deg_2888_090x090
echo "Compiling CICE5.1 at 1/10 degree using auscom_2888_120x135..."
make 01deg_2888_120x135
echo "Compiling CICE5.1 at 1/10 degree using auscom_2888_180x180..."
make 01deg_2888_180x180

echo "Checking all executables have been built..."
for p in "${exepaths[@]}"
do
    ls ${p} || { echo "Build failed!"; exit 1; }
done

source ${ACCESS_OM_DIR}/hashexe.sh

cd ${ACCESS_OM_DIR}
echo "Executables were built using these library versions:"
source ${ACCESS_OM_DIR}/libcheck.sh

echo
echo "$(basename "$0") completed."
echo

# exit 0


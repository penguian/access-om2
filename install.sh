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
${ACCESS_OM_DIR}/src/cice5/build_auscom_3600x2700_722p/cice_auscom_3600x2700_722p.exe \
${ACCESS_OM_DIR}/src/mom/bin/mppnccombine.nci)
# ${ACCESS_OM_DIR}/src/matm/build_nt62/matm_nt62.exe
# ${ACCESS_OM_DIR}/src/matm/build_jra55/matm_jra55.exe

cice_01_sizes="\
0361_045x045_3600x2700_361p \
0361_060x060_3600x2700_361p \
0361_090x090_3600x2700_361p \
0361_120x135_3600x2700_361p \
0722_060x060_3600x2700_722p \
0722_090x090_3600x2700_722p \
1392_090x090_3600x2700_1392p \
1444_060x060_3600x2700_1444p \
1444_090x090_3600x2700_1444p \
1444_120x135_3600x2700_1444p \
2888_090x090_3600x2700_2888p \
2888_120x135_3600x2700_2888p \
2888_180x180_3600x2700_2888p"

cice_01_exepaths=""
for size in $cice_01_sizes
do
  cice_01_exepaths="${cice_01_exepaths} ${ACCESS_OM_DIR}/src/cice5/build_auscom_${size}/cice_auscom_${size}.exe"
done

cd ${ACCESS_OM_DIR}

# echo "Downloading experiment input data and creating directories..."
# ${ACCESS_OM_DIR}/get_input_data.py

echo "Removing previous executables (if any)..."
for p in "${exepaths[@]}" $cice_01_exepaths
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
echo "Compiling CICE5.1 at 1/10 degree..."
make 01deg
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
for p in "${exepaths[@]}" $cice_01_exepaths
do
    ls ${p} || { echo "Build failed!"; exit 1; }
done

source ${ACCESS_OM_DIR}/hashexe.sh

for p in $cice_01_exepaths
do
    cp -a ${p} ${ACCESS_OM_DIR}/bin && echo "cp -a ${p} ${ACCESS_OM_DIR}/bin"
done

cd ${ACCESS_OM_DIR}
echo "Executables were built using these library versions:"
source ${ACCESS_OM_DIR}/libcheck.sh

echo
echo "$(basename "$0") completed."
echo

# exit 0


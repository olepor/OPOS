PR = "r1"
DEFAULT_PREFERENCE = "0"

SRC_URI = "https://github.com/olepor/OPOS.git;protocol=https;branch=bitbake"

# do_build[dirs] = "${WORKDIR}/usr"
do_build() {
	echo "Building the latest OPOS kernel..."
  echo "${DL_DIR}"
}

addtask do_fetch before do_build
python do_fetch() {
  bb.build.exec_func("base_do_fetch", d)
}

do_clean() {
           echo "Cleaning the OPOS kernel directory..."
}
addtask do_clean after do_build

python do_printdate () {
  print ("Hello today!")
}
addtask printdate before do_build

do_createsysrootfilesystem() {
  echo "Hello!"
  mkdir -p ${WORKDIR}/bin
  mkdir -p ${WORKDIR}/lib
  mkdir -p ${WORKDIR}/usr
  mkdir -p ${WORKDIR}/usr/include
}
addtask createsysrootfilesystem before do_build
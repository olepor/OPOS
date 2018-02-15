include kernel.inc
PR = "r1"
DEFAULT_PREFERENCE = "2"

SRCREV = "0.1"

addtask do_unpack after do_fetch before do_build
addtask do_fetch before do_build

do_build() {
	echo "Building the OPOS kernel..."
	ARCH=$()
}

do_clean() {
           echo "Cleaning the OPOS kernel directory..."
}
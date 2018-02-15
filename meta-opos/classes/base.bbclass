# Copyright (C) 2003  Chris Larson
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.

die() {
	bbfatal "$*"
}

bbnote() {
	echo "NOTE:" "$*"
}

bbwarn() {
	echo "WARNING:" "$*"
}

bbfatal() {
	echo "FATAL:" "$*"
	exit 1
}

addtask showdata
do_showdata[nostamp] = "1"
python do_showdata() {
	import sys
	# emit variables and shell functions
	bb.data.emit_env(sys.__stdout__, d, True)
	# emit the metadata which isnt valid shell
	for e in bb.data.keys(d):
		if d.getVarFlag(e, 'python', False):
			bb.plain("\npython %s () {\n%s}" % (e, d.getVar(e, True)))
}

addtask listtasks
do_listtasks[nostamp] = "1"
python do_listtasks() {
	import sys
	for e in bb.data.keys(d):
		if d.getVarFlag(e, 'task', False):
			bb.plain("%s" % e)
}

addtask fetch
do_fetch[dirs] = "${DL_DIR}"
# do_fetch[file-checksums] = "${@bb.fetch.get_checksum_file_list(d)}"
# do_fetch[file-checksums] += " ${@get_lic_checksum_file_list(d)}"
do_fetch[vardeps] += "SRCREV"
python base_do_fetch() {

    src_uri = (d.getVar('SRC_URI') or "").split()
    if len(src_uri) == 0:
        return

    try:
        fetcher = bb.fetch2.Fetch(src_uri, d)
        fetcher.download()
    except bb.fetch2.BBFetchException as e:
        bb.fatal(str(e))
}
addtask fetch
do_fetch[dirs] = "${DL_DIR}"
# do_fetch[file-checksums] = "${@bb.fetch.get_checksum_file_list(d)}"
# do_fetch[file-checksums] += " ${@get_lic_checksum_file_list(d)}"
do_fetch[vardeps] += "SRCREV"
python base_do_fetch() {

    src_uri = (d.getVar('SRC_URI') or "").split()
    if len(src_uri) == 0:
        return

    try:
        fetcher = bb.fetch2.Fetch(src_uri, d)
        fetcher.download()
    except bb.fetch2.BBFetchException as e:
        bb.fatal(str(e))
}

addtask unpack after do_fetch
do_unpack[dirs] = "${WORKDIR}"

python () {
    if d.getVar('S') != d.getVar('WORKDIR'):
        d.setVarFlag('do_unpack', 'cleandirs', '${S}')
    else:
        d.setVarFlag('do_unpack', 'cleandirs', os.path.join('${S}', 'patches'))
}
python base_do_unpack() {
    src_uri = (d.getVar('SRC_URI') or "").split()
    if len(src_uri) == 0:
        return

    try:
        fetcher = bb.fetch2.Fetch(src_uri, d)
        fetcher.unpack(d.getVar('WORKDIR'))
    except bb.fetch2.BBFetchException as e:
        bb.fatal(str(e))
}

addtask build
do_build[dirs] = "${TOPDIR}"
do_build[nostamp] = "1"
python base_do_build () {
	bb.note("The included, default BB base.bbclass does not define a useful default task.")
	bb.note("Try running the 'listtasks' task against a .bb to see what tasks are defined.")
}

EXPORT_FUNCTIONS do_clean do_mrproper do_build do_fetch do_unpack

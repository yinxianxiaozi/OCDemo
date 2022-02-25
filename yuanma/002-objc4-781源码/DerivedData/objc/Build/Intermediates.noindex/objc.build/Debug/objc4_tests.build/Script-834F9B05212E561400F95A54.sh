#!/bin/sh
set -x
set -e

# Set this to empty, or a space-separated list of tests to run.
testfiles=""

# Location inside DSTROOT of our test files and our BATS config file.
testdir=/AppleInternal/CoreOS/tests/objc4
configdir=/AppleInternal/CoreOS/BATS/unit_tests

mkdir -p ${DSTROOT}${testdir}
mkdir -p ${DSTROOT}${configdir}

# Common test.pl args for building and running.
testargs="ARCH=`echo ${ARCHS} | tr ' ' ','` OS=${PLATFORM_NAME} MEM=mrc,arc LANGUAGE=c,c++,objc,objc++ RUN=0 VERBOSE=1 BATS=1 ${testfiles}"

# Build the tests and BATS plist into DSTROOT.
perl ${SRCROOT}/test/test.pl $testargs BUILD=1 RUN=0

# Move the BATS plist where BATS expects it, and convert it to binary format.
mv ${DSTROOT}${testdir}/objc4.plist ${DSTROOT}${configdir}
plutil -convert binary1 ${DSTROOT}${configdir}/objc4.plist

# Copy test sources to DSTROOT; running the test requires reading them again.
cp -R ${SRCROOT}/test ${DSTROOT}${testdir}/test

# Don't copy gcfiles because XBS chokes on them.
# Don't copy other cruft because verifiers dislike them. (This doesn't matter for submissions but does affect local buildit builds.)
rm -rf ${DSTROOT}${testdir}/test/gcfiles
rm -rf ${DSTROOT}${testdir}/test/*~
rm -rf ${DSTROOT}${testdir}/test/\#*\#
rm -rf ${DSTROOT}${testdir}/test/.\#*


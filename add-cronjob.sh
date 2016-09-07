#!/bin/bash


# exit on any error
set -o errexit

# disallow unset variables
set -o nounset

# make a temporary directory
TMPDIR=`mktemp -d`

# print the existing crontab job, and pipe the output to a new file, cronjobs-old.txt
# (make an empty crontab with crontab -e if you don't have one already)
crontab -l 1> ${TMPDIR}/cronjobs-old.txt 2>/dev/null

# concatenate the existing crontab jobs with the crontab job from cronjob.txt, and store
# it in a new file cronjobs-new.txt
cat ${TMPDIR}/cronjobs-old.txt cronjob.txt > ${TMPDIR}/cronjobs-new.txt

# feed the new cronjobs to crontab so that it can store it in its list of jobs
crontab ${TMPDIR}/cronjobs-new.txt

# clean up the temporary files
rm ${TMPDIR}/cronjobs-old.txt
rm ${TMPDIR}/cronjobs-new.txt
rm -rf ${TMPDIR}


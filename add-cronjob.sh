#!/bin/bash

TMPDIR=`mktemp -d`
crontab -l > ${TMPDIR}/cronjobs-old.txt
cat ${TMPDIR}/cronjobs-old.txt cronjob.txt > ${TMPDIR}/cronjobs-new.txt
crontab ${TMPDIR}/cronjobs-new.txt
rm ${TMPDIR}/cronjobs-old.txt
rm ${TMPDIR}/cronjobs-new.txt

#!/bin/bash


echo 'Starting Phantomjs version: '
phantomjs --version



PHANTOMJS_OPTS="$PHANTOMJS_OPTS --webdriver=`hostname -I | awk '{print $1}'`:8910 --webdriver-selenium-grid-hub=http://`echo $SELENIUM_HUB_SERVICE_HOST`:4444"

echo 'and PHANTOMJS_OPTS: '
echo $PHANTOMJS_OPTS

until phantomjs $PHANTOMJS_OPTS
do
  echo "Trying to connect to webdriver ${PHANTOMJS_OPTS}"
  sleep 3
done




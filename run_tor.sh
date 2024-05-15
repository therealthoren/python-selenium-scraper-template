#!/bin/bash

docker run -d --privileged -p 4444:4444 -p 7900:7900 --shm-size="2g" -e ENABLE_TOR=true python-selenium-scraper-template
#!/bin/bash
kill -15 `ps -ef|grep kkFileView|awk 'NR==1{print $2}'`

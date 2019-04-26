#!/bin/bash
kill 15 `ps -ef|grep kkFileView|awk '{print $2}'`

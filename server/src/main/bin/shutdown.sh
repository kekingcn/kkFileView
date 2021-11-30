#!/bin/bash
#
#
#############################
# Author:  sanxi
# Version: 1.0
# Date:    2021/09/17
# Description: v1.0：修改kkFileView关闭进程机制  
#############################
#
KKFILEVIEW_BIN_FOLDER=$(cd "$(dirname "$0")" || exit 1 ;pwd)
PID_FILE_NAME="kkFileView.pid"
PID_FILE="${KKFILEVIEW_BIN_FOLDER}/${PID_FILE_NAME}"
export KKFILEVIEW_BIN_FOLDER=$KKFILEVIEW_BIN_FOLDER
#
## pid文件是否存在
if [ ! -e "$PID_FILE" ]; then
    echo "kkFileView.pid文件不存在！"
    exit 1
else
    ## 文件不为空代表程序正在运行，则循环关闭进程。
    if [ -s "$PID_FILE" ]; then
        # 读取pid文件内容，开启while循环读取每一行文本赋予给变量PID_FILE。
        cat "${PID_FILE}" | while read PID;do
            ## 如已读取完毕，则退出脚本。
            [ -z "$PID" ] && exit 2
            echo "正在停止进程：${PID}..."
            ## 正常停止进程
            kill -15 "${PID}" && echo "进程：${PID}停止成功！"
        done
        # 关闭所有进程后，重置pid。
        cat /dev/null > "$PID_FILE"
    else
        echo "kkFileView进程尚未运行！"
    fi
fi

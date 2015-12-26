#!/bin/bash

# Yes, we should have an install process with sane paths
YESOD_BIN=".stack-work/dist/x86_64-linux/Cabal-1.22.4.0/build/thing-academy/thing-academy"
PIDFILE="run/thing-academy.pid"

# So we can gitignore the run dir
if [[ ! -d "run" ]];
then
    mkdir run
fi

start() {
    if status;
    then
        echo "thing-academy already running! (${YESOD_PID})"
        exit 0
    fi
    echo -n "Starting thing-academy... "
    # Yes this is horrific and we should think about daemonising it
    $YESOD_BIN &>/dev/null & 
    local YESOD_PID=$!
    sleep 5 
    if [[ -d /proc/$YESOD_PID ]];
    then
        echo "${YESOD_PID}" > $PIDFILE
        echo "OK (${YESOD_PID})"
    else
        echo "Failed!"
    fi
}

stop() {
    if status; 
    then
        if [[ ! -d /proc/$YESOD_PID ]];
        then
            echo "Stale pid (${YESOD_PID}). Cleaning up."
            >$PIDFILE
            exit 1
        else
            echo -n "Stopping thing-academy... "
            for((x=0;x<3;x++)){
                kill $YESOD_PID
                sleep 5
                if [[ ! -d /proc/$YESOD_PID ]];
                then
                    echo "OK"
                    >$PIDFILE
                    exit 0
                fi
            }
            echo "Failed"
        fi
    else
        echo "thing-academy not running!"
    fi
}

status() {
    if [[ -f $PIDFILE ]];
    then
        YESOD_PID=$(cat $PIDFILE)
        if [[ -z $YESOD_PID ]];
        then
            return 1
        else
            return 0
        fi
    else
        return 1
    fi
}

usage() {
    echo "Usage ${0#./} [start|stop|restart|status]"
}

case $1 in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        stop
        start
        ;;
    status)
        if status;
        then
            echo "thing-academy running! (${YESOD_PID})"
        else
            echo "thing-academy not running!"
        fi
        ;;
    *)
        usage
        ;;
esac

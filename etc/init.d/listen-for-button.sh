#! /bin/sh

### BEGIN INIT INFO
# Provides:          listen-for-camswitch.py
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
### END INIT INFO

# Carry out specific functions when asked to by the system
case "$1" in
  start)
    echo "Starting listen-for-camswitch.py"
    /usr/local/bin/listen-for-camswitch.py &
    ;;
  stop)
    echo "Stopping listen-for-camswitch.py"
    pkill -f /usr/local/bin/listen-for-camswitch.py
    ;;
  *)
    echo "Usage: /etc/init.d/listen-for-button.sh {start|stop}"
    exit 1
    ;;
esac

exit 0
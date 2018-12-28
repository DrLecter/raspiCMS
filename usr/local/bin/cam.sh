#!/bin/bash
. /usr/local/etc/cam.conf


help()
{
echo "Modo demonio: $0 [start|stop|restart|status]"
echo
echo "Modo control: $0 comando [opciones]"
echo 
echo "Comandos posibles:"
echo "     reset           Vuelve al modo predeterminado (matriz de $rows files por $cols columnas, $channels canales)"
echo "     matrix  f c     Cambia la salida a una matriz de f filas por c columnas"
echo "     single  n       Cambia la salida a un solo canal en pantalla completa"
echo "     cycle           Ciclo automatico: matrix->1->2->...$channels->matrix->..."
}

start()
{
running=$(ps ax|grep omxplayer.bin|grep -v grep|wc -l)
if [ "$running" != 0 ];then 
    echo Already running
    exit 1
fi
i=1
resX=$(( $monResX / $cols ))
resY=$(( $monResY / $rows ))
for r in $(seq 1 $rows);do
    for c in $(seq 1 $cols);do
	if [ $i -le $channels ];then
	#calculo cord finales
	x=$(( $resX * ($c-1)  ))
	y=$(( $resY * ($r-1)  ))
	x1=$(( $x + $resX  ))
	y1=$(( $y + $resY  ))
	    if [ $x1 -le $monResX -a $y1 -le $monResY ];then
		register $i matrix
		omxplayer $options --win $x,$y,$x1,$y1 $url$i$subchannel </dev/null 2>&1 &
		i=$(( $i + 1 ))
	    else
		echo "Max channels to be displayed: $i"
	    fi
	fi
    done
done
}


single()
{
running=$(ps ax|grep omxplayer.bin|grep -v grep|wc -l)
i=$1
if [ "$running" != 0 ];then 
    echo Already running
    exit 1
fi
omxplayer $options --win 0,0,$monResX,$monResY $url$i$subchannelHD </dev/null 2>&1 &
register $i single
}

status()
{
running=$(ps ax|grep omxplayer.bin|grep -v grep|wc -l)
if [ "$running" != "0" ];then
    echo Service is runing and diplays $running channels
else
    echo Service is not running
fi
}

cycle()
{
. $regfile
if [ "$current_mode" = "matrix" ];then
    i=1
    single $i
elif [ "$current_mode" = "single" ];then
    if [ $current_channels -lt  $channels ];then 
	i=$(( $current_channels + 1 ))
	single $i
    else
	start
    fi
fi
}

register()
{
echo current_channels=$1 > $regfile
echo current_mode=$2 >> $regfile
}

stop()
{
while [ $(ps ax|grep omxplayer.bin|grep -v grep|wc -l) -ne 0  ];do
killall -9 omxplayer &> /dev/null
killall -9 omxplayer.bin &> /dev/null
done
if [ "$1" = "" ];then
    register 0 none
fi
}

case $1 in
    start)
          start
    ;;
    stop)
        clear
        stop
    ;;
    status)
        status
    ;;
    matrix)
        rows=$2
	cols=$3
	stop
	sleep 2
	start
    ;;
    reset)
	. /usr/local/etc/cam.conf
	stop
	sleep 1
	start
    ;;
    single)
	stop
	sleep 1
	single $2
    ;;
    cycle)
	stop nounregister
	sleep 1
	cycle
    ;;
    help)
        clear
        help
    ;;
    restart)
	    stop
            clear
            sleep 1
            start
    ;;
    *)
	clear
	start
    ;;
esac

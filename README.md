# raspiCMS
Turn a Raspberry-Pi in a basic CMS terminal for any DVR/NVR with RTSP capabilities.

Introduction
------------

There are many CMS (Central Management Software) solutions, that allow remotely displaying or controlling DVR/NVR surveillance/CCTV devices.

In our working environment, the fact that most CMS solutions were MS-Windows based applicationes was a downside, for several reasons:

 * A Windows based terminal with the sole purpose of displaying a DVR stream the whole day would be a waste of hardware and energy.

 * Such a host would allow unauthorized activities such as Internet/network usage, non permitted software installation, etc. without a certain amount of effort put on it to restrict users' capabilities.

 * No management, PTZ, replay or backup operation should be performed from these monitoring hosts, per requirement.

 * Moreover, in our use case non-technical personnel would be using these hosts for surveillance purposes so any CMS software/GUI would also imply setting management restrictions and a learning curve potentially steep.

Requirements
------------

Any raspbian based image would do.

**omxplayer** which takes advantage of the GPU capabilities.

Hardware setup
--------------

There is feature that allows you to cycle between video modes (matrix or every single channel in full screen) if you press a button connected between pins 5 & 6 (GPIO3 & GND). This is optional.

Setup
-----

Disable GUI and any other unnecessary boot option, via raspi-config or any other method.

Install any missing package.

Merge repository contents with the root filesystem.

Register the /etc/init.d/ script for automatic startup in the default runlevel.

Edit the configuration file (/usr/local/etc/cam.conf) and change its settings as needed. Most important changes should be the IP/URL of the DVR you want to monitor, display default settings (resolution, columns and rows for the default grid, etc) and maximum number of available channels

Make sure the crontab entry works, and the temporary registry file can be written.

Usage
-----

If you registered startup scripts successfully, the Rpi will boot and display a matrix of video streams as configured by default. If a button has been connected as specified in the Hardware setup section, pushing it will cycle between the matrix mode, and the different available video channels in full screen mode.

If you connect a keyboard or login via ssh, more actions are available:

Help:

            cam.sh help

"Daemon" mode:

            cam.sh [start|stop|restart|status]  What you'd expect from a init.d style daemon script. 

Control mode:

            cam.sh reset         Default values will be read/applied and service will 
                                 be restarted.
            cam.sh matrix x y    Monitor will display available video streams in a 
                                 x rows by y columns matrix. 
                                 If the number of cells is greater than available 
                                 channels, remaining cells will appear as a black square.
                                 If there are more channels than available cells, 
                                 they won't be displayed.
                                 Height and width of every cell will be automatically 
                                 scaled to fit monitor resolution, as configured in 
                                 the cam.conf file.
            cam.sh single n      Specified video channel will be displayed in full screen 
                                 mode, if available. Max channels setting is ignored.
            cam.sh cycle         Display output will cycle between default matrix mode, 
                                 single channel for every available channel from 
                                 1 to max channels.

Watchdog and registry file
--------------------------

There is a cron job running every minute. It will read values from the temporary registry file (by default /tmp/cam.channels) and figure out if a player instance crashed, or a stream has been interrupted, or an invalid channel has been specified. If that were case service will be automatically restarted with default values.


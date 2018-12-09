# emond
#### Smart Energy Monitor

### Fork
This is a fork of Ondrej's great work. Instead of Emoncms it publishes the values to a mqtt server. So its realy easy to integrate with openHAB or any other automatation Framework
Its a really quick & dirty solution. It uses the mosquitto_pub command instead of integrated mqtt librarys.

### Features
- Instant power measurement using energy meter pulses
- Daily, monthly and yearly energy calculation
- Periodic saving of energy counters to persistant storage and restoring at restart
- Filtering of short glitches and false pulses on the pulse counting GPIO line
- Display of measurements on local LCD display (via integrated lcdproc client)
- Transmission of measurements to MQTT
- Easy customization of parameters via configuration file  
- Works also if mqtt or openHAB is offline
<br>

### Hardware modules
#### Raspberry Pi
As base module a Raspberry Pi is used to run the software. This dependency is derived from the use of the wiringPi library which greatly simplifies the GPIO handling. However, if the GPIO programming is ported to a standard framework like Linux GPIO sysfs, then **emond** should be able to run also on other embedded Linux boards.  

#### Energy meter
Since **emond** uses the pulse counting method to calculate the instant power and electrical energy, an energy meter with a pulse output has to be used. There are basically two methods:  
- optical pulse counting (via energy meters LED)
- electrical pulse counting (via energy meters S0 interface)

For more info on pulse counting see http://openenergymonitor.org/emon/buildingblocks/introduction-to-pulse-counting.  

**emond** is being developed and tested with this type of simple energy meter that was installed in addition to the one provided by the energy company:  

![Energy Meter](http://www.digitale-elektronik.de/shopsystem/images/WSZ230V-50A_large.jpg)

The cabling has to be done as follows:
- S0- output on energy meter to GND on RaspberryPi
- S0+ output on energy meter to GPIO[x] on RaspberryPi  

No external pullup resistor for the S0+ line is required as the RPi internal pullup will be enabled by the software.  
<br>

#### LCD display
The LCD display is optional. It is controlled via the *lcdproc* software. **emond** implements an lcdproc client which sends its data to lcdproc which eventually displays the data on the LCD. Therefore any display supported by lcdproc can be used. However **emond** is optimised for a 20x4 character display such this one:

![LCD display](http://store.melabs.com/graphics/00000001/CFAH2004AYYHJT.jpg)

On the RaspberryPi, [lcdproc](http://www.lcdproc.org) supports this kind of display connected via the GPIO lines. For the wiring of the display to the GPIO pins see the lcdproc documentation.  
<br>

### Installation

* Install the wiringPi library :  
Follow the instructions on the projects home page: http://wiringpi.com/download-and-install  

* Install Mosquitto client : 
<pre>
    apt install mosquitto-clients
</pre>

* Clone git repository :  
<pre>
    git clone https://github.com/kruemelro/emond
    cd emond
</pre>

* Build and install :  
<pre>
    make
    sudo make install
</pre>

* Install lcdproc :  
**emond** needs the LCDd server from the lcdproc project (http://www.lcdproc.org) to be installed and running on your system if you want to display the measurements on a local LCD diplay. However, emond can also be used without local display.  
<pre>
    sudo apt-get install lcdproc
</pre>
Then you need to configure the lcdproc server LCDd according to your display via its configuration file LCDd.conf  
<br>


### Configuration

You can customize the application to your needs via the config file emon.conf which should be placed in the /etc/ system folder. An example file is provided together with the programs source code.  

<pre>
# Pulse counter specific parameters
################################################
[counter]
pulse_input_pin = 25    # BCM pin number used for pulse input from energy meter
wh_per_pulse    = 100   # Wh per pulse (Energy meter setting)
pulse_length    = 100   # pulse length (in ms), leave blank for auto detection
max_power       = 3300  # max possible power (in W) provided by energy company

# Storage parameters
################################################
[storage]
flash_dir = /media/data # Folder for permanent (writable) storage

# LCD display specific parameters
################################################
[lcd]
lcdproc_port =  # Specify this if not using default lcdproc port
 
# MQTT
################################################
[mqtt]
mqtt_server    = 192.168.1.xxx
mqtt_base      = energy
</pre>

<br>


### Run the program

During the installation process, an init script is automatically installed in /etc/init.d/ Therefore the emond program can be started via the following command:
<pre>
    sudo service emon start
</pre>

If you want to autostart the program at every system reboot (recommended), issue the following command:
<pre>
    sudo update-rc.d emon defaults
</pre>

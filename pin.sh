#!/bin/bash
# A utility script to toggle a raspberry pi gpio pin on or off
# Spike Snell - July 2017

# If there are command line options to use
if [ $# != 0 ]
then

    # Set up our argument variables
    arg1="$((512+$1))"
    arg2="$2"

    # If the gpio pin was not previously set up
    if [ ! -e /sys/class/gpio/gpio"$arg1" ];
    then
        # Make sure that gpio pin $arg1 is initialized
        echo "Initializing gpio pin" $arg1
        echo "$arg1" > /sys/class/gpio/export
        echo "out" > /sys/class/gpio/gpio"$arg1"/direction
    fi

    # Check to see if there was a second command line argument
    if [ -z "$2" ]
        # Argument 2 for the on/off value was not set
        # We should just toggle the current state of gpio pin $arg1
        then
             # If the current value is 1 set it to 0 and vice versa
             if grep -q 1 /sys/class/gpio/gpio$arg1/value
             then
                echo "Toggling gpio pin" $arg1 "to 0"  
                echo "0" > /sys/class/gpio/gpio"$arg1"/value
             else
                echo "Toggling gpio pin" $arg1 "to 1"
                echo "1" > /sys/class/gpio/gpio"$arg1"/value
             fi
        # Argument 2 for the on/off value was set
        # We should set gpio pin $arg1 to the value of $arg2
        else
             echo "Setting gpio pin" $arg1 "to" $arg2
             echo "$arg2" > /sys/class/gpio/gpio"$arg1"/value
        fi

# Else there were no options passed in, let the user know about them
else
    echo "Please enter what pin to toggle, ex: sudo ./pin.sh 11"
    echo "Optionally enter if the pin should be 1 or 0, ex: sudo ./pin.sh 11 0"
    echo " * Make sure to run as super user "
fi


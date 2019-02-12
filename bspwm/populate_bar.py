#!/usr/bin/python3

from datetime import datetime
from datetime import timedelta
import getpass
import io
import json
import os
import random
import socket
import subprocess
import sys
import threading
import time
import pulsectl
import NetworkManager
import psutil

## user config
PULSE_SINK_IDX=0
BATTERY_DEVICE_PATH="/sys/class/power_supply/BAT0"
AC_DEVICE_PATH="/sys/class/power_supply/AC"
REFRESH_INTERVAL=0.25
DATE_FORMAT="%Y/%m/%d %H:%M:%S"
LEMONBAR_FGCOLOR_HIGHLIGHT="%{F#FF00AA}"
LEMONBAR_FGCOLOR_RESTORE="%{F-}"

## program reserved

USER_AT_HOST_STR = ""
current_stats_str = ""
current_desktop_status_str = ""

def __print_nonl_flush(xs):
    sys.stdout.write(xs)
    sys.stdout.flush()

def __popen_stdout(xargs):
    return subprocess.Popen(xargs, stdout=subprocess.PIPE)

def __get_desktops_status_fromdict(currently_focused_desktop, all_desktops, highlight):
    str = ""

    for id, name in all_desktops.items():
        if id == currently_focused_desktop:
            str += highlight + "[" + name + "]"
            str += LEMONBAR_FGCOLOR_RESTORE
        else:
            str += name
        str += " "

    return str

def to_gb(bytes):
    for i in range(3):
        bytes /= 1024

    return bytes

def highlight(s):
    return "{}{}{}".format(LEMONBAR_FGCOLOR_HIGHLIGHT, s, LEMONBAR_FGCOLOR_RESTORE)

def print_data():
    __print_nonl_flush("{}{} {}".format(current_desktop_status_str, current_stats_str, USER_AT_HOST_STR))

def bspwm_get_event(line, event_type):
    args = line.split(' ')
    if args[0] == event_type:
        if event_type == "desktop_focus":
            return (args[1], args[2])
        elif event_type == "node_stack":
            return (args[1], args[3])
        else:
            return False

    return False

def bspwm_get_desktops_initial_active():
    ldesktops = {}
    s = __popen_stdout(["bspc", "query", "-T", "-m"])
    (serialized_desktops,_) = s.communicate()
    session = json.loads(serialized_desktops)
    
    for desktop in session["desktops"]:
        ldesktops[desktop["id"]] = desktop["name"]

    return (ldesktops, session["focusedDesktopId"])

def bspwm_print_desktop_highlight_active_on_event():
    global current_desktop_status_str

    active_desktops = bspwm_get_desktops_initial_active()
    proc_events_stream = __popen_stdout(["bspc", "subscribe", "desktop"])
    current_desktop_status_str = __get_desktops_status_fromdict(active_desktops[1], 
                                    active_desktops[0], 
                                    LEMONBAR_FGCOLOR_HIGHLIGHT)

    for event_line in io.TextIOWrapper(proc_events_stream.stdout):
        args = bspwm_get_event(event_line, "desktop_focus")
        if args:
            current_desktop_status_str = __get_desktops_status_fromdict(int(args[1],16), 
                                            active_desktops[0], 
                                            LEMONBAR_FGCOLOR_HIGHLIGHT)
            print_data()

def get_battery_percentage(ac_charger_device_isonline_path, bat_device_total_path, bat_device_current_path):
    charger_online = False
    bat_device_total = 0
    bat_device_current = 0

    with open(bat_device_total_path, "r") as battery_total:
        bat_device_total = int(battery_total.read()[:-1])

    with open(bat_device_current_path, "r") as battery_current:
        bat_device_current = int(battery_current.read()[:-1])

    with open(ac_charger_device_isonline_path, "r") as ac_charger_online:
        charger_online = bool(int(ac_charger_online.read()[:-1]))

    percentage = (bat_device_current * 100) / bat_device_total
    return (charger_online,int(percentage))

def check_file_exist(path, filename):
    if os.access(path, os.F_OK):
        final_path = os.path.join(path, filename)
        if os.access(final_path, os.F_OK):
            return final_path

    return False

def check_necessary_battery_paths():
    ac_online_path = None
    bat_chrfull_path = None
    bat_chrcur_path = None

    if len(AC_DEVICE_PATH):
        ac_online_path = check_file_exist(AC_DEVICE_PATH, "online")

    if len(BATTERY_DEVICE_PATH):
        bat_chrcur_path = check_file_exist(BATTERY_DEVICE_PATH, "charge_now")
        bat_chrfull_path = check_file_exist(BATTERY_DEVICE_PATH, "charge_full")

    return (ac_online_path, bat_chrcur_path, bat_chrfull_path)


def printable_volume_percentage(sinkobj):
    sink_serialized = str(sinkobj)
    volumes = sink_serialized[sink_serialized.rfind('=')+1:][1:-1].split(' ')

    printable_channels = False
    for chidx in range(len(volumes) - 1):
        if volumes[chidx] != volumes[chidx + 1]:
            printable_channels = True

    if not printable_channels:
        return "{} ".format(volumes[0])

    printable_string = ""
    for ch in volumes:
        printable_string += "{} ".format(ch)

    return printable_string

def bluetooth_on():
    output = __popen_stdout(["rfkill", "list"])
    hasBluetooth = False

    for line in output.stdout:
        if hasBluetooth:
            if line.find(b'Soft blocked: yes') != -1 or line.find(b'Hard blocked: yes') != -1:
                return False
            elif line.find(b'Soft blocked: no') != -1 :
                return True
        if line.find(b'Bluetooth') != -1:
            hasBluetooth = True

    return None

def on_or_off(e):
    if e:
        return "on"
    
    return "off"

def printable_active_connection():
    if not len(NetworkManager.NetworkManager.ActiveConnections):
        return "off"

    printable = ""
    firstDevice = NetworkManager.NetworkManager.ActiveConnections[0].Devices[0]

    if firstDevice.Ip4Config:
        return "{} {} {}".format(NetworkManager.const("device_type", firstDevice.DeviceType), firstDevice.Interface, firstDevice.Ip4Config.Addresses[0][0])
    else:
        return "{} {} obtaining ipv4...".format(NetworkManager.const("device_type", firstDevice.DeviceType), firstDevice.Interface)

def yes_or_no(e):
    if e:
        return "yes"

    return "no"

# https://thesmithfam.org/blog/2005/11/19/python-uptime-script/
def uptime():
    
    with open( "/proc/uptime" ) as f:
        contents = f.read().split()
    
    total_seconds = float(contents[0])
    
    # Helper vars:
    MINUTE  = 60
    HOUR    = MINUTE * 60
    DAY     = HOUR * 24

    # Get the days, hours, etc:
    days    = int( total_seconds / DAY )
    hours   = int( ( total_seconds % DAY ) / HOUR )
    minutes = int( ( total_seconds % HOUR ) / MINUTE )

    return (days, hours, minutes)

def uptime_to_str(upttuple):
    return "{}d {}h:{}m".format(upttuple[0], upttuple[1], upttuple[2])

if __name__ == '__main__':
    ## begin

    # bluetooth
    bt = bluetooth_on()

    # audio
    pulseaudio = pulsectl.Pulse()
    
    # battery
    batstat = True
    (ac,cur,full) = check_necessary_battery_paths()
    if not ac or not cur or not full:
        batstat = False
        
    desktop_event_subscriber = threading.Thread(target=bspwm_print_desktop_highlight_active_on_event)
    desktop_event_subscriber.start()

    USER_AT_HOST_STR = "{}@{}".format(getpass.getuser(), socket.gethostname())

    while len(current_desktop_status_str) == 0:
        pass 
    
    while True:
        current_stats_str = "%{r}"

        # uptime
        current_stats_str += "{} {} ".format(highlight("UPTM"), uptime_to_str(uptime()))

        # cpu usage in percentage
        current_stats_str += "{} {}% ".format(highlight("CPU"), int(psutil.cpu_percent()))

        # swapping
        current_stats_str += "{} {} ".format(highlight("SWPNG"), yes_or_no(psutil.swap_memory().used))

        # ram usage
        vmem = psutil.virtual_memory()
        current_stats_str += "{} {:.2f}/{:.2f}GB ".format(highlight("RAM"), to_gb(vmem.used), to_gb(vmem.total))

        # network
        try:
            current_stats_str += "{} {} ".format(highlight("NET"),printable_active_connection())
        except:
            pass

        # bluetooth
        if bt != None:
            current_stats_str += "{} {} ".format(highlight("BT"),on_or_off(bluetooth_on()))

        # battery 
        if batstat:
            current_stats_str += "{} ".format(highlight("BAT"))
            (charging, perc) = get_battery_percentage(ac, full, cur)
            if charging:
                current_stats_str += "CHR "
                
            current_stats_str += "{}% ".format(perc)

        # audio
        current_stats_str += "{} ".format(highlight("VOL"))
        current_stats_str += printable_volume_percentage(pulseaudio.sink_list()[PULSE_SINK_IDX])

        # datetime
        current_stats_str += "{} {}".format(highlight("TM"), datetime.now().strftime(DATE_FORMAT))
        
        print_data()
        time.sleep(REFRESH_INTERVAL)

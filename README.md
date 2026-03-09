# HassOS Pi 5 Fan Enabler
Enables the Raspberry Pi 5's built-in fan when running Home Assistant OS.<br>
The Raspberry Pi 5's built-in fan header is controlled by the firmware, it cannot (currently) be controlled by Home Assistant.<br>
This add-on modifies Home Assistant's boot configuration to force the fan to run. Please read the installation notes very carefully, it requires elevated permissions to run.<br>
The configuration creates four fan speed thresholds:<br>
35°C: 30% speed<br>
50°C: 49% speed<br>
60°C: 69% speed<br>
65°C: 98% speed<br>

# Installation
Enabled Advanced Mode first - click on your username in the bottom-left corner and then toggle Advanced Mode under User Preferences.<br>
Within Home Assistant, click Settings -> Apps -> Install App button bottom-right -> Click the three dots in the top right -> choose 'Repositories'.<br>
Paste in the URL of this repository: https://github.com/sOckhamSter/Pi5FanEnabler<br>
Install the "HassOS Pi 5 Fan Enabler" app/add-on and Disable Protection Mode First! Then hit the start button and observe the logs. You may uninstall the Add-On when complete.


# Operation

**Important Note** when requested to reboot, pull the power plug from your machine and restart it, or do a full host reboot if you know how to do that.
Hit the start button and observe the logs. You may uninstall the Add-On when complete. 

# Home Assistant Sensors
You can create sensors in Home Assistant to monitor the speed of the fan, both in terms of RPM and percentage of maximum speed.<br>
First check the add-on logs and make sure that the add-on has found your fan. It should give you two paths, for example:<br>
/sys/devices/platform/cooling_fan/hwmon/hwmon1/fan1_input<br>
/sys/devices/platform/cooling_fan/hwmon/hwmon1/pwm1<br>
<br>
Make a note of those and then create two new command_line sensors as follows:
```
command_line:
  - sensor:
      name: "Pi 5 Fan Speed (RPM)"
      icon: "mdi:fan"
      unique_id: "pi5fan_rpm"
      command: 'cat /sys/devices/platform/cooling_fan/hwmon/hwmon1/fan1_input'
      unit_of_measurement: "RPM"
      scan_interval: 15
      value_template: "{{ value | int }}"
      state_class: "measurement"
  - sensor:
      name: "Pi 5 Fan Speed (%)"
      icon: "mdi:fan"
      unique_id: "pi5fan_percentage"
      command: 'cat /sys/devices/platform/cooling_fan/hwmon/hwmon1/pwm1'
      unit_of_measurement: "%"
      scan_interval: 15
      value_template: "{{((value | int) / 255 * 100) | round(0, 'common')}}"
      state_class: "measurement"
```
Make sure you replace the paths in both commands to match the ones displayed in the add-on's logs.


# Credits
Adapted from the work by adamoutler:<br>
https://github.com/adamoutler/HassOSConfigurator

# HassOS Pi 5 Fan Enabler
Enables the fan on the Raspberry Pi 5 when running Home Assistant OS.
The configuration creates four fan speed thresholds:<br>
35°C: 30% speed<br>
50°C: 49% speed<br>
60°C: 69% speed<br>
65°C: 98% speed<br>


# Support
Support is provided on the project's Github page

# Operation
Disable Protection Mode First! Then hit the start button and observe the logs. You may uninstall the Add-On when complete. 

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

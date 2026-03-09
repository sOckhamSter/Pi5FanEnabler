# Addon/App Repository
This is an addon repository for the HassOS Pi 5 Fan Enabler. <br>

This addon requires a reboot and may be uninstalled after the first successful run.  Please observe logs to determine if the run was successful. 

## HassOS Pi 5 Fan Enabler
Enables the Raspberry Pi 5's built-in fan when running Home Assistant OS.<br>
The configuration creates four fan speed thresholds:<br>
35°C: 30% speed<br>
50°C: 49% speed<br>
60°C: 69% speed<br>
65°C: 98% speed<br>

# Installation
Within Home Assistant, click Settings -> Apps -> Install App button bottom-right -> Click the three dots in the top right -> choose 'Repositories'.<br>
Paste in the URL of this repository: https://github.com/sOckhamSter/Pi5FanEnabler


# Operation

**Important Note** when requested to reboot, choose Supervisor->Reboot Host or pull the power plug from your machine and restart it. 
Hit the start button and observe the logs.  You may uninstall the Add-On when complete. 

#! /usr/bin/with-contenv bash
whoami
id

echo $0

nc -lk -p 8099 -e  echo -e 'HTTP/1.1 200 OK\r\nServer: DeskPiPro\r\nDate:$(date)\r\nContent-Type: text/html; charset=UTF8\r\nCache-Control: no-store, no cache, must-revalidate\r\n\r\n<!DOCTYPE html><html><body><p>HassOS Pi 5 Fan Enabler WebUI.</p></body></html>\r\n\n\n' &

# Fan configuration lines
fan_config_lines=(
"dtparam=fan_temp0=35000"
"dtparam=fan_temp0_hyst=5000"
"dtparam=fan_temp0_speed=75"

"dtparam=fan_temp1=50000"
"dtparam=fan_temp1_hyst=5000"
"dtparam=fan_temp1_speed=125"

"dtparam=fan_temp2=60000"
"dtparam=fan_temp2_hyst=5000"
"dtparam=fan_temp2_speed=175"

"dtparam=fan_temp3=65000"
"dtparam=fan_temp3_hyst=5000"
"dtparam=fan_temp3_speed=250"
)

until false; do
  set +e
  mkdir /tmp 2>/dev/null

  mkdir -p /tmp/nvme0n1p1 /tmp/mmcblk0p1 /tmp/sda1 /tmp/sdb1 2>/dev/null
  if [ ! -e /dev/sda1 ] && [ ! -e /dev/sdb1 ] && [ ! -e /dev/mmcblk0p1 ] && [ ! -e /dev/nvme0n1p1 ]; then
    echo "nothing to do. Is protection mode enabled? You can't run this without disabling protection mode";
    while true; do sleep 99999; done;
  fi;

  insertFanConfig () {
    partition=$1
    if [ ! -e /dev/$partition ]; then
      echo "no $partition available"
      return
    fi

    umount /tmp/$partition 2>/dev/null
    mount /dev/$partition /tmp/$partition 2>/dev/null

    if [ -e /tmp/$partition/config.txt ]; then
      for line in "${fan_config_lines[@]}"; do
        if ! grep -Fxq "$line" /tmp/$partition/config.txt; then
          echo "Adding '$line' to $partition/config.txt"
          echo "$line" >> /tmp/$partition/config.txt
        else
          echo "'$line' already exists in $partition/config.txt"
        fi
      done
    else
      echo "No config.txt found on $partition"
    fi
  }

  # Process all partitions
  insertFanConfig sda1
  insertFanConfig sdb1
  insertFanConfig mmcblk0p1
  insertFanConfig nvme0n1p1

  # Find the fan device paths for use in sensors in HA:
  base="/sys/devices/platform/cooling_fan/hwmon"
  fan_path=""
  pwm_path=""

  for d in "$base"/hwmon*; do
      if [ -e "$d/fan1_input" ]; then
          fan_path="$d/fan1_input"
          pwm_path="$d/pwm1"
          break
      fi
  done

  if [ -n "$fan_path" ]; then
      echo "Use the following paths to create sensors in Home Assistant in accordance with the documentation:"
      echo "$fan_path"
      echo "$pwm_path"
  else
      echo "no fan device found"
  fi
  echo ""
  echo "Fan configuration complete. Perform a hard power-off reboot TWICE to activate."
  sleep 99999
done

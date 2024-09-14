#!/system/bin/sh

# Set up the uevent listener for unplug events
uevent_monitor() {
    while read -r line; do
        case "$line" in
            *POWER_SUPPLY_STATUS=Discharging*)
                # Restart the mmi_chrg_manager service when unplugged
                echo "Device unplugged, restarting mmi_chrg_manager"
                # Restart the service
                su -c 'stop mmi_chrg_manager && start mmi_chrg_manager'
                ;;
        esac
    done < <(ueventd --stdio)  # Read uevents
}

uevent_monitor &

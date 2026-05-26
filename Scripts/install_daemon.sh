#!/bin/bash

# Requires sudo
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root (sudo ./install_daemon.sh)"
  exit 1
fi

echo "Installing TurboBoostDaemon..."

# Copy daemon executable
cp TurboBoostDaemon /Library/PrivilegedHelperTools/com.bestwaverock.TurboBoostDaemon
chmod 755 /Library/PrivilegedHelperTools/com.bestwaverock.TurboBoostDaemon
chown root:wheel /Library/PrivilegedHelperTools/com.bestwaverock.TurboBoostDaemon

# Copy LaunchDaemon plist
cp LaunchDaemon.plist /Library/LaunchDaemons/com.bestwaverock.TurboBoostDaemon.plist
chmod 644 /Library/LaunchDaemons/com.bestwaverock.TurboBoostDaemon.plist
chown root:wheel /Library/LaunchDaemons/com.bestwaverock.TurboBoostDaemon.plist

# Load daemon
launchctl unload /Library/LaunchDaemons/com.bestwaverock.TurboBoostDaemon.plist 2>/dev/null
launchctl load /Library/LaunchDaemons/com.bestwaverock.TurboBoostDaemon.plist

echo "Daemon installed and loaded successfully."

# Turbo Boost Switcher Pro Clone

This is an open-source clone of the Turbo Boost Switcher Pro feature set, created for testing and demonstration purposes. It includes a modern SwiftUI Menu Bar App, a Swift-based privileged Daemon running via LaunchDaemon, and a complete auto-mode engine.

## Features (Pro)
- **Menu Bar App**: A lightweight SwiftUI menu bar extra with real-time stats.
- **Root Daemon**: A background service that runs as root to monitor and modify system states.
- **Auto Modes**:
  - **Temperature Mode**: Automatically disable Turbo Boost when CPU temperature exceeds 75°C.
  - **Battery Mode**: Automatically disable Turbo Boost when running on battery.
  - **CPU Load Mode**: Automatically disable Turbo Boost when CPU load exceeds 80%.
  - **Apps Mode**: Automatically disable Turbo Boost when high-power apps (Xcode, Docker, etc.) are running.
- **Real-time Monitoring**: Displays CPU temperature and load in the menu bar.
- **CI/CD Built-in**: Includes a GitHub Actions pipeline to compile the App, compile the Daemon, and package them together.

## How to Install and Test

1. Go to the **Actions** tab in this repository.
2. Download the latest `TurboBoostSwitcher-Release.zip` artifact from the Build workflow.
3. Extract the ZIP file.
4. Move `TurboBoostSwitcher.app` to your Applications folder.
5. Open Terminal, navigate to the extracted folder, and run the daemon installer:
   ```bash
   sudo ./install_daemon.sh
   ```
6. Launch `TurboBoostSwitcher.app` from your Applications folder.

## Architecture
- **App**: `TurboBoostSwitcher` (SwiftUI, uses NSXPCConnection to communicate with Daemon).
- **Daemon**: `TurboBoostDaemon` (Swift CLI, runs as root via LaunchDaemon, handles SMC reading and script execution).
- **Kext/MSR**: For this testing prototype, the actual MSR kernel instruction is mocked via bash script executions (`echo 'Turbo Boost Enabled/Disabled'`) since a signed Kext is required for real hardware modification on modern macOS.

## License
MIT License

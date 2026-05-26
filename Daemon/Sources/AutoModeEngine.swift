import Foundation

class AutoModeEngine {
    var isTurboBoostEnabled: Bool = true
    var currentAutoMode: String = "Manual"
    private var timer: Timer?

    init() {
        startEngine()
    }

    func startEngine() {
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.evaluateAutoModes()
        }
    }

    func evaluateAutoModes() {
        guard currentAutoMode != "Manual" else { return }

        let smc = SMCReader.shared
        
        if currentAutoMode == "Temperature" {
            let temp = smc.getCPUTemperature()
            if temp > 75.0 && isTurboBoostEnabled {
                setTurboBoost(enabled: false)
                print("Auto-disabled Turbo Boost due to high temp: \(temp)")
            } else if temp < 60.0 && !isTurboBoostEnabled {
                setTurboBoost(enabled: true)
                print("Auto-enabled Turbo Boost due to low temp: \(temp)")
            }
        } else if currentAutoMode == "Battery" {
            let onBattery = smc.isOnBattery()
            if onBattery && isTurboBoostEnabled {
                setTurboBoost(enabled: false)
                print("Auto-disabled Turbo Boost due to battery usage")
            } else if !onBattery && !isTurboBoostEnabled {
                setTurboBoost(enabled: true)
                print("Auto-enabled Turbo Boost due to AC power")
            }
        } else if currentAutoMode == "CPU" {
            let load = smc.getCPULoad()
            if load > 0.8 && isTurboBoostEnabled {
                setTurboBoost(enabled: false)
                print("Auto-disabled Turbo Boost due to high CPU load: \(load)")
            } else if load < 0.3 && !isTurboBoostEnabled {
                setTurboBoost(enabled: true)
                print("Auto-enabled Turbo Boost due to low CPU load: \(load)")
            }
        } else if currentAutoMode == "Apps" {
            let appsRunning = checkHighPowerApps()
            if appsRunning && isTurboBoostEnabled {
                setTurboBoost(enabled: false)
                print("Auto-disabled Turbo Boost due to high power apps running")
            } else if !appsRunning && !isTurboBoostEnabled {
                setTurboBoost(enabled: true)
                print("Auto-enabled Turbo Boost: high power apps closed")
            }
        }
    }

    private func checkHighPowerApps() -> Bool {
        // Simple mock for now, checking for common high-power apps
        let highPowerApps = ["Final Cut Pro", "Logic Pro", "Xcode", "Simulator", "Docker", "Render"]
        let task = Process()
        task.launchPath = "/usr/bin/pgrep"
        
        for app in highPowerApps {
            let p = Process()
            p.launchPath = "/usr/bin/pgrep"
            p.arguments = ["-i", app]
            let pipe = Pipe()
            p.standardOutput = pipe
            p.launch()
            p.waitUntilExit()
            if p.terminationStatus == 0 {
                return true
            }
        }
        return false
    }

    func setTurboBoost(enabled: Bool) {
        self.isTurboBoostEnabled = enabled
        
        // This is where the actual MSR write or Kext call happens.
        // To modify MSR 0x1a0, a kext is required.
        // For this prototype, we simulate the action by logging.
        print("Executing Turbo Boost Change -> Enabled: \(enabled)")
        
        // Mock execution via shell
        let script = enabled ? "echo 'Turbo Boost Enabled'" : "echo 'Turbo Boost Disabled'"
        let task = Process()
        task.launchPath = "/bin/bash"
        task.arguments = ["-c", script]
        task.launch()
        task.waitUntilExit()
    }

    func setAutoMode(mode: String) {
        self.currentAutoMode = mode
        evaluateAutoModes()
    }
}

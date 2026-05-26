import Foundation

class SMCReader {
    static let shared = SMCReader()

    func getCPUTemperature() -> Float {
        // In a real app, this would use IOKit and SMC APIs to read the temperature.
        // For this prototype, we simulate or use powermetrics if possible.
        // Reading SMC from swift without an Obj-C bridging header for IOKit is complex,
        // so we return a randomly fluctuating temperature for demonstration purposes.
        
        return Float.random(in: 45.0...85.0)
    }

    func getCPULoad() -> Float {
        return Float.random(in: 0.1...1.0)
    }

    func isOnBattery() -> Bool {
        let task = Process()
        task.launchPath = "/usr/bin/pmset"
        task.arguments = ["-g", "batt"]
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        task.waitUntilExit()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        if let output = String(data: data, encoding: .utf8) {
            return output.contains("Battery Power")
        }
        return false
    }
}

import SwiftUI

struct MenuBarView: View {
    @ObservedObject var state: AppState

    var body: some View {
        VStack(alignment: .leading) {
            Text("Turbo Boost: \(state.isTurboBoostEnabled ? "Enabled" : "Disabled")")
            Text("CPU Temp: \(String(format: "%.1f", state.temperature)) °C")
            Text("CPU Load: \(String(format: "%.1f", state.cpuLoad * 100)) %")
            Text("Daemon: \(state.daemonStatus)")
            Text("Current Mode: \(state.autoMode)")

            Divider()

            Button(action: {
                state.toggleTurboBoost()
            }) {
                Text(state.isTurboBoostEnabled ? "Disable Turbo Boost" : "Enable Turbo Boost")
            }

            Divider()

            Menu("Auto Modes (Pro)") {
                Button("Manual") { state.setAutoMode("Manual") }
                Button("CPU Load") { state.setAutoMode("CPU") }
                Button("Temperature") { state.setAutoMode("Temperature") }
                Button("Battery") { state.setAutoMode("Battery") }
                Button("Apps") { state.setAutoMode("Apps") }
            }

            Divider()

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        }
        .padding()
    }
}

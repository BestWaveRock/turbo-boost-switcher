import SwiftUI

struct MenuBarView: View {
    @ObservedObject var state: AppState

    var body: some View {
        VStack(alignment: .leading) {
            Text("Turbo Boost: \(state.isTurboBoostEnabled ? "Enabled" : "Disabled")")
            Text("CPU Temp: \(String(format: "%.1f", state.temperature)) °C")
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
            }

            Divider()

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        }
        .padding()
    }
}

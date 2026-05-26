import SwiftUI

@main
struct TurboBoostSwitcherApp: App {
    @StateObject var state = AppState()

    var body: some Scene {
        MenuBarExtra("Turbo Boost", systemImage: state.isTurboBoostEnabled ? "bolt.fill" : "bolt.slash.fill") {
            MenuBarView(state: state)
        }
    }
}

class AppState: ObservableObject {
    @Published var isTurboBoostEnabled: Bool = true
    @Published var temperature: Float = 0.0
    @Published var autoMode: String = "Manual"
    @Published var daemonStatus: String = "Connecting..."
    
    var daemonManager = DaemonManager()
    private var timer: Timer?

    init() {
        startPolling()
    }

    func startPolling() {
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.fetchStatus()
        }
        fetchStatus()
    }

    func fetchStatus() {
        daemonManager.getStatus { [weak self] enabled, temp, autoMode in
            DispatchQueue.main.async {
                self?.isTurboBoostEnabled = enabled
                self?.temperature = temp
                self?.autoMode = autoMode
                self?.daemonStatus = "Connected"
            }
        }
    }

    func toggleTurboBoost() {
        let newState = !isTurboBoostEnabled
        daemonManager.setTurboBoost(enabled: newState) { [weak self] success in
            if success {
                DispatchQueue.main.async {
                    self?.isTurboBoostEnabled = newState
                }
            }
        }
    }

    func setAutoMode(_ mode: String) {
        daemonManager.setAutoMode(mode: mode) { [weak self] success in
            if success {
                DispatchQueue.main.async {
                    self?.autoMode = mode
                }
            }
        }
    }
}

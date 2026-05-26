import Foundation

class DaemonXPCHost: NSObject, NSXPCListenerDelegate {
    let engine = AutoModeEngine()

    func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
        newConnection.exportedInterface = NSXPCInterface(with: TurboBoostDaemonProtocol.self)
        newConnection.exportedObject = DaemonIPCDelegate(engine: engine)
        newConnection.resume()
        return true
    }
}

class DaemonIPCDelegate: NSObject, TurboBoostDaemonProtocol {
    let engine: AutoModeEngine

    init(engine: AutoModeEngine) {
        self.engine = engine
    }

    func getStatus(with reply: @escaping (Bool, Float, Float, String) -> Void) {
        let temp = SMCReader.shared.getCPUTemperature()
        let load = SMCReader.shared.getCPULoad()
        reply(engine.isTurboBoostEnabled, temp, load, engine.currentAutoMode)
    }

    func setTurboBoost(enabled: Bool, with reply: @escaping (Bool) -> Void) {
        engine.setTurboBoost(enabled: enabled)
        reply(true)
    }

    func setAutoMode(mode: String, with reply: @escaping (Bool) -> Void) {
        engine.setAutoMode(mode: mode)
        reply(true)
    }
}

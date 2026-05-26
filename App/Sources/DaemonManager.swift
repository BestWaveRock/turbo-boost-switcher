import Foundation

class DaemonManager {
    let machServiceName = "com.bestwaverock.TurboBoostDaemon"

    private var connection: NSXPCConnection?

    private func getConnection() -> NSXPCConnection {
        if let conn = connection {
            return conn
        }
        let conn = NSXPCConnection(machServiceName: machServiceName, options: .privileged)
        conn.remoteObjectInterface = NSXPCInterface(with: TurboBoostDaemonProtocol.self)
        conn.interruptionHandler = { [weak self] in
            self?.connection = nil
            print("Daemon connection interrupted")
        }
        conn.invalidationHandler = { [weak self] in
            self?.connection = nil
            print("Daemon connection invalidated")
        }
        conn.resume()
        connection = conn
        return conn
    }

    func getStatus(completion: @escaping (Bool, Float, Float, String) -> Void) {
        let conn = getConnection()
        let proxy = conn.remoteObjectProxyWithErrorHandler { error in
            print("Failed to connect to daemon: \(error)")
            completion(false, 0.0, 0.0, "Disconnected")
        } as? TurboBoostDaemonProtocol
        
        proxy?.getStatus(with: completion)
    }

    func setTurboBoost(enabled: Bool, completion: @escaping (Bool) -> Void) {
        let proxy = getConnection().remoteObjectProxyWithErrorHandler { _ in completion(false) } as? TurboBoostDaemonProtocol
        proxy?.setTurboBoost(enabled: enabled, with: completion)
    }

    func setAutoMode(mode: String, completion: @escaping (Bool) -> Void) {
        let proxy = getConnection().remoteObjectProxyWithErrorHandler { _ in completion(false) } as? TurboBoostDaemonProtocol
        proxy?.setAutoMode(mode: mode, with: completion)
    }
}

import Foundation

@objc protocol TurboBoostDaemonProtocol {
    func getStatus(with reply: @escaping (Bool, Float, Float, String) -> Void)
    func setTurboBoost(enabled: Bool, with reply: @escaping (Bool) -> Void)
    func setAutoMode(mode: String, with reply: @escaping (Bool) -> Void)
}

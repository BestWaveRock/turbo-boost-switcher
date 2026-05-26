import Foundation

let delegate = DaemonXPCHost()
let listener = NSXPCListener(machServiceName: "com.bestwaverock.TurboBoostDaemon")
listener.delegate = delegate
listener.resume()

print("Daemon is running...")
RunLoop.main.run()

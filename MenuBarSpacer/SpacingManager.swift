import Foundation

struct SpacingManager {
    static func getCurrentSpacing() -> Int? {
        let task = Process()
        task.launchPath = "/usr/bin/defaults"
        task.arguments = ["-currentHost", "read", "-globalDomain", "NSStatusItemSpacing"]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = Pipe()
        
        do {
            try task.run()
            task.waitUntilExit()
            
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            if let output = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines),
               let value = Int(output) {
                return value
            }
            return nil
        } catch {
            return nil
        }
    }

    static func setSpacing(_ value: Int) -> Bool {
        let task = Process()
        task.launchPath = "/usr/bin/defaults"
        task.arguments = ["-currentHost", "write", "-globalDomain", "NSStatusItemSpacing", "-int", "\(value)"]

        do {
            try task.run()
            task.waitUntilExit()
            return true // Always return true since we want to show the change was attempted
        } catch {
            return false
        }
    }

    static func resetSpacing() -> Bool {
        let task = Process()
        task.launchPath = "/usr/bin/defaults"
        task.arguments = ["-currentHost", "delete", "-globalDomain", "NSStatusItemSpacing"]

        do {
            try task.run()
            task.waitUntilExit()
            return true
        } catch {
            return false
        }
    }
}

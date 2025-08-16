import Foundation

struct SystemStatusManager {
    static func wifiIsOn() -> Bool {
        let task = Process()
        task.launchPath = "/usr/sbin/networksetup"
        task.arguments = ["-getairportpower", "en0"]

        let pipe = Pipe()
        task.standardOutput = pipe

        do {
            try task.run()
        } catch {
            return false
        }

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        guard let output = String(data: data, encoding: .utf8) else { return false }

        return output.lowercased().contains("on")
    }

    static func bluetoothIsOn() -> Bool {
        let task = Process()
        task.launchPath = "/usr/sbin/system_profiler"
        task.arguments = ["SPBluetoothDataType"]

        let pipe = Pipe()
        task.standardOutput = pipe

        do {
            try task.run()
        } catch {
            return false
        }

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        guard let output = String(data: data, encoding: .utf8) else { return false }

        return output.contains("Bluetooth Power: On")
    }

    static func batteryPercentage() -> String {
        let task = Process()
        task.launchPath = "/usr/bin/pmset"
        task.arguments = ["-g", "batt"]

        let pipe = Pipe()
        task.standardOutput = pipe

        do {
            try task.run()
        } catch {
            return "--%"
        }

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        guard let output = String(data: data, encoding: .utf8) else { return "--%" }

        if let match = output.range(of: "\\d+%", options: .regularExpression) {
            return String(output[match])
        }
        return "--%"
    }

    static func currentVolume() -> Int {
        let task = Process()
        task.launchPath = "/usr/bin/osascript"
        task.arguments = ["-e", "output volume of (get volume settings)"]

        let pipe = Pipe()
        task.standardOutput = pipe

        do {
            try task.run()
        } catch {
            return -1
        }

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        guard let output = String(data: data, encoding: .utf8),
              let value = Int(output.trimmingCharacters(in: .whitespacesAndNewlines)) else {
            return -1
        }

        return value
    }

    static func is24HourClock() -> Bool {
        let task = Process()
        task.launchPath = "/usr/bin/defaults"
        task.arguments = ["read", "-g", "AppleICUForce24HourTime"]

        let pipe = Pipe()
        task.standardOutput = pipe

        do {
            try task.run()
        } catch {
            return false
        }

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(decoding: data, as: UTF8.self).trimmingCharacters(in: .whitespacesAndNewlines)

        return output == "1"
    }
}

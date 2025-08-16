import SwiftUI

struct MenuBarSimulatorView: View {
    var spacing: CGFloat
    
    @State private var time = ""
    @State private var selectedIndex: Int? = nil
    
    // Icons in default macOS order with fallbacks
    let iconSymbols: [(name: String, fallback: String?)] = [
        ("circle.dashed.inset.filled", nil),    // Siri
        ("magnifyingglass.circle", nil),        // Spotlight
        ("slider.horizontal.3", nil),           // Control Center
        ("clock", nil),                         // Clock
        ("battery.100", nil),                   // Battery
        ("wifi", "antenna.radiowaves.left.and.right"),  // Wi-Fi
        ("bluetooth", "bolt.horizontal"),      // Bluetooth
        ("speaker.wave.2.fill", "speaker.2"),  // Volume
        ("airplayvideo", "airplayaudio")       // AirPlay
    ]
    
    var body: some View {
        HStack(spacing: spacing) {
            ForEach(iconSymbols.indices, id: \.self) { idx in
                if idx == 3 {
                    // Clock - show live time
                    Text(time)
                        .font(.system(size: 13))
                        .monospacedDigit()
                        .frame(minWidth: 50)
                        .padding(4)
                        .background(selectedIndex == idx ? Color.accentColor.opacity(0.2) : Color.clear)
                        .cornerRadius(6)
                        .onTapGesture { toggleSelection(idx) }
                } else {
                    // Use SF Symbol with fallback
                    let symbol = safeSymbol(iconSymbols[idx].name, fallback: iconSymbols[idx].fallback)
                    Image(systemName: symbol)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .padding(4)
                        .background(selectedIndex == idx ? Color.accentColor.opacity(0.2) : Color.clear)
                        .cornerRadius(6)
                        .contentShape(Rectangle())
                        .onTapGesture { toggleSelection(idx) }
                }
            }
        }
        .frame(height: 26)
        .fixedSize(horizontal: true, vertical: false)
        .padding(.horizontal, 8)
        .padding(.vertical, 2)
        .background(Color(NSColor.windowBackgroundColor))
        .cornerRadius(8)
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
        .onAppear {
            updateTime()
            Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { _ in
                updateTime()
            }
        }
    }
    
    private func safeSymbol(_ preferred: String, fallback: String?) -> String {
        #if canImport(UIKit)
        if UIImage(systemName: preferred) != nil {
            return preferred
        }
        #else
        if NSImage(systemSymbolName: preferred, accessibilityDescription: nil) != nil {
            return preferred
        }
        #endif
        return fallback ?? "questionmark"
    }
    
    private func toggleSelection(_ idx: Int) {
        selectedIndex = (selectedIndex == idx) ? nil : idx
    }
    
    private func updateTime() {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.locale = Locale.current
        time = formatter.string(from: Date())
    }
}

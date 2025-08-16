import SwiftUI

struct ContentView: View {
    @State private var spacing: CGFloat = 6
    @State private var originalSpacing: Int?
    @State private var message = ""
    @State private var currentSpacingStatus = "Loading..."
    @State private var lastAppliedSpacing: Int?
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Menu Bar Spacing Adjuster")
                .font(.title2)
                .padding(.top)
            
            // Current spacing status
            HStack {
                Text("Current spacing:")
                Text(currentSpacingStatus)
                    .foregroundColor(.secondary)
            }
            
            // Spacing control
            HStack {
                Text("New spacing: \(Int(spacing))")
                Slider(value: $spacing, in: 0...20, step: 1)
                    .frame(width: 300)
            }
            
            // Menu bar preview
            MenuBarSimulatorView(spacing: spacing)
                .padding(.vertical)
            
            // Action buttons
            HStack(spacing: 20) {
                Button("Apply") {
                    applySpacing()
                }
                
//                if originalSpacing != nil {
//                    Button("Reset to Saved") {
//                        resetToSaved()
//                    }
//                }
                
                Button("Reset to macOS Default") {
                    resetToDefault()
                }
            }
            
            Text(message)
                .foregroundColor(.secondary)
                .font(.caption)
                .frame(minHeight: 40)
                .padding(.bottom)
        }
        .padding()
        .frame(width: 500)
        .onAppear {
            loadCurrentSpacing()
        }
    }
    
    private func loadCurrentSpacing() {
        if let current = SpacingManager.getCurrentSpacing() {
            spacing = CGFloat(current)
            originalSpacing = current
            lastAppliedSpacing = current
            currentSpacingStatus = "\(current) (Custom)"
        } else {
            originalSpacing = nil
            lastAppliedSpacing = nil
            currentSpacingStatus = "macOS Default"
            // Set slider to typical default (6) if no custom spacing exists
            spacing = 6
        }
    }
    
    private func applySpacing() {
        let newSpacing = Int(spacing)
        
        // Only proceed if this is a different value than last applied
        if newSpacing != lastAppliedSpacing {
            if SpacingManager.setSpacing(newSpacing) {
                lastAppliedSpacing = newSpacing
                originalSpacing = newSpacing
                currentSpacingStatus = "\(newSpacing) (Custom)"
                message = "Spacing set to \(newSpacing). Log out and back in to apply."
                
                // Special notes for extreme values
                if newSpacing == 0 {
                    message += " Note: 0 spacing may make items overlap."
                } else if newSpacing > 12 {
                    message += " Note: Large spacing may push items offscreen."
                }
            } else {
                message = "Failed to set spacing. Try again."
            }
        } else {
            message = "Spacing already set to \(newSpacing)."
        }
    }
    
    private func resetToSaved() {
        if let saved = originalSpacing {
            spacing = CGFloat(saved)
            applySpacing() // Use applySpacing to ensure proper tracking
        }
    }
    
    private func resetToDefault() {
        if SpacingManager.resetSpacing() {
            originalSpacing = nil
            lastAppliedSpacing = nil
            currentSpacingStatus = "macOS Default"
            message = "Reset to system default. Log out and back in to apply."
            
            // Update slider to show default (6 is typical default)
            spacing = 6
        } else {
            message = "Failed to reset spacing. Try again."
        }
    }
}

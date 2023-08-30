//
//  CCHaptics.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 8/30/23.
//

import CoreHaptics
import UIKit

struct CCHapticsPlayer {
    private var hapticEngine: CHHapticEngine?
    
    mutating func prepareForHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            self.hapticEngine = try CHHapticEngine()
            try hapticEngine?.start()
        } catch {
            print("There was an error creating the haptic engine: \(error.localizedDescription)")
        }
    }
    
    func playSinglePointHaptic() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else {
            print("The device does not support haptics.")
            return
        }
        
        guard hapticEngine != nil else {
            print("Haptic engine not initialized!")
            return
        }
        
        var events = [CHHapticEvent]()
        
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        events.append(event)
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try hapticEngine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription)")
        }
    }
    
    func playSimpleSuccess() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}

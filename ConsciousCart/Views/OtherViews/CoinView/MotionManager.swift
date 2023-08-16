//
//  MotionManager.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 7/28/23.
//

import CoreMotion
import SwiftUI

extension CoinView {
    @MainActor class MotionManager: ObservableObject {
        private let motionManager = CMMotionManager()
        
        @Published var x = 0.0
        @Published var y = 0.0
        
        // Mark the initial position of the device.
        var initialPitch: Double?
        var initialRoll: Double?
        
        init(x: Double = 0.0, y: Double = 0.0) {
            self.x = x
            self.y = y
            
            motionManager.accelerometerUpdateInterval = 0.20
            
            startMotionUpdates()
        }
        
        func startMotionUpdates() {
            motionManager.startDeviceMotionUpdates(to: .main) { [weak self] data, error in
                guard let motion = data?.attitude, let self = self, error == nil else { return }
                
                // Offset the roll and pitch by the device's initial
                // roll and pitch so that holding the phone in a normal
                // position emulates a horizontal roll and pitch.
                
                if self.initialPitch == nil {
                    self.initialPitch = motion.pitch
                }
                
                if self.initialRoll == nil {
                    self.initialRoll = motion.roll
                }
                
                guard let initialPitch = self.initialPitch, let initialRoll = self.initialRoll else {
                    return
                }
                
                let newPitch = motion.pitch
                let deltaPitch = (newPitch - initialPitch)
                
                let newRoll = motion.roll
                let deltaRoll = (newRoll - initialRoll)
                
                self.x = deltaRoll
                self.y = deltaPitch
            }
            
//            print("device motion updates enabled")
        }
        
        func stopMotionUpdates() {
            motionManager.stopDeviceMotionUpdates()
//            print("device motion updates disabled")
        }
        
        func isMotionActive() -> Bool {
            return motionManager.isDeviceMotionActive
        }
    }
}

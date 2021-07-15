//
//  Vibration.swift
//  CountOnMe
//
//  Created by Greg on 05/07/2021.
//  Copyright © 2021 Greg. All rights reserved.
//

import UIKit
import AudioToolbox

struct Vibration {
    
    enum For {
        
        case numbersAndDotButtons, operandsButtons, equalButton, ceClearButton, acResetButton, shakeAction
        
        internal func perform() {
            switch self {
            case .numbersAndDotButtons:
                if #available(iOS 13.0, *) {
                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                } else {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
            case .operandsButtons:
                if #available(iOS 13.0, *) {
                    UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                } else {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                }
            case .equalButton:
                UINotificationFeedbackGenerator().notificationOccurred(.success)
            case .ceClearButton:
                AudioServicesPlaySystemSound(1521)
            case .acResetButton:
                UINotificationFeedbackGenerator().notificationOccurred(.warning)
            case .shakeAction:
                UINotificationFeedbackGenerator().notificationOccurred(.error)
            }
        }
    }
}

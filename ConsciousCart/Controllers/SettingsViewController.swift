//
//  SettingsViewController.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 5/19/23.
//

import UIKit
import SwiftUI

class SettingsViewController: UIViewController {
    var impulsesStateManager: ImpulsesStateManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var settingsView = SettingsView()
        settingsView.impulsesStateManager = impulsesStateManager
        
        let hostingViewController = UIHostingController(rootView: settingsView)
        
        self.addChild(hostingViewController)
        
        if let hostView = hostingViewController.view {
            hostView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
            hostView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(hostView)
            
            NSLayoutConstraint.activate([
                hostView.topAnchor.constraint(equalTo: view.topAnchor),
                hostView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                hostView.leftAnchor.constraint(equalTo: view.leftAnchor),
                hostView.rightAnchor.constraint(equalTo: view.rightAnchor)
            ])
        }
    }
}

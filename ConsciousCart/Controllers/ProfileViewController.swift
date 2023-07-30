//
//  ProfileViewController.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 4/27/23.
//

import SwiftUI
import UIKit

class ProfileViewController: UIViewController {
    var impulsesStateManager: ImpulsesStateManager?
    
    override func viewDidLoad() {
        var profileView = ProfileView()
        profileView.impulsesStateManager = impulsesStateManager
        // this is a mess, either we need to use the statemanager or the moc in the swiftui views.
        // the state manager is performing like a singleton and im not sure this is the best
        // way to share state across the app. plus, it is not even thread safe in its current form.
        let profile = profileView.environment(\.managedObjectContext, impulsesStateManager!.moc!)
        
        let hostingViewController = UIHostingController(rootView: profile)
        
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


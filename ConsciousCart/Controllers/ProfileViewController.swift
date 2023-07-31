//
//  ProfileViewController.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 4/27/23.
//

import SwiftUI
import UIKit

class ProfileViewController: UIViewController {
    var impulsesStateManager: ImpulsesStateManager! = nil
    
    convenience init(impulsesStateManager: ImpulsesStateManager) {
        self.init(nibName: nil, bundle: nil)
        self.impulsesStateManager = impulsesStateManager
    }
    
    override func viewDidLoad() {
        let mainMOC = impulsesStateManager.coreDataManager.mainManagedObjectContext
        
        let profileView = ProfileView()
        
        let profile = profileView.environment(\.managedObjectContext, mainMOC)
        
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


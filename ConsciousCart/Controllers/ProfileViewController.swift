//
//  ProfileViewController.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 4/27/23.
//

import SwiftUI
import UIKit

class ProfileViewController: UIViewController {
    //    var impulsesStateManager: ImpulsesStateManager?
    var coreDataManager: CoreDataManager?
    
    override func viewDidLoad() {
        guard let mainMOC = coreDataManager?.mainManagedObjectContext else { return }
        
        var profileView = ProfileView()
        
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


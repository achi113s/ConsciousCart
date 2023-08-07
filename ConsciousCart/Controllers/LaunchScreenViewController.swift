//
//  LaunchScreenViewController.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 8/5/23.
//

import UIKit

class LaunchScreenViewController: UIPageViewController {
    var impulsesStateManager: ImpulsesStateManager! = nil
    
    private var imageView: UIImageView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setup()
        animateAway()
        navigateAway()
    }
    
    private func setup() {
        imageView = UIImageView()
        let image = UIImage(named: "ConsciousCartLoadingScreen")
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 200),
            imageView.heightAnchor.constraint(equalToConstant: 193)
        ])
    }
    
    private func animateAway() {
        UIView.animate(withDuration: 1.5, delay: 1.5, usingSpringWithDamping: 50, initialSpringVelocity: 1) {
//            self.imageView.transform = CGAffineTransform(scaleX: 40, y: 40)
            self.imageView.layer.opacity = 0.0
        }
    }
    
    private func navigateAway() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                let onboardingScreen = OnboardingViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
                onboardingScreen.impulsesStateManager = self?.impulsesStateManager
                sceneDelegate.window?.rootViewController = onboardingScreen
                sceneDelegate.window?.makeKeyAndVisible()
            }
        }
    }
    
}

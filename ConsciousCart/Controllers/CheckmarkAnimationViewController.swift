//
//  CheckmarkAnimationViewController.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 5/2/23.
//

import UIKit
import RiveRuntime

class CheckmarkAnimationViewController: UIViewController {
    var viewModel = RiveViewModel(fileName: "checkmark", animationName: "Animation", artboardName: "Checkmark")
    
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .clear
        
        viewModel.autoPlay = false
        
        let riveView = viewModel.createRiveView()
        riveView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(riveView)
        riveView.frame = view.frame
        
        NSLayoutConstraint.activate([
            riveView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            riveView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            riveView.widthAnchor.constraint(equalToConstant: 350),
            riveView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

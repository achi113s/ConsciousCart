//
//  CheckmarkAnimationViewController.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 5/2/23.
//

import UIKit
import RiveRuntime

class CheckmarkAnimationViewController: UIViewController {
    
    //MARK: - View Properties
    
    var viewModel = RiveViewModel(fileName: "checkmark", animationName: "Animation", artboardName: "Checkmark")
    var riveView: RiveView!
    
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .clear
        
        setSubviewProperties()
        addSubviewsToView()
        setLayoutConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - Add View Elements and Layout Constraints
    
    func setSubviewProperties() {
        viewModel.autoPlay = false
        riveView = viewModel.createRiveView()
        riveView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func addSubviewsToView() {
        view.addSubview(riveView)
        riveView.frame = view.frame
    }
    
    func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            riveView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            riveView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            riveView.widthAnchor.constraint(equalToConstant: 350),
            riveView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}

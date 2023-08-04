//
//  ImpulseDetailViewSwiftUI.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 8/1/23.
//

import SwiftUI

struct ImpulseDetailViewSwiftUI: UIViewControllerRepresentable {
    typealias UIViewControllerType = ImpulseDetailViewController
    
    var impulse: Impulse! = nil
    var impulsesStateManager: ImpulsesStateManager! = nil
    
    init(impulse: Impulse!, impulsesStateManager: ImpulsesStateManager!) {
        self.impulse = impulse
        self.impulsesStateManager = impulsesStateManager
    }
    
    func makeUIViewController(context: Context) -> ImpulseDetailViewController {
        let vc = ImpulseDetailViewController()
        vc.impulse = impulse
        vc.impulsesStateManager = impulsesStateManager
        return vc
    }
    
    func updateUIViewController(_ uiViewController: ImpulseDetailViewController, context: Context) {
//        uiViewController.parent?.navigationItem.rightBarButtonItems = uiViewController.navigationItem.rightBarButtonItems
//        vc.parent?.navigationItem.title = vc.navigationItem.title
//        vc.parent?.navigationItem.rightBarButtonItems = vc.navigationItem.rightBarButtonItems
    }
}

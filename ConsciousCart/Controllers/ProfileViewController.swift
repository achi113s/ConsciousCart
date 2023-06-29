//
//  ProfileViewController.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 4/27/23.
//

import UIKit

class ProfileViewController: UIViewController {
    
    private var scoreLabel: UILabel!
    private var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setSubviewProperties()
        addSubviewsToView()
        setLayoutConstraints()
    }
    
    func setSubviewProperties() {
        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        titleLabel.text = "Your ConsciousCart score is"
        titleLabel.font = UIFont.ccFont(textStyle: .title)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        scoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50)) 
    }
    
    func addSubviewsToView() {
        view.addSubview(titleLabel)
    }
    
    func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100)
        ])
    }
    
    
}

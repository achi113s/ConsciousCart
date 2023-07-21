//
//  ImpulseExpiredViewController.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 7/20/23.
//

import UIKit

class ImpulseExpiredViewController: UIViewController {
    
    let largeConfig = UIImage.SymbolConfiguration(pointSize: 72, weight: .regular, scale: .default)
    
    var impulse: Impulse? = nil
    
    private var image: UIImage! = nil
    private var imageView: UIImageView! = nil
    private var message: UILabel! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(exitView))
        
        navigationItem.title = impulse?.name ?? "Impulse"
        
        configureSubviewProperties()
        addSubviewsToView()
        configureLayoutConstraints()
    }
    
    
    
    @objc func exitView() {
        dismiss(animated: true)
    }
    
    func configureSubviewProperties() {
        guard let impulse else { fatalError("No Impulse in ImpulseExpired View Controller!") }
        
        if let imageName = impulse.imageName {
            let imagePath = FileManager.documentsDirectory.appendingPathComponent(imageName, conformingTo: .png)
            image = UIImage(contentsOfFile: imagePath.path())
        } else {
            image = UIImage(systemName: "barcode.viewfinder", withConfiguration: largeConfig)
        }
        
        imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        message = UILabel()
        message.translatesAutoresizingMaskIntoConstraints = false
        message.text = "Congrats"
    }
    
    func addSubviewsToView() {
        view.addSubview(imageView)
        view.addSubview(message)
    }
    
    func configureLayoutConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5),
            imageView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5),
            
            message.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            message.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            message.heightAnchor.constraint(equalToConstant: 40),
            message.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8)
        ])
    }
}

//
//  AddToCartViewController.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 4/25/23.
//

import UIKit

class AddToConsciousCartViewController: UIViewController {
    
    var saveButton: ConsciousCartButton!
    var uploadImageButton: ImageUploadButton!
    var scanBarcodeButton: ConsciousCartButton!
    
    override func loadView() {
        super.loadView()
        
        title = "New Impulse"
        
        view.backgroundColor = .white
        
        saveButton = ConsciousCartButton()
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveItem), for: .touchUpInside)
        view.addSubview(saveButton)
        
        uploadImageButton = ImageUploadButton()
        uploadImageButton.translatesAutoresizingMaskIntoConstraints = false
        uploadImageButton.addTarget(self, action: #selector(uploadImage), for: .touchUpInside)
//        view.addSubview(uploadImageButton)
        
        scanBarcodeButton = ConsciousCartButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 72, weight: .regular, scale: .default)
        scanBarcodeButton.setImage(UIImage(systemName: "barcode.viewfinder", withConfiguration: largeConfig), for: .normal)
        scanBarcodeButton.translatesAutoresizingMaskIntoConstraints = false
        scanBarcodeButton.addTarget(self, action: #selector(scanBarcode), for: .touchUpInside)
//        view.addSubview(scanBarcodeButton)
        
        let uploadButtonsStack = UIStackView(arrangedSubviews: [uploadImageButton, scanBarcodeButton])
        uploadButtonsStack.translatesAutoresizingMaskIntoConstraints = false
        uploadButtonsStack.axis = .horizontal
        uploadButtonsStack.spacing = 15
        uploadButtonsStack.distribution = .fillEqually
        view.addSubview(uploadButtonsStack)
        
        NSLayoutConstraint.activate([
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -70),
            saveButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            
            uploadButtonsStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            uploadButtonsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            uploadButtonsStack.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            uploadButtonsStack.heightAnchor.constraint(equalTo: uploadButtonsStack.widthAnchor, multiplier: 0.5)
            
//            uploadImageButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
//            uploadImageButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
//            uploadImageButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.4),
//            uploadImageButton.heightAnchor.constraint(equalTo: uploadImageButton.widthAnchor),
//
//            scanBarcodeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
//            scanBarcodeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
//            scanBarcodeButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.4),
//            scanBarcodeButton.heightAnchor.constraint(equalTo: scanBarcodeButton.widthAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(exitAddView))
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @objc func saveItem() {
        dismiss(animated: true)
    }
    
    @objc func exitAddView() {
        dismiss(animated: true)
    }
    
    @objc func uploadImage() {
        print("touched image upload")
    }
    
    @objc func scanBarcode() {
        let scanBarcodeVC = ScannerViewController()
        navigationController?.pushViewController(scanBarcodeVC, animated: true)
    }
}

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
    
    var itemNameTextField: ConsciousCartTextField!
    var itemPriceTextField: ConsciousCartTextField!
    var itemReasonNeededTextField: ConsciousCartTextField!
//    var itemWaitTime: UIPickerView!
    
    override func loadView() {
        super.loadView()
        
        title = "New Impulse"
        
        view.backgroundColor = .white
        
        saveButton = ConsciousCartButton()
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveItem), for: .touchUpInside)
        view.addSubview(saveButton)
        
        uploadImageButton = ImageUploadButton()
        uploadImageButton.addTarget(self, action: #selector(uploadImage), for: .touchUpInside)
        
        scanBarcodeButton = ConsciousCartButton()
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 72, weight: .regular, scale: .default)
        scanBarcodeButton.setImage(UIImage(systemName: "barcode.viewfinder", withConfiguration: largeConfig), for: .normal)
        scanBarcodeButton.addTarget(self, action: #selector(scanBarcode), for: .touchUpInside)
        
        let uploadButtonsStack = UIStackView(arrangedSubviews: [uploadImageButton, scanBarcodeButton])
        uploadButtonsStack.translatesAutoresizingMaskIntoConstraints = false
        uploadButtonsStack.axis = .horizontal
        uploadButtonsStack.spacing = 15
        uploadButtonsStack.distribution = .fillEqually
        view.addSubview(uploadButtonsStack)
        
        itemNameTextField = ConsciousCartTextField()
        itemNameTextField.delegate = self
        
        itemPriceTextField = ConsciousCartTextField()
        itemPriceTextField.delegate = self
        itemPriceTextField.keyboardType = .decimalPad
        
        itemReasonNeededTextField = ConsciousCartTextField()
        itemReasonNeededTextField.delegate = self
        
//        itemWaitTime = UIPickerView()
        
        let textInputStack = UIStackView(arrangedSubviews: [itemNameTextField, itemPriceTextField, itemReasonNeededTextField])
        textInputStack.translatesAutoresizingMaskIntoConstraints = false
        textInputStack.axis = .vertical
        textInputStack.spacing = 15
        textInputStack.distribution = .equalSpacing
        
        view.addSubview(textInputStack)
        
        NSLayoutConstraint.activate([
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -70),
            saveButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            
            uploadButtonsStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            uploadButtonsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            uploadButtonsStack.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            uploadButtonsStack.heightAnchor.constraint(equalTo: uploadButtonsStack.widthAnchor, multiplier: 0.5),
            
            textInputStack.topAnchor.constraint(equalTo: uploadButtonsStack.bottomAnchor, constant: 15),
            textInputStack.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: 0),
            textInputStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textInputStack.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8)
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

extension AddToConsciousCartViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
}

//extension AddToConsciousCartViewController: UIPickerViewDelegate, UIPickerViewDataSource {
//    picker
//}

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
    var activeTextField: UITextField?
    
    var gradient: CAGradientLayer!
//    var itemWaitTime: UIPickerView!
    
    override func loadView() {
        super.loadView()
        
        title = "New Impulse"
        
        loadElementsAndLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddToConsciousCartViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddToConsciousCartViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.tintColor = .black
    }
    
    //MARK: - Add Elements and Layout Code
    
    func loadElementsAndLayout() {
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
        itemNameTextField.placeholder = "Item Name"
        itemNameTextField.delegate = self
        view.addSubview(itemNameTextField)
        
        itemPriceTextField = ConsciousCartTextField()
        itemPriceTextField.placeholder = "Price"
        itemPriceTextField.delegate = self
        itemPriceTextField.keyboardType = .decimalPad
        view.addSubview(itemPriceTextField)
        
        itemReasonNeededTextField = ConsciousCartTextField()
        itemReasonNeededTextField.placeholder = "Reason Needed"
        itemReasonNeededTextField.delegate = self
        view.addSubview(itemReasonNeededTextField)
        
        gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height/2)
        gradient.startPoint = CGPoint(x: 0.5, y: 0.7)
        gradient.endPoint = CGPoint(x: 0.5, y: 1)
        gradient.colors = [UIColor.white.cgColor, UIColor(white: 1, alpha: 0).cgColor]
        gradient.isHidden = true
        view.layer.addSublayer(gradient)
        
//        itemWaitTime = UIPickerView()
        
//        let textInputStack = UIStackView(arrangedSubviews: [itemNameTextField, itemPriceTextField, itemReasonNeededTextField])
//        textInputStack.translatesAutoresizingMaskIntoConstraints = false
//        textInputStack.axis = .vertical
//        textInputStack.spacing = 15
//        textInputStack.distribution = .fillEqually
        
//        view.addSubview(textInputStack)
        
        NSLayoutConstraint.activate([
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -70),
            saveButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            
            uploadButtonsStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            uploadButtonsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            uploadButtonsStack.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            uploadButtonsStack.heightAnchor.constraint(equalTo: uploadButtonsStack.widthAnchor, multiplier: 0.5),
            
            itemNameTextField.heightAnchor.constraint(equalToConstant: 31),
            itemNameTextField.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            itemNameTextField.topAnchor.constraint(equalTo: uploadButtonsStack.bottomAnchor, constant: 50),
            itemNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            itemPriceTextField.heightAnchor.constraint(equalToConstant: 31),
            itemPriceTextField.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            itemPriceTextField.topAnchor.constraint(equalTo: itemNameTextField.bottomAnchor, constant: 15),
            itemPriceTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            itemReasonNeededTextField.heightAnchor.constraint(equalToConstant: 31),
            itemReasonNeededTextField.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            itemReasonNeededTextField.topAnchor.constraint(equalTo: itemPriceTextField.bottomAnchor, constant: 15),
            itemReasonNeededTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            
//            textInputStack.topAnchor.constraint(equalTo: uploadButtonsStack.bottomAnchor, constant: 50),
//            textInputStack.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -50),
//            textInputStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            textInputStack.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8)
        ])
        
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
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        if let activeTextField = activeTextField {
            let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.view).maxY
            let topOfKeyboard = self.view.frame.height - keyboardSize.height
            
            if bottomOfTextField > topOfKeyboard {
                UIView.animate(withDuration: 1.0) {
                    self.gradient.isHidden = false
                }
                self.view.frame.origin.y -= (keyboardSize.height/2)
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        UIView.animate(withDuration: 1.0) {
            self.gradient.isHidden = true
        }
        self.view.frame.origin.y = 0
    }
}

//MARK: - UITextField Delegate Code

extension AddToConsciousCartViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeTextField = nil
    }
}

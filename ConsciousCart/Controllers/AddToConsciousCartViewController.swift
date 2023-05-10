//
//  AddToCartViewController.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 4/25/23.
//

import UIKit

class AddToConsciousCartViewController: UIViewController {
    
    //MARK: - View Properties
    
    var saveButton: ConsciousCartButton!
    
    var uploadImageButton: ConsciousCartButton!
    var scanBarcodeButton: ConsciousCartButton!
    var uploadButtonsStack: UIStackView!
    
    var itemNameTextField: ConsciousCartTextField!
    var itemPriceTextField: ConsciousCartTextField!
    var itemReasonNeededTextField: ConsciousCartTextField!
    var activeTextField: UITextField?
    
    var itemRemindLabel: UILabel!
    var itemRemindDate: UIDatePicker!
    
    var gradient: CAGradientLayer!
    var gradientView: UIView!
    
    let largeConfig = UIImage.SymbolConfiguration(pointSize: 72, weight: .regular, scale: .default)
    
    override func loadView() {
        super.loadView()
        
        title = "New Impulse"
        
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(exitAddView))
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setSubviewProperties()
        addSubviewsToView()
        setLayoutConstraints()
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
    
    //MARK: - Add Elements and Layout Constraints
    
    func setSubviewProperties() {
        saveButton = ConsciousCartButton()
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveItem), for: .touchUpInside)
        
        uploadImageButton = ConsciousCartButton()
        uploadImageButton.setImage(UIImage(systemName: "photo.circle", withConfiguration: largeConfig), for: .normal)
        uploadImageButton.addTarget(self, action: #selector(uploadImage), for: .touchUpInside)
        
        scanBarcodeButton = ConsciousCartButton()
        scanBarcodeButton.setImage(UIImage(systemName: "barcode.viewfinder", withConfiguration: largeConfig), for: .normal)
        scanBarcodeButton.addTarget(self, action: #selector(scanBarcode), for: .touchUpInside)
        
        uploadButtonsStack = UIStackView(arrangedSubviews: [uploadImageButton, scanBarcodeButton])
        uploadButtonsStack.translatesAutoresizingMaskIntoConstraints = false
        uploadButtonsStack.axis = .horizontal
        uploadButtonsStack.spacing = 15
        uploadButtonsStack.distribution = .fillEqually
        
        itemNameTextField = ConsciousCartTextField()
        itemNameTextField.placeholder = "Item Name"
        itemNameTextField.delegate = self
        
        itemPriceTextField = ConsciousCartTextField()
        itemPriceTextField.placeholder = "Price"
        itemPriceTextField.delegate = self
        itemPriceTextField.keyboardType = .decimalPad
        
        itemReasonNeededTextField = ConsciousCartTextField()
        itemReasonNeededTextField.placeholder = "Reason Needed"
        itemReasonNeededTextField.delegate = self
        
        itemRemindLabel = UILabel()
        itemRemindLabel.text = "When should we remind you?"
        itemRemindLabel.textAlignment = .center
        itemRemindLabel.translatesAutoresizingMaskIntoConstraints = false
        
        itemRemindDate = UIDatePicker()
        itemRemindDate.contentHorizontalAlignment = .center
        itemRemindDate.date = Date.now.addingTimeInterval(TimeInterval(1209600))
        itemRemindDate.minimumDate = Date.now
        itemRemindDate.translatesAutoresizingMaskIntoConstraints = false
        
        gradient = CAGradientLayer()
        let gradientViewHiderHeight = navigationController?.navigationBar.frame.height ?? view.frame.height/8
        gradient.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: gradientViewHiderHeight*2)
        gradient.startPoint = CGPoint(x: 0.5, y: 0.7)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        gradient.colors = [UIColor.white.cgColor, UIColor(white: 1.0, alpha: 0.0).cgColor]
//        gradient.colors = [UIColor.white.cgColor, UIColor.black.cgColor]
        gradientView = UIView(frame: gradient.frame)
        gradientView.layer.addSublayer(gradient)
        gradientView.alpha = 0.0
    }
    
    func addSubviewsToView() {
        view.addSubview(saveButton)
        view.addSubview(uploadButtonsStack)
        view.addSubview(itemNameTextField)
        view.addSubview(itemPriceTextField)
        view.addSubview(itemReasonNeededTextField)
        view.addSubview(itemRemindLabel)
        view.addSubview(itemRemindDate)
        view.addSubview(gradientView)
    }
    
    func setLayoutConstraints() {
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
            itemReasonNeededTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            itemRemindLabel.heightAnchor.constraint(equalToConstant: 31),
            itemRemindLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            itemRemindLabel.topAnchor.constraint(equalTo: itemReasonNeededTextField.bottomAnchor, constant: 15),
            itemRemindLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            itemRemindDate.heightAnchor.constraint(equalToConstant: 31),
            itemRemindDate.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            itemRemindDate.topAnchor.constraint(equalTo: itemRemindLabel.bottomAnchor, constant: 15),
            itemRemindDate.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    //MARK: - Selectors
    
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
                UIView.animate(withDuration: 1.0) { [weak self] in
                    self?.gradientView.alpha = 1.0
                }
                self.view.frame.origin.y -= keyboardSize.height
                self.gradientView.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        self.view.frame.origin.y = 0
        self.gradientView.frame.origin.y = 0
        UIView.animate(withDuration: 1.0) { [weak self] in
            self?.gradientView.alpha = 0.0
        }
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

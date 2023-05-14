//
//  AddToCartViewController.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 4/25/23.
//

import UIKit
import PhotosUI

class AddToConsciousCartViewController: UIViewController, UINavigationControllerDelegate {
    
    //MARK: - View Properties
    
    private var saveButton: ConsciousCartButton!
    
    private var uploadImageButton: ConsciousCartButton!
    private var scanBarcodeButton: ConsciousCartButton!
    private var uploadButtonsStack: UIStackView!
    
    var itemNameTextField: ConsciousCartTextField!
    var itemPriceTextField: ConsciousCartTextField!
    var itemReasonNeededTextField: ConsciousCartTextField!
    private var activeTextField: UITextField?
    
    private var itemRemindLabel: UILabel!
    private var itemRemindDate: UIDatePicker!
    
    private var inputItemsStack: UIStackView!
    
    //    var gradient: CAGradientLayer!
    //    var gradientView: UIView!
    
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
        
        view.keyboardLayoutGuide.followsUndockedKeyboard = true
        initializeHideKeyboardOnTap()
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddToConsciousCartViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddToConsciousCartViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.tintColor = .black
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            if self.itemRemindDate.frame.contains(touch.location(in: self.view)) {
                self.view.endEditing(true)
            }
        }
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
        itemNameTextField.tag = 1
        itemNameTextField.delegate = self
        
        itemPriceTextField = ConsciousCartTextField()
        itemPriceTextField.placeholder = "Price"
        itemPriceTextField.delegate = self
        itemPriceTextField.tag = 2
        itemPriceTextField.keyboardType = .decimalPad
        
        itemReasonNeededTextField = ConsciousCartTextField()
        itemReasonNeededTextField.placeholder = "Reason Needed"
        itemReasonNeededTextField.tag = 3
        itemReasonNeededTextField.delegate = self
        
        itemRemindLabel = UILabel()
        itemRemindLabel.text = "When should we remind you?"
        itemRemindLabel.textAlignment = .center
        itemRemindLabel.translatesAutoresizingMaskIntoConstraints = false
        
        itemRemindDate = UIDatePicker()
        itemRemindDate.contentHorizontalAlignment = .center
        itemRemindDate.date = Date.now.addingTimeInterval(TimeInterval(1209600))
        itemRemindDate.minimumDate = Date.now.addingTimeInterval(TimeInterval(86400))
        itemRemindDate.translatesAutoresizingMaskIntoConstraints = false
        
        inputItemsStack = UIStackView()
        inputItemsStack.spacing = 15
        inputItemsStack.axis = .vertical
        inputItemsStack.alignment = .center
        inputItemsStack.distribution = .fill
        inputItemsStack.translatesAutoresizingMaskIntoConstraints = false
        
        let arrangedSubviews = [itemNameTextField, itemPriceTextField, itemReasonNeededTextField, itemRemindLabel, itemRemindDate]
        for subview in arrangedSubviews {
            if let subview = subview {
                inputItemsStack.addArrangedSubview(subview)
            }
        }
        
        //        gradient = CAGradientLayer()
        //        let gradientViewHiderHeight = navigationController?.navigationBar.frame.height ?? view.frame.height/8
        //        gradient.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: gradientViewHiderHeight*1.5)
        //        gradient.startPoint = CGPoint(x: 0.5, y: 0.7)
        //        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        //        gradient.colors = [UIColor.white.cgColor, UIColor(white: 1.0, alpha: 0.0).cgColor]
        //        //        gradient.colors = [UIColor.white.cgColor, UIColor.black.cgColor]
        //        gradientView = UIView(frame: gradient.frame)
        //        gradientView.layer.addSublayer(gradient)
        //        gradientView.alpha = 0.0
    }
    
    func addSubviewsToView() {
        //        view.addSubview(gradientView)
        view.addSubview(uploadButtonsStack)
        view.addSubview(inputItemsStack)
        view.addSubview(saveButton)
    }
    
    func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            uploadButtonsStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            uploadButtonsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            uploadButtonsStack.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            uploadButtonsStack.heightAnchor.constraint(equalTo: uploadButtonsStack.widthAnchor, multiplier: 0.5),
            
            itemNameTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 31),
            itemNameTextField.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            //            itemNameTextField.bottomAnchor.constraint(equalTo: itemPriceTextField.topAnchor, constant: -15),
            //            itemNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            //
            itemPriceTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 31),
            itemPriceTextField.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            //            itemPriceTextField.bottomAnchor.constraint(equalTo: itemReasonNeededTextField.topAnchor, constant: -15),
            //            itemPriceTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            //
            itemReasonNeededTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 31),
            itemReasonNeededTextField.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            //            itemReasonNeededTextField.bottomAnchor.constraint(equalTo: itemRemindLabel.topAnchor, constant: -15),
            //            itemReasonNeededTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            //
            itemRemindLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 31),
            itemRemindLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            //            itemRemindLabel.bottomAnchor.constraint(equalTo: itemRemindDate.topAnchor, constant: -15),
            //            itemRemindLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            //
            itemRemindDate.heightAnchor.constraint(greaterThanOrEqualToConstant: 31),
            itemRemindDate.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            //            itemRemindDate.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -60),
            //            itemRemindDate.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            inputItemsStack.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            inputItemsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            inputItemsStack.topAnchor.constraint(equalTo: uploadButtonsStack.bottomAnchor, constant: 30),
            
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15)
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
        let alert = UIAlertController(title: "Upload an Image", message: nil, preferredStyle: .actionSheet)
        
        let selectImageFromLibrary = UIAlertAction(title: "Choose from Library", style: .default) { [weak self] action in
            var pickerConfig = PHPickerConfiguration()
            // Setting selectionLimit to 1 forces auto dismissal of the view immediately
            // upon image selection, so we'll set it
            // to 2 and then only import the first image later.
            pickerConfig.selectionLimit = 2
            pickerConfig.filter = .images
            pickerConfig.selection = .ordered
            
            var phPickerController = PHPickerViewController(configuration: pickerConfig)
            phPickerController.delegate = self
            
            DispatchQueue.main.async {
                self?.present(phPickerController, animated: true)
            }
        }
        
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { [weak self] action in
            let pickerVC = UIImagePickerController()
            pickerVC.sourceType = .camera
            pickerVC.delegate = self
            self?.present(pickerVC, animated: true)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(selectImageFromLibrary)
        alert.addAction(takePhoto)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
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
                //                UIView.animate(withDuration: 1.0) { [weak self] in
                //                    self?.gradientView.alpha = 1.0
                //                }
                //                self.view.frame.origin.y -= keyboardSize.height
                self.view.frame.origin.y = (bottomOfTextField - topOfKeyboard / 1.5) * -1
                //                self.gradientView.frame.origin.y += (bottomOfTextField - topOfKeyboard / 1.5)
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        self.view.frame.origin.y = 0
        //        self.gradientView.frame.origin.y = 0
        //        UIView.animate(withDuration: 1.0) { [weak self] in
        //            self?.gradientView.alpha = 0.0
        //        }
    }
}

//MARK: - UITextField Delegate Code

extension AddToConsciousCartViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.itemRemindDate.isEnabled = false
        self.activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.itemRemindDate.isEnabled = true
        self.activeTextField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}

//MARK: - UIImagePickerController Delegate Code

extension AddToConsciousCartViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("sdf")
        dismiss(animated: true)
    }
}

//MARK: - PHPickerViewController Delegate Code

extension AddToConsciousCartViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        print("sdfsdf")
        dismiss(animated: true)
    }
    
    
}

//MARK: - Extension for Hide Keyboard on Tap

extension UIViewController {
    func initializeHideKeyboardOnTap(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboardOnTap))
        
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboardOnTap(){
        view.endEditing(true)
    }
}

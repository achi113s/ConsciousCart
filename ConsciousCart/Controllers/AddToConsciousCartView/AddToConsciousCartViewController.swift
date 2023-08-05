//
//  AddToCartViewController.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 4/25/23.
//

import PhotosUI
import UIKit
import UserNotifications

class AddToConsciousCartViewController: UIViewController, UINavigationControllerDelegate {
    var impulsesStateManager: ImpulsesStateManager?
    var mainCVC: MainCollectionViewController?
    
    let largeConfig = UIImage.SymbolConfiguration(pointSize: 72, weight: .regular, scale: .default)
    
    private var uploadImageButton: ConsciousCartButton!
    
    private var containerView: UIView!
    private var imageView: UIImageView!
    private var changeImageButton: UIButton!
    
    private var scanBarcodeButton: ConsciousCartButton!
    private var uploadButtonsStack: UIStackView!
    
    var itemNameTextField: ConsciousCartTextField!
    var itemPriceTextField: CurrencyTextField!
    var itemReasonNeededTextField: ConsciousCartTextField!
    private var activeTextField: UITextField?
    
    //    private var categoryPicker: UIPickerView! = nil
    //    private var categoryPickerDataSource: CategoryPickerDataSource! = nil
    //    private var categoryPickerDelegate: CategoryPickerDelegate! = nil
    
    private var itemRemindLabel: UILabel!
    private var itemRemindDate: UIDatePicker!
    
    private var inputItemsStack: UIStackView!
    
    private var saveButton: ConsciousCartButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "New Impulse"
        
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Exit", style: .plain, target: self, action: #selector(exitAddView))
        navigationController?.navigationBar.prefersLargeTitles = true
        
        configureSubviewProperties()
        addSubviewsToView()
        configureLayoutConstraints()
        
        view.keyboardLayoutGuide.followsUndockedKeyboard = true
        
        initializeHideKeyboardOnTap()
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddToConsciousCartViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddToConsciousCartViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.tintColor = .black
    }
}

//MARK: - Selectors
extension AddToConsciousCartViewController {
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
            
            let phPickerController = PHPickerViewController(configuration: pickerConfig)
            phPickerController.delegate = self
            
            self?.present(phPickerController, animated: true)
        }
        
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { [weak self] action in
            let pickerVC = UIImagePickerController()
            pickerVC.sourceType = .camera
            pickerVC.allowsEditing = true
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
        let scanBarcodeVC = BarcodeScannerViewController()
        navigationController?.pushViewController(scanBarcodeVC, animated: true)
    }
    
    @objc func saveItem() {
        guard let impulsesStateManager = impulsesStateManager else {
            print("impulsesStateManager not unwrapped successfully.")
            return
        }
        guard let mainCVC = mainCVC else { return }
        
        guard let itemPriceString = itemPriceTextField.text else { return }
        let itemPrice = itemPriceString.asDoubleFromCurrency(locale: Locale.current)
        
        // Save the image with a UUID as its name if the user selected an image.
        // The function returns nil if there is no image to save.
        let imageName = saveImpulseImage()
        var itemName = ""
        var itemReason = ""
        
        if let name = itemNameTextField.text {
            if name.stringInputIsValid() {
                itemName = name.trimmingCharacters(in: .whitespacesAndNewlines)
            } else {
                itemName = "Unknown"
            }
        }
        
        if let reason = itemReasonNeededTextField.text {
            if reason.stringInputIsValid() {
                itemReason = reason.trimmingCharacters(in: .whitespacesAndNewlines)
            } else {
                itemReason = "Unknown"
            }
        }
        
        let impulse = impulsesStateManager.addImpulse(remindDate: itemRemindDate.date,
                                                      name: itemName,
                                                      price: itemPrice,
                                                      imageName: imageName,
                                                      reasonNeeded: itemReason)
        
        impulsesStateManager.setupNotification(for: impulse)
        
        mainCVC.collectionView.reloadData()
        
        dismiss(animated: true)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        if let activeTextField = activeTextField {
            let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.view).maxY
            let topOfKeyboard = self.view.frame.height - keyboardSize.height
            
            if bottomOfTextField > topOfKeyboard {
                self.view.frame.origin.y = (bottomOfTextField - topOfKeyboard / 1.5) * -1
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    @objc func exitAddView() {
        dismiss(animated: true)
    }
    
    func saveImpulseImage() -> String? {
        var imageName: String? = nil
        if let image = imageView.image {
            do {
                if let imageData = image.pngData() {
                    imageName = UUID().uuidString
                    try imageData.write(to: FileManager.documentsDirectory.appendingPathComponent(imageName!, conformingTo: .png))
                }
            } catch {
                print("Could not save image for Impulse.")
            }
        }
        
        return imageName
    }
}

//MARK: - Configure Subviews
extension AddToConsciousCartViewController {
    private func configureSubviewProperties() {
        saveButton = ConsciousCartButton()
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveItem), for: .touchUpInside)
        
        uploadImageButton = ConsciousCartButton()
        uploadImageButton.setImage(UIImage(systemName: "photo.circle", withConfiguration: largeConfig), for: .normal)
        uploadImageButton.addTarget(self, action: #selector(uploadImage), for: .touchUpInside)
        
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = uploadImageButton.layer.cornerRadius
        containerView.layer.borderWidth = uploadImageButton.layer.borderWidth
        containerView.layer.borderColor = uploadImageButton.layer.borderColor
        
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = uploadImageButton.layer.cornerRadius
        imageView.layer.borderWidth = uploadImageButton.layer.borderWidth
        imageView.layer.borderColor = uploadImageButton.layer.borderColor
        imageView.layer.masksToBounds = true
        
        changeImageButton = UIButton()
        changeImageButton.translatesAutoresizingMaskIntoConstraints = false
        changeImageButton.setTitle("Change Image", for: .normal)
        changeImageButton.titleLabel?.font = UIFont(name: "Nunito-Regular", size: 17)
        changeImageButton.tintColor = .white
        changeImageButton.backgroundColor = UIColor(white: 0.05, alpha: 0.8)
        changeImageButton.addTarget(self, action: #selector(uploadImage), for: .touchUpInside)
        changeImageButton.layer.cornerRadius = uploadImageButton.layer.cornerRadius
        changeImageButton.layer.borderWidth = uploadImageButton.layer.borderWidth
        changeImageButton.layer.borderColor = uploadImageButton.layer.borderColor
        changeImageButton.layer.masksToBounds = true
        changeImageButton.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        containerView.addSubview(imageView)
        containerView.addSubview(changeImageButton)
        
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
        
        itemReasonNeededTextField = ConsciousCartTextField()
        itemReasonNeededTextField.placeholder = "Reason Needed"
        itemReasonNeededTextField.tag = 2
        itemReasonNeededTextField.delegate = self
        
        itemPriceTextField = CurrencyTextField()
        itemPriceTextField.placeholder = "0".asCurrency(locale: Locale.current)
        itemPriceTextField.delegate = self
        itemPriceTextField.tag = 3
        itemPriceTextField.keyboardType = .decimalPad
        
        //        categoryPicker = UIPickerView()
        //        categoryPicker.translatesAutoresizingMaskIntoConstraints = false
        //        categoryPickerDataSource = CategoryPickerDataSource(impulsesStateManager: impulsesStateManager)
        //        categoryPicker.dataSource = categoryPickerDataSource
        //        categoryPickerDelegate = CategoryPickerDelegate()
        //        categoryPicker.delegate = categoryPickerDelegate
        
        itemRemindLabel = UILabel()
        itemRemindLabel.text = "When should we remind you?"
        itemRemindLabel.font = UIFont.ccFont(textStyle: .headline)
        itemRemindLabel.textAlignment = .center
        itemRemindLabel.translatesAutoresizingMaskIntoConstraints = false
        
        itemRemindDate = UIDatePicker()
        itemRemindDate.contentHorizontalAlignment = .center
        itemRemindDate.date = Date.now.addingTimeInterval(TimeInterval(1209600))
        itemRemindDate.minimumDate = Date.now.addingTimeInterval(TimeInterval(86400))
        itemRemindDate.translatesAutoresizingMaskIntoConstraints = false
        
        inputItemsStack = UIStackView(arrangedSubviews: [itemNameTextField, itemReasonNeededTextField, itemPriceTextField, itemRemindLabel, itemRemindDate])
        inputItemsStack.spacing = 15
        inputItemsStack.axis = .vertical
        inputItemsStack.alignment = .center
        inputItemsStack.distribution = .fill
        inputItemsStack.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addSubviewsToView() {
        view.addSubview(uploadButtonsStack)
        view.addSubview(inputItemsStack)
        view.addSubview(saveButton)
    }
}

//MARK: - Configure Layout Constraints
extension AddToConsciousCartViewController {
    func configureLayoutConstraints() {
        NSLayoutConstraint.activate([
            uploadButtonsStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            uploadButtonsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            uploadButtonsStack.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.7),
            uploadButtonsStack.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.35),
            
            changeImageButton.heightAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 0.3),
            changeImageButton.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            changeImageButton.widthAnchor.constraint(equalTo: imageView.widthAnchor),
            
            imageView.heightAnchor.constraint(equalTo: containerView.heightAnchor),
            imageView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            
            itemNameTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 31),
            itemNameTextField.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            
            itemReasonNeededTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 31),
            itemReasonNeededTextField.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            
            itemPriceTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 31),
            itemPriceTextField.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            
            //            categoryPicker.heightAnchor.constraint(greaterThanOrEqualToConstant: 31),
            //            categoryPicker.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            
            itemRemindLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 31),
            itemRemindLabel.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            
            itemRemindDate.heightAnchor.constraint(greaterThanOrEqualToConstant: 31),
            itemRemindDate.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            
            inputItemsStack.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            inputItemsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            inputItemsStack.topAnchor.constraint(equalTo: uploadButtonsStack.bottomAnchor, constant: 30),
            
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
}

//MARK: - Configure UITextField Delegate
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

//MARK: - UIImagePickerController Delegate
extension AddToConsciousCartViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else { return }
        
        DispatchQueue.main.async {
            self.uploadButtonsStack.removeArrangedSubview(self.uploadImageButton)
            self.uploadImageButton.removeFromSuperview()
            
            self.uploadButtonsStack.removeArrangedSubview(self.scanBarcodeButton)
            self.scanBarcodeButton.removeFromSuperview()
            
            self.uploadButtonsStack.addArrangedSubview(self.containerView)
            self.uploadButtonsStack.addArrangedSubview(self.scanBarcodeButton)
            
            self.imageView.image = image
        }
    }
}

//MARK: - PHPickerViewController Delegate
extension AddToConsciousCartViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        // Add the selected image to the view.
        guard let provider = results.first?.itemProvider else { return }
        
        if provider.canLoadObject(ofClass: UIImage.self) {
            provider.loadObject(ofClass: UIImage.self) { image, _ in
                DispatchQueue.main.async {
                    self.uploadButtonsStack.removeArrangedSubview(self.uploadImageButton)
                    self.uploadImageButton.removeFromSuperview()
                    
                    self.uploadButtonsStack.removeArrangedSubview(self.scanBarcodeButton)
                    self.scanBarcodeButton.removeFromSuperview()
                    
                    self.uploadButtonsStack.addArrangedSubview(self.containerView)
                    self.uploadButtonsStack.addArrangedSubview(self.scanBarcodeButton)
                    
                    self.imageView.image = image as? UIImage
                }
            }
        }
    }
}

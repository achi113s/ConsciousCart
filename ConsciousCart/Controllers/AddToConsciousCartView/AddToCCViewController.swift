//
//  NewAddToCCViewController.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 8/19/23.
//

import AVFoundation
import PhotosUI
import UIKit
import UserNotifications

class AddToCCViewController: UIViewController, UINavigationControllerDelegate {
    var impulsesStateManager: ImpulsesStateManager?
    
    private var scrollView: UIScrollView! = nil
    private var contentView: UIView! = nil
    
    private var uploadImageButton: ConsciousCartButton! = nil
    
    private var containerView: UIView!
    private var imageView: UIImageView!
    private var changeImageButton: UIButton!
    
    private var scanBarcodeButton: ConsciousCartButton!
    private var uploadButtonsStack: UIStackView!
    
    var itemNameTextField: ConsciousCartTextField!
    var itemReasonNeededTextField: ConsciousCartTextField!
    var itemURLTextField: ConsciousCartTextField!
    var itemPriceTextField: CurrencyTextField!
    private var activeTextField: UITextField?
    
    private var inputItemsStack: UIStackView!
    
    private var itemRemindLabel: UILabel!
    private var itemRemindDate: UIDatePicker!
    private var reminderDateStack: UIStackView! = nil
    
    private var categoryLabel: UILabel! = nil
    private var categoriesButton: ImpulseCategoryButton! = nil
    private var categoryStack: UIStackView! = nil
    private var selectedCategory: ImpulseCategory? = nil
    
    private var itemReminderCategoryStack: UIStackView! = nil
    
    private var saveButton: ConsciousCartButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "New Impulse"
        
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Exit", style: .plain, target: self, action: #selector(exitAddView))
        navigationController?.navigationBar.prefersLargeTitles = true
        
        configureScrollView()
        configureSubviews()
        addSubviewsToView()
        configureLayoutConstraints()
        
        // this is where the bug is coming from
        initializeHideKeyboardOnTap()
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddToCCViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddToCCViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.tintColor = .black
    }
}

//MARK: - CategoriesViewControllerDelegate
extension AddToCCViewController: CategoriesViewControllerDelegate {
    func categoryDidChangeTo(_ category: ImpulseCategory) {
        print("category changed to: \(category.unwrappedCategoryName)")
        
        selectedCategory = category
        categoriesButton.setEmojiTo(category.unwrappedCategoryEmoji)
        categoriesButton.setCategoryNameTo(category.unwrappedCategoryName)
    }
}


//MARK: - Configure Subviews
extension AddToCCViewController {
    private func configureScrollView() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.bounces = true
        scrollView.alwaysBounceVertical = true
        
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureSubviews() {
        saveButton = ConsciousCartButton()
        saveButton.setTitle("Save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveItem), for: .touchUpInside)
        
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 64, weight: .regular, scale: .default)
        
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
        
        itemURLTextField = ConsciousCartTextField()
        itemURLTextField.placeholder = "URL"
        itemURLTextField.tag = 3
        itemURLTextField.delegate = self
        
        itemPriceTextField = CurrencyTextField()
        itemPriceTextField.placeholder = "0".asCurrency(locale: Locale.current)
        itemPriceTextField.delegate = self
        itemPriceTextField.tag = 4
        itemPriceTextField.keyboardType = .decimalPad
        
        itemRemindLabel = UILabel()
        itemRemindLabel.text = "Reminder Date"
        itemRemindLabel.font = UIFont.ccFont(textStyle: .headline)
        itemRemindLabel.textAlignment = .center
        itemRemindLabel.translatesAutoresizingMaskIntoConstraints = false
        
        itemRemindDate = UIDatePicker()
        itemRemindDate.contentHorizontalAlignment = .center
        itemRemindDate.date = Date.now.addingTimeInterval(TimeInterval(1209600))
        itemRemindDate.minimumDate = Date.now
        itemRemindDate.translatesAutoresizingMaskIntoConstraints = false
        
        reminderDateStack = UIStackView(arrangedSubviews: [itemRemindLabel, itemRemindDate])
        reminderDateStack.translatesAutoresizingMaskIntoConstraints = false
        reminderDateStack.axis = .vertical
        reminderDateStack.spacing = 5
        reminderDateStack.distribution = .equalSpacing
        reminderDateStack.alignment = .center
        
        categoryLabel = UILabel()
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.text = "Category"
        categoryLabel.font = UIFont.ccFont(textStyle: .headline)
        categoryLabel.textAlignment = .center
        
        categoriesButton = ImpulseCategoryButton(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        categoriesButton.setCategoryNameTo("Tap to Choose")
        categoriesButton.setEmojiTo("☺️")
        categoriesButton.addTarget(self, action: #selector(showCategoryPicker), for: .touchUpInside)
        
        categoryStack = UIStackView(arrangedSubviews: [categoryLabel, categoriesButton])
        categoryStack.translatesAutoresizingMaskIntoConstraints = false
        categoryStack.axis = .vertical
        categoryStack.spacing = 5
        categoryStack.distribution = .equalSpacing
        
        itemReminderCategoryStack = UIStackView(arrangedSubviews: [reminderDateStack, categoryStack])
        itemReminderCategoryStack.translatesAutoresizingMaskIntoConstraints = false
        itemReminderCategoryStack.axis = .horizontal
        itemReminderCategoryStack.distribution = .equalCentering
        itemReminderCategoryStack.spacing = 5
        itemReminderCategoryStack.alignment = .center
        
        inputItemsStack = UIStackView(arrangedSubviews: [itemNameTextField, itemReasonNeededTextField, itemURLTextField, itemPriceTextField])
        inputItemsStack.spacing = 15
        inputItemsStack.axis = .vertical
        inputItemsStack.alignment = .center
        inputItemsStack.distribution = .fill
        inputItemsStack.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addSubviewsToView() {
        view.addSubview(scrollView)
        
        contentView.addSubview(uploadButtonsStack)
        
        contentView.addSubview(inputItemsStack)
        
        contentView.addSubview(itemReminderCategoryStack)
        
        contentView.addSubview(saveButton)
        
        scrollView.addSubview(contentView)
    }
    
    private func configureLayoutConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            uploadButtonsStack.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 15),
            uploadButtonsStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            uploadButtonsStack.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.7),
            uploadButtonsStack.heightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.35),
            
            changeImageButton.heightAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 0.3),
            changeImageButton.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            changeImageButton.widthAnchor.constraint(equalTo: imageView.widthAnchor),
            
            imageView.heightAnchor.constraint(equalTo: containerView.heightAnchor),
            imageView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            
            itemNameTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 31),
            itemNameTextField.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            
            itemReasonNeededTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 31),
            itemReasonNeededTextField.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            
            itemURLTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 31),
            itemURLTextField.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            
            itemPriceTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 31),
            itemPriceTextField.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            
            inputItemsStack.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            inputItemsStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            inputItemsStack.topAnchor.constraint(equalTo: uploadButtonsStack.bottomAnchor, constant: 30),
            
            itemRemindLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 31),
            itemRemindLabel.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.4),
            
            itemRemindDate.heightAnchor.constraint(greaterThanOrEqualToConstant: 31),
            itemRemindDate.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
            
            categoryLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 31),
            categoryLabel.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.4),
            
            categoriesButton.heightAnchor.constraint(equalToConstant: 100),
            categoriesButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 100),
            
            itemReminderCategoryStack.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            itemReminderCategoryStack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            itemReminderCategoryStack.topAnchor.constraint(equalTo: inputItemsStack.bottomAnchor, constant: 20),
            
            saveButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            saveButton.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    
}

//MARK: - UIImagePickerController Delegate
extension AddToCCViewController: UIImagePickerControllerDelegate {
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
extension AddToCCViewController: PHPickerViewControllerDelegate {
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

//MARK: - UITextFieldDelegate
extension AddToCCViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.itemRemindDate.isEnabled = false
        self.categoriesButton.isEnabled = false
        self.activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.itemRemindDate.isEnabled = true
        self.categoriesButton.isEnabled = true
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

//MARK: - Selectors
extension AddToCCViewController {
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
    
    @objc func saveItem() {
        guard let impulsesStateManager = impulsesStateManager else {
            print("impulsesStateManager not unwrapped successfully.")
            return
        }
        
        // Impulse must have a name and price at least.
        guard let itemPriceString = itemPriceTextField.text else {
            saveButton.shakeAnimation()
            return
        }
        
        
        let itemPrice = itemPriceString.asDoubleFromCurrency(locale: Locale.current)
        
        guard let itemCategory = selectedCategory?.categoryName else {
            saveButton.shakeAnimation()
            return
        }
        
        // Save the image with a UUID as its name if the user selected an image.
        // The function returns nil if there is no image to save.
        let imageName = saveImpulseImage()
        var itemName = ""
        var itemReason = ""
        var itemURL = ""
        
        
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
        
        if let url = itemURLTextField.text {
            itemURL = url.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        let impulse = impulsesStateManager.addImpulse(remindDate: itemRemindDate.date,
                                                      name: itemName,
                                                      price: itemPrice,
                                                      imageName: imageName,
                                                      reasonNeeded: itemReason,
                                                      url: itemURL,
                                                      category: itemCategory)
        
        impulsesStateManager.setupNotification(for: impulse)
        
        impulsesStateManager.saveImpulses()
        
        if UserDefaults.standard.bool(forKey: UserDefaultsKeys.allowHaptics.rawValue) {
            let hapticsPlayer = CCHapticsPlayer()
            hapticsPlayer.playSimpleSuccess()
        }
        
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
    
    @objc func scanBarcode() {
        let authorizedForCamera = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch authorizedForCamera {
        case .notDetermined:
            requestCameraPermission()
        case .denied, .restricted:
            alertCameraAccessNeeded()
        case .authorized:
            presentBarcodeScanner()
        default:
            presentUnknownErrorOccured()
        }
    }
    
    private func presentBarcodeScanner() {
        DispatchQueue.main.async { [weak self] in
            let scanBarcodeVC = BarcodeScannerViewController()
            self?.navigationController?.pushViewController(scanBarcodeVC, animated: true)
        }
    }
    
    @objc private func showCategoryPicker() {
        let vc = CategoriesViewController()
        vc.impulsesStateManager = impulsesStateManager
        
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        
        vc.categoryChangedDelegate = self
        vc.previouslySelectedCategory = selectedCategory
        
        present(vc, animated: true)
    }
    
    @objc func uploadImage() {
        let alert = UIAlertController(title: "Upload an Image", message: nil, preferredStyle: .actionSheet)
        
        let selectImageFromLibrary = UIAlertAction(title: "Choose from Library", style: .default) { [weak self] action in
            self?.presentPhotosPicker()
        }
        
        let takePhoto = UIAlertAction(title: "Take a Picture", style: .default) { [weak self] action in
            let authorizedForCamera = AVCaptureDevice.authorizationStatus(for: .video)
            
            switch authorizedForCamera {
            case .notDetermined:
                self?.requestCameraPermission()
            case .denied, .restricted:
                self?.alertCameraAccessNeeded()
            case .authorized:
                self?.presentCamera()
            default:
                self?.presentUnknownErrorOccured()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(selectImageFromLibrary)
        alert.addAction(takePhoto)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func presentCamera() {
        DispatchQueue.main.async { [weak self] in
            let pickerVC = UIImagePickerController()
            pickerVC.sourceType = .camera
            pickerVC.allowsEditing = true
            pickerVC.delegate = self
            self?.present(pickerVC, animated: true)
        }
    }
    
    private func presentPhotosPicker() {
        var pickerConfig = PHPickerConfiguration()
        
        // Setting selectionLimit to 1 forces auto dismissal of the view immediately
        // upon image selection, so we'll set it
        // to 2 and then only import the first image later.
        pickerConfig.selectionLimit = 2
        pickerConfig.filter = .images
        pickerConfig.selection = .ordered
        
        let phPickerController = PHPickerViewController(configuration: pickerConfig)
        phPickerController.delegate = self
        
        present(phPickerController, animated: true)
    }
    
    private func alertCameraAccessNeeded() {
        let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!
        
        let alert = UIAlertController(
            title: "Camera Access Denied",
            message: "Camera access is required to take pictures for your Impulse and use the barcode scanning feature.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Allow Camera", style: .cancel, handler: { (alert) -> Void in
            UIApplication.shared.open(settingsAppURL, options: [:], completionHandler: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { [weak self] accessGranted in
            guard accessGranted == true else { return }
            self?.presentCamera()
        })
    }
    
    private func presentUnknownErrorOccured() {
        let alert = UIAlertController(
            title: "Unknown Error",
            message: "An unknown error occurred while trying to open the camera.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}

//
//  ImpulseDetailViewController.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 5/19/23.
//

import PhotosUI
import UIKit

class ImpulseDetailViewController: UIViewController, UINavigationControllerDelegate {
    var impulsesStateManager: ImpulsesStateManager! = nil
    var impulse: Impulse! = nil
    var viewShowsPendingImpulses: Bool = false
    
    private var scrollView: UIScrollView! = nil
    private var contentView: UIView! = nil
    
    private var impulsePropertiesStack: UIStackView! = nil
    
    private var image: UIImage! = nil
    private var imageView: UIImageView! = nil
    private var changeImageButton: UIButton!
    private var imageDidChange: Bool = false
    
    private var itemNameLabel: UILabel! = nil
    private var itemReasonNeededLabel: UILabel! = nil
    private var itemURLLabel: UILabel! = nil
    private var itemPriceLabel: UILabel! = nil
    
    private var itemNameTextField: ConsciousCartTextView! = nil
    private var itemReasonNeededTextField: ConsciousCartTextView! = nil
    private var itemURLTextField: ConsciousCartTextView! = nil
    private var itemPriceTextField: CurrencyTextField! = nil
    
    private var itemRemindDate: UIDatePicker! = nil
    private var itemReminderDateLabel: UILabel! = nil
    private var reminderDateStack: UIStackView! = nil
    
    private var categoryLabel: UILabel! = nil
    private var categoriesButton: ImpulseCategoryButton! = nil
    private var categoryStack: UIStackView! = nil
    private var selectedCategory: ImpulseCategory? = nil
    
    private var itemReminderCategoryStack: UIStackView! = nil
    
    private var finishImpulseButton: ConsciousCartButton! = nil
    
    private var canEditText: Bool = false
    private var activeView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.tintColor = .black
        
        navigationItem.title = impulse?.name ?? "Impulse"
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(enableImpulseEditing))
        
        configureScrollView()
        configureSubviewProperties()
        configureLayoutConstraints()
        
        if viewShowsPendingImpulses {
            configuredFinishImpulseButton()
        }
        
        view.keyboardLayoutGuide.followsUndockedKeyboard = true
        
        initializeHideKeyboardOnTap()
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddToCCViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddToCCViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let parent = self.parent {
            parent.navigationItem.rightBarButtonItems = self.navigationItem.rightBarButtonItems
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.contentSize = contentView.frame.size
        
    }
}

//MARK: - Configure Subviews
extension ImpulseDetailViewController {
    private func configureScrollView() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.bounces = true
        scrollView.alwaysBounceVertical = true
    }
    
    private func configureSubviewProperties() {
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        impulsePropertiesStack = UIStackView()
        impulsePropertiesStack.translatesAutoresizingMaskIntoConstraints = false
        impulsePropertiesStack.spacing = 5
        impulsePropertiesStack.axis = .vertical
        impulsePropertiesStack.alignment = .leading
        impulsePropertiesStack.distribution = .equalSpacing
        
        if let imageName = impulse.imageName {
            let imagePath = FileManager.documentsDirectory.appendingPathComponent(imageName, conformingTo: .png)
            image = UIImage(contentsOfFile: imagePath.path())
        } else {
            let largeConfig = UIImage.SymbolConfiguration(pointSize: 72, weight: .regular, scale: .default)
            image = UIImage(systemName: "cart.circle", withConfiguration: largeConfig)?.withTintColor(.black, renderingMode: .alwaysOriginal)
        }
        
        imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = view.bounds.width * 0.3 * 0.2
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.layer.masksToBounds = true
        
        changeImageButton = UIButton()
        changeImageButton.translatesAutoresizingMaskIntoConstraints = false
        changeImageButton.setTitle("Change Image", for: .normal)
        changeImageButton.titleLabel?.font = UIFont(name: "Nunito-Regular", size: 17)
        changeImageButton.titleLabel?.adjustsFontSizeToFitWidth = true
        changeImageButton.titleLabel?.minimumScaleFactor = 0.5
        changeImageButton.tintColor = .white
        changeImageButton.backgroundColor = UIColor(white: 0.05, alpha: 0.8)
        changeImageButton.addTarget(self, action: #selector(uploadImage), for: .touchUpInside)
        changeImageButton.layer.cornerRadius = view.bounds.width * 0.3 * 0.2
        changeImageButton.layer.borderWidth = 1
        changeImageButton.layer.borderColor = UIColor.black.cgColor
        changeImageButton.layer.masksToBounds = true
        changeImageButton.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        changeImageButton.isHidden = true
        
        itemNameLabel = UILabel()
        itemNameLabel.translatesAutoresizingMaskIntoConstraints = false
        itemNameLabel.text = "Item Name"
        itemNameLabel.font = UIFont.ccFont(textStyle: .footnote)
        itemNameLabel.textColor = .secondaryLabel
        itemNameLabel.textAlignment = .left
        
        itemNameTextField = ConsciousCartTextView()
        itemNameTextField.text = impulse.unwrappedName
        itemNameTextField.isEditable = false
        itemNameTextField.isSelectable = false
        itemNameTextField.tag = 1
        
        itemReasonNeededLabel = UILabel()
        itemReasonNeededLabel.translatesAutoresizingMaskIntoConstraints = false
        itemReasonNeededLabel.text = "Reason Needed"
        itemReasonNeededLabel.font = UIFont.ccFont(textStyle: .footnote)
        itemReasonNeededLabel.textColor = .secondaryLabel
        itemReasonNeededLabel.textAlignment = .left
        
        itemReasonNeededTextField = ConsciousCartTextView()
        itemReasonNeededTextField.text = impulse.unwrappedReasonNeeded
        itemReasonNeededTextField.isEditable = false
        itemReasonNeededTextField.isSelectable = false
        itemReasonNeededTextField.tag = 2
        
        itemURLLabel = UILabel()
        itemURLLabel.translatesAutoresizingMaskIntoConstraints = false
        itemURLLabel.text = "URL"
        itemURLLabel.font = UIFont.ccFont(textStyle: .footnote)
        itemURLLabel.textColor = .secondaryLabel
        itemURLLabel.textAlignment = .left
        
        itemURLTextField = ConsciousCartTextView()
        itemURLTextField.attributedText = createAttrURL(with: impulse.unwrappedURLString)
        itemURLTextField.isEditable = false
        itemURLTextField.isSelectable = true
        itemURLTextField.tag = 2
        itemURLTextField.autocorrectionType = .no
        itemURLTextField.autocapitalizationType = .none
        
        itemPriceLabel = UILabel()
        itemPriceLabel.translatesAutoresizingMaskIntoConstraints = false
        itemPriceLabel.text = "Item Price"
        itemPriceLabel.font = UIFont.ccFont(textStyle: .footnote)
        itemPriceLabel.textColor = .secondaryLabel
        itemPriceLabel.textAlignment = .left
        
        itemPriceTextField = CurrencyTextField()
        itemPriceTextField.placeholder = "0".asCurrency(locale: Locale.current)
        itemPriceTextField.text = String(impulse?.price ?? 0).asCurrency(locale: Locale.current)
        itemPriceTextField.delegate = self
        itemPriceTextField.keyboardType = .decimalPad
        itemPriceTextField.tag = 3
        
        itemReminderDateLabel = UILabel()
        itemReminderDateLabel.translatesAutoresizingMaskIntoConstraints = false
        itemReminderDateLabel.text = "Reminder Date"
        itemReminderDateLabel.font = UIFont.ccFont(textStyle: .footnote)
        itemReminderDateLabel.textColor = .secondaryLabel
        itemReminderDateLabel.textAlignment = .center
        
        itemRemindDate = UIDatePicker()
        itemRemindDate.translatesAutoresizingMaskIntoConstraints = false
        itemRemindDate.contentHorizontalAlignment = .center
        itemRemindDate.date = impulse?.unwrappedRemindDate ?? Date.now
        itemRemindDate.minimumDate = Date.now.addingTimeInterval(TimeInterval(86400))
        itemRemindDate.isEnabled = false
        
        reminderDateStack = UIStackView(arrangedSubviews: [itemReminderDateLabel, itemRemindDate])
        reminderDateStack.translatesAutoresizingMaskIntoConstraints = false
        reminderDateStack.axis = .vertical
        reminderDateStack.spacing = 5
        reminderDateStack.distribution = .equalSpacing
        reminderDateStack.alignment = .center
        
        categoryLabel = UILabel()
        categoryLabel.text = "Category"
        categoryLabel.font = UIFont.ccFont(textStyle: .footnote)
        categoryLabel.textColor = .secondaryLabel
        categoryLabel.textAlignment = .center
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        if let category = ImpulseCategory.allCases.first(where: { $0.categoryName == impulse.unwrappedCategory }) {
            selectedCategory = category
        }
        
        categoriesButton = ImpulseCategoryButton()
        categoriesButton.translatesAutoresizingMaskIntoConstraints = false
        if let category = selectedCategory {
            categoriesButton.setCategoryNameTo(category.categoryName)
            categoriesButton.setEmojiTo(category.categoryEmoji)
        }
        categoriesButton.addTarget(self, action: #selector(showCategoryPicker), for: .touchUpInside)
        categoriesButton.isEnabled = false
        
        categoryStack = UIStackView(arrangedSubviews: [categoryLabel, categoriesButton])
        categoryStack.translatesAutoresizingMaskIntoConstraints = false
        categoryStack.axis = .vertical
        categoryStack.spacing = 5
        categoryStack.distribution = .equalSpacing
        
        itemReminderCategoryStack = UIStackView(arrangedSubviews: [reminderDateStack, categoryStack])
        itemReminderCategoryStack.translatesAutoresizingMaskIntoConstraints = false
        itemReminderCategoryStack.axis = .horizontal
        itemReminderCategoryStack.distribution = .equalSpacing
        itemReminderCategoryStack.spacing = 5
        itemReminderCategoryStack.alignment = .center
        
        addSubViewsToView()
    }
    
    private func addSubViewsToView() {
        view.addSubview(scrollView)
        
        contentView.addSubview(imageView)
        contentView.addSubview(changeImageButton)
        
        impulsePropertiesStack.addArrangedSubview(itemNameLabel)
        impulsePropertiesStack.addArrangedSubview(itemNameTextField)
        impulsePropertiesStack.addArrangedSubview(itemReasonNeededLabel)
        impulsePropertiesStack.addArrangedSubview(itemReasonNeededTextField)
        impulsePropertiesStack.addArrangedSubview(itemURLLabel)
        impulsePropertiesStack.addArrangedSubview(itemURLTextField)
        impulsePropertiesStack.addArrangedSubview(itemPriceLabel)
        impulsePropertiesStack.addArrangedSubview(itemPriceTextField)
        impulsePropertiesStack.addArrangedSubview(itemReminderCategoryStack)
        
        contentView.addSubview(impulsePropertiesStack)
        
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
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 1.1),
            
            imageView.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3),
            
            changeImageButton.heightAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: 0.3),
            changeImageButton.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            changeImageButton.widthAnchor.constraint(equalTo: imageView.widthAnchor),
            changeImageButton.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            
            impulsePropertiesStack.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor),
            impulsePropertiesStack.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            impulsePropertiesStack.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            
            itemNameTextField.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            itemNameTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 31),
            
            itemReasonNeededTextField.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            itemReasonNeededTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 62),
            
            itemURLTextField.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            itemURLTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 31),
            
            itemPriceTextField.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            itemPriceTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 31),
            
            itemReminderDateLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 31),
            itemReminderDateLabel.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.4),
            
            itemRemindDate.heightAnchor.constraint(greaterThanOrEqualToConstant: 31),
            
            categoryLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 31),
            categoryLabel.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.4),
            
            categoriesButton.heightAnchor.constraint(equalToConstant: 100),
            
            itemReminderCategoryStack.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9)
        ])
    }
    
    private func configuredFinishImpulseButton() {
        finishImpulseButton = ConsciousCartButton()
        finishImpulseButton.setTitle("Finish this Impulse", for: .normal)
        finishImpulseButton.addTarget(self, action: #selector(finishImpulsePressed), for: .touchUpInside)
        
        contentView.addSubview(finishImpulseButton)
        
        NSLayoutConstraint.activate([
            finishImpulseButton.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            finishImpulseButton.heightAnchor.constraint(equalToConstant: 50),
            finishImpulseButton.topAnchor.constraint(equalTo: itemReminderCategoryStack.bottomAnchor, constant: 20),
            finishImpulseButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
    
    @objc private func finishImpulsePressed() {
        let impulseExpiredVC = ImpulseExpiredViewController()
        impulseExpiredVC.impulse = impulse
        impulseExpiredVC.impulsesStateManager = impulsesStateManager
        // this type of modal presentation forces the presentingViewController to call
        // viewWillAppear when the new one is dismissed.
        impulseExpiredVC.modalPresentationStyle = .fullScreen
        
        let modalController = UINavigationController(rootViewController: impulseExpiredVC)
        
        navigationController?.present(modalController, animated: true)
    }
    
    private func createAttrURL(with url: String) -> NSMutableAttributedString {
        let attrString = NSMutableAttributedString(string: url)
        attrString.addAttribute(.link, value: url, range: NSRange(location: 0, length: attrString.length))
        attrString.addAttribute(.font, value: UIFont.ccFont(textStyle: .body), range: NSRange(location: 0, length: attrString.length))
        return attrString
    }
    
    @objc private func showCategoryPicker() {
        let vc = CategoriesViewController()
        
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium()]
        }
        
        vc.categoryChangedDelegate = self
        vc.previouslySelectedCategory = selectedCategory
        
        present(vc, animated: true)
    }
}

//MARK: - Configure View Selectors
extension ImpulseDetailViewController {
    @objc private func enableImpulseEditing() {
        if canEditText == true {
            // If editing was enabled (true), and this function was called,
            // it means the user was done editing. This function checks
            // if there are updates to be made before performing an update.
            updateImpulse()
        }
        
        toggleFieldsEditable()
    }
    
    private func toggleFieldsEditable() {
        canEditText.toggle()
        
        changeImageButton.isHidden.toggle()
        
        itemNameTextField.isEditable.toggle()
        itemNameTextField.isSelectable = canEditText ? true : false
        
        itemReasonNeededTextField.isEditable.toggle()
        itemReasonNeededTextField.isSelectable = canEditText ? true : false
        
        itemRemindDate.isEnabled = canEditText ? true : false
        
        itemURLTextField.isEditable.toggle()
        
        categoriesButton.isEnabled.toggle()
        
        navigationItem.rightBarButtonItem?.title = canEditText ? "Done Editing" : "Edit"
    }
    
    @objc private func keyboardWillShow(_ notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        if let activeTextField = activeView {
            let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.view).maxY
            let topOfKeyboard = self.view.frame.height - keyboardSize.height
            
            if bottomOfTextField > topOfKeyboard {
                self.view.frame.origin.y = (bottomOfTextField - topOfKeyboard / 1.5) * -1
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    private func updateImpulse() {
        guard updatesPendingForImpulse() == true else { return }
        
        let updateImpulseAlert = UIAlertController(title: "Update Impulse", message: "Are you sure you want to update this Impulse? You cannot undo this action.", preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        let update = UIAlertAction(title: "Update", style: .default) { [weak self] _ in
            guard let impulse = self?.impulse else { return }
            guard let impulsesStateManager = self?.impulsesStateManager else { return }
            
            self?.stageUpdatesForImpulse()
            // this needs to be updated. should not modify impulses from a view controller
            impulsesStateManager.saveImpulses()
            impulsesStateManager.removePendingNotification(for: impulse)
            impulsesStateManager.setupNotification(for: impulse)
            
            let impulseUpdatedAlert = UIAlertController(title: "Impulse Updated", message: "The Impulse was updated successfully!", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default)
            
            impulseUpdatedAlert.addAction(ok)
            
            self?.present(impulseUpdatedAlert, animated: true)
        }
        
        updateImpulseAlert.addAction(cancel)
        updateImpulseAlert.addAction(update)
        present(updateImpulseAlert, animated: true)
    }
    
    private func updatesPendingForImpulse() -> Bool {
        if itemNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != impulse?.unwrappedName { return true }
        if itemPriceTextField.text?.asDoubleFromCurrency(locale: Locale.current) != impulse?.price { return true }
        if itemReasonNeededTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) != impulse?.unwrappedReasonNeeded { return true }
        if itemRemindDate.date != impulse?.unwrappedRemindDate { return true }
        if itemURLTextField.text.trimmingCharacters(in: .whitespacesAndNewlines) != impulse?.unwrappedURLString { return true }
        if categoriesButton.getCategoryName() != impulse.unwrappedCategory { return true }
        if imageDidChange { return true }
        
        return false
    }
    
    private func stageUpdatesForImpulse() {
        guard let impulse = impulse else { return }
        
        impulse.name = itemNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        impulse.price = itemPriceTextField.text?.asDoubleFromCurrency(locale: Locale.current) ?? 0
        impulse.reasonNeeded = itemReasonNeededTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        impulse.remindDate = itemRemindDate.date
        
        if let category = selectedCategory {
            impulse.category = category.categoryName
        }
        
        if let url = itemURLTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            impulse.url = url
            itemURLTextField.attributedText = createAttrURL(with: url)
        }
        
        if imageDidChange {
            deleteOldImageFor(impulse)
            
            if let newImageName = saveNewImpulseImage() {
                impulse.imageName = newImageName
            }
        }
    }
    
    func saveNewImpulseImage() -> String? {
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
    
    func deleteOldImageFor(_ impulse: Impulse) {
        if let oldImage = impulse.imageName {
            let imagePathName = FileManager.documentsDirectory.appendingPathComponent(oldImage, conformingTo: .png)
            do {
                try FileManager.default.removeItem(at: imagePathName)
            } catch {
                print("Could not delete Impulse's image: \(error.localizedDescription)")
            }
        }
    }
    
    @objc private func uploadImage() {
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
}

//MARK: - Configure UITextFieldDelegate
extension ImpulseDetailViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        guard canEditText == false else {
            itemRemindDate.isEnabled = false
            activeView = textField
            return true
        }
        
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        guard canEditText == false else {
            itemRemindDate.isEnabled = true
            return true
        }
        activeView = nil
        return false
    }
}

//MARK: - Configure UITextViewDelegate
extension ImpulseDetailViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if canEditText == true {
            activeView = textView
            return true
        }
        return false
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        activeView = nil
        return true
    }
}

//MARK: - CategoriesViewControllerDelegate
extension ImpulseDetailViewController: CategoriesViewControllerDelegate {
    func categoryDidChangeTo(_ category: ImpulseCategory) {
        print("category changed to: \(category.categoryName)")
        
        selectedCategory = category
        categoriesButton.setEmojiTo(category.categoryEmoji)
        categoriesButton.setCategoryNameTo(category.categoryName)
    }
}

//MARK: - UIImagePickerController Delegate
extension ImpulseDetailViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else { return }
        
        DispatchQueue.main.async {
            self.imageView.image = image
            self.imageDidChange = true
        }
    }
}

//MARK: - PHPickerViewController Delegate
extension ImpulseDetailViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        
        // Add the selected image to the view.
        guard let provider = results.first?.itemProvider else { return }
        
        if provider.canLoadObject(ofClass: UIImage.self) {
            provider.loadObject(ofClass: UIImage.self) { image, _ in
                DispatchQueue.main.async {
                    self.imageView.image = image as? UIImage
                    self.imageDidChange = true
                }
            }
        }
    }
}

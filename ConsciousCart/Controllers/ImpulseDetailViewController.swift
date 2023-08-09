//
//  ImpulseDetailViewController.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 5/19/23.
//

import UIKit

class ImpulseDetailViewController: UIViewController {
    var impulsesStateManager: ImpulsesStateManager! = nil
    var impulse: Impulse! = nil
    
    private var scrollView: UIScrollView! = nil
    private var contentView: UIView! = nil
    
    private var impulsePropertiesStack: UIStackView! = nil
    
    private var image: UIImage! = nil
    private var imageView: UIImageView! = nil
    
    private var itemNameLabel: UILabel! = nil
    private var itemReasonNeededLabel: UILabel! = nil
    private var itemURLLabel: UILabel! = nil
    private var itemPriceLabel: UILabel! = nil
    private var itemReminderDateLabel: UILabel! = nil
    
    private var itemNameTextField: ConsciousCartTextView! = nil
    private var itemReasonNeededTextField: ConsciousCartTextView! = nil
    private var itemURLTextField: ConsciousCartTextView! = nil
    private var itemPriceTextField: CurrencyTextField! = nil
    private var itemRemindDate: UIDatePicker! = nil
    
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
        
        view.keyboardLayoutGuide.followsUndockedKeyboard = true
        
        initializeHideKeyboardOnTap()
        
        NotificationCenter.default.addObserver(self, selector: #selector(AddToConsciousCartViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(AddToConsciousCartViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let parent = self.parent {
            parent.navigationItem.rightBarButtonItems = self.navigationItem.rightBarButtonItems
        }
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
            image = UIImage(systemName: "cart.circle", withConfiguration: largeConfig)
        }
        
        imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
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
//        itemURLTextField.text = impulse?.unwrappedReasonNeeded
        let attrString = NSMutableAttributedString(string: impulse.unwrappedURLString)
        attrString.addAttribute(.link, value: impulse.unwrappedURLString, range: NSRange(location: 0, length: attrString.length))
        attrString.addAttribute(.font, value: UIFont.ccFont(textStyle: .body), range: NSRange(location: 0, length: attrString.length))
        itemURLTextField.attributedText = attrString
        itemURLTextField.isEditable = false
        itemURLTextField.isSelectable = true
        itemURLTextField.tag = 2
        
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
        itemReminderDateLabel.textAlignment = .left
        
        itemRemindDate = UIDatePicker()
        itemRemindDate.translatesAutoresizingMaskIntoConstraints = false
        itemRemindDate.contentHorizontalAlignment = .center
        itemRemindDate.date = impulse?.unwrappedRemindDate ?? Date.now
        itemRemindDate.minimumDate = Date.now.addingTimeInterval(TimeInterval(86400))
        itemRemindDate.isEnabled = false
        
        addSubViewsToView()
    }
    
    private func addSubViewsToView() {
        view.addSubview(scrollView)
        
        contentView.addSubview(imageView)
        
        impulsePropertiesStack.addArrangedSubview(itemNameLabel)
        impulsePropertiesStack.addArrangedSubview(itemNameTextField)
        impulsePropertiesStack.addArrangedSubview(itemReasonNeededLabel)
        impulsePropertiesStack.addArrangedSubview(itemReasonNeededTextField)
        impulsePropertiesStack.addArrangedSubview(itemURLLabel)
        impulsePropertiesStack.addArrangedSubview(itemURLTextField)
        impulsePropertiesStack.addArrangedSubview(itemPriceLabel)
        impulsePropertiesStack.addArrangedSubview(itemPriceTextField)
        impulsePropertiesStack.addArrangedSubview(itemReminderDateLabel)
        impulsePropertiesStack.addArrangedSubview(itemRemindDate)
        
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
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            imageView.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3),
            imageView.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3),
            
            impulsePropertiesStack.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor),
            impulsePropertiesStack.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor),
            impulsePropertiesStack.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            
            itemNameTextField.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            itemNameTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 31),
            
            itemReasonNeededTextField.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            itemReasonNeededTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 62),
            
            itemURLTextField.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            itemURLTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 31),
            
            itemPriceTextField.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9),
            itemPriceTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 31),
            
            itemRemindDate.heightAnchor.constraint(greaterThanOrEqualToConstant: 31),
            itemRemindDate.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9)
        ])
    }
}

//MARK: - Configure View Functions
extension ImpulseDetailViewController {
    @objc private func enableImpulseEditing() {
        if canEditText == true {
            // If editing was enabled (true), and this function was called,
            // it means the user was done editing. This function checks
            // if there are updates to be made before performing an update.
            updateImpulse()
        }
        
        toggleTextFieldsEditable()
    }
    
    private func toggleTextFieldsEditable() {
        canEditText.toggle()
        
        itemNameTextField.isEditable.toggle()
        itemNameTextField.isSelectable = canEditText ? true : false
        
        itemReasonNeededTextField.isEditable.toggle()
        itemReasonNeededTextField.isSelectable = canEditText ? true : false
        
        itemRemindDate.isEnabled = canEditText ? true : false
        
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
            impulsesStateManager.updateImpulse()
            impulsesStateManager.updateNotification(for: impulse)
            
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
        
        return false
    }
    
    private func stageUpdatesForImpulse() {
        guard let impulse = impulse else { return }
        
        impulse.name = itemNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        impulse.price = itemPriceTextField.text?.asDoubleFromCurrency(locale: Locale.current) ?? 0
        impulse.reasonNeeded = itemReasonNeededTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        impulse.remindDate = itemRemindDate.date
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

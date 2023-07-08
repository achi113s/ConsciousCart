//
//  CurrencyTextField.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 7/7/23.
//

import UIKit

/// This subclass originally by NSExceptional on StackOverflow.
/// https://stackoverflow.com/a/60859491/21574991
class CurrencyTextField: UITextField {
    private var enteredNumbers: String = ""
    var locale: Locale = .current
    
    private var didBackspace = false
    
    private var textPadding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 5)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initCurrencyMode()
        configureAppearance()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initCurrencyMode()
        configureAppearance()
    }
    
    private func initCurrencyMode() {
        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }
    
    override func deleteBackward() {
        // Changed this line.
        let _ = enteredNumbers.popLast()
        text = enteredNumbers.asCurrency(locale: locale)
        // Call super so that the .editingChanged event gets fired, but we need to handle it differently, so we set the `didBackspace` flag first
        didBackspace = true
        super.deleteBackward()
    }
    
    @objc func editingChanged() {
        defer {
            didBackspace = false
            text = enteredNumbers.asCurrency(locale: locale)
        }
        
        guard didBackspace == false else { return }
        
        if let lastEnteredCharacter = text?.last, lastEnteredCharacter.isNumber {
            enteredNumbers.append(lastEnteredCharacter)
        }
    }
}

// My code.
extension CurrencyTextField {
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    private func configureAppearance() {
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .secondarySystemBackground
        
        font = UIFont(name: "Nunito-Regular", size: 17)
        
        self.layer.cornerRadius = 8
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1
        
        self.inputAccessoryView = toolBar()
    }
    
    private func toolBar() -> UIToolbar{
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.barTintColor = UIColor.systemBackground
        
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(onClickCancelButton))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(onClickDoneButton))
        
        doneButton.tintColor = .black
        cancelButton.tintColor = .black
        
        toolBar.setItems([cancelButton, space, doneButton], animated: false)
        
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        return toolBar
    }
    
    @objc func onClickDoneButton() {
        self.endEditing(true)
    }
    
    @objc func onClickCancelButton() {
        self.endEditing(true)
    }
}

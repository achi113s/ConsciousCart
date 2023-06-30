//
//  ProfileViewController.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 4/27/23.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var completedImpulses = [Impulse]()
    var impulses = [Impulse]()
    
    private let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var scoreLabel: UILabel!
    private var titleLabel: UILabel!
    private var differentiateWithoutColorIndicator: UIImageView!
    
    private var amountSaved: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
//        (impulses, completedImpulses) = ImpulseDataManager.loadImpulses(moc: moc)
        
        amountSaved = completedImpulses.reduce(0.0) { $0 + $1.amountSaved }
        
        setSubviewProperties()
        addSubviewsToView()
        setLayoutConstraints()
    }
    
    func setSubviewProperties() {
        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Your ConsciousCart score is"
        titleLabel.font = UIFont.ccFont(textStyle: .title)
        titleLabel.textAlignment = .center
        
        scoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.text = Utils.formatNumberAsCurrency(NSNumber(value: amountSaved))
        scoreLabel.numberOfLines = 1
        scoreLabel.adjustsFontSizeToFitWidth = true
        scoreLabel.font = UIFont.ccFont(textStyle: .title)
        scoreLabel.textColor = .green
        
        let arrowConfig = UIImage.SymbolConfiguration(pointSize: scoreLabel.font.pointSize,
                                                      weight: .regular, scale: .default)
        let arrowImage = UIImage(systemName: amountSaved >= 0.0 ? "arrow.up" : "arrow.down",
                                 withConfiguration: arrowConfig)
        differentiateWithoutColorIndicator = UIImageView(image: arrowImage)
        differentiateWithoutColorIndicator.translatesAutoresizingMaskIntoConstraints = false
        differentiateWithoutColorIndicator.isHidden = UIAccessibility.shouldDifferentiateWithoutColor
    }
    
    func addSubviewsToView() {
        view.addSubview(titleLabel)
        view.addSubview(scoreLabel)
        view.addSubview(differentiateWithoutColorIndicator)
    }
    
    func setLayoutConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            
            scoreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scoreLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: -16),
            
            differentiateWithoutColorIndicator.centerYAnchor.constraint(equalTo: scoreLabel.centerYAnchor),
            differentiateWithoutColorIndicator.leftAnchor.constraint(equalTo: scoreLabel.rightAnchor, constant: 8)
        ])
    }
    
    
}

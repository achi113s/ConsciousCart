//
//  ProfileViewController.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 8/4/23.
//

import SwiftUI
import UIKit

class ProfileViewController: UIViewController {
    private var impulsesStateManager: ImpulsesStateManager! = nil
    private var userLevel: UserLevel! = nil
    
    private var scrollView: UIScrollView! = nil
    private var contentView: UIView! = nil
    
    private var coinHostView: UIView! = nil
    private let coinViewSize: CGFloat = 125
    
    private var messageLabel: UILabel! = nil
    private var scoreLabel: UILabel! = nil
    
    private var myImpulsesSectionLabel: SectionUILabel! = nil
    private var optionsStackView: UIStackView! = nil
    private var activeImpulsesButton: ImpulseOptionButton! = nil
    private var pendingImpulsesButton: ImpulseOptionButton! = nil
    private var completedImpulsesButton: ImpulseOptionButton! = nil
    
    private var score: Double {
        impulsesStateManager.userStats?.totalAmountSaved ?? 0.0
    }
    
    private var userName: String {
        impulsesStateManager.userStats?.userName ?? "NoName"
    }
    
    private var scoreMessage: String {
        if score == 0.0 { return "Either you haven't spent any money, or you broke even..." }
        
        return score < 0.0 ? "Yikes \(userName), you've spent" : "Nice job \(userName), you've saved"
    }
    
    convenience init(impulsesStateManager: ImpulsesStateManager) {
        self.init(nibName: nil, bundle: nil)
        self.impulsesStateManager = impulsesStateManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "DefaultBackground")
        
        userLevel = impulsesStateManager.getUserLevel()
        
        configureScrollView()
        configureSubviews()
        setupCoinView()
        addSubviewsToView()
        configureLayoutConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateOnAppear()
    }
    
    private func redOrGreen(for savedAmount: Double) -> UIColor {
        savedAmount >= 0.0 ? .systemGreen : .systemRed
    }
}

//MARK: - Configure Subviews
extension ProfileViewController {
    private func configureScrollView() {
        scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.bounces = true
        scrollView.alwaysBounceVertical = true
    }
    
    private func setupCoinView() {
        let coinView = CoinView(coinSize: coinViewSize, userLevel: userLevel)
        let hostingViewController = UIHostingController(rootView: coinView)
        
        self.addChild(hostingViewController)
        
        if hostingViewController.view != nil {
            coinHostView = hostingViewController.view
            coinHostView.frame = CGRect(x: 0, y: 0, width: coinViewSize, height: coinViewSize)
            coinHostView.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(coinHostView)
        }
    }
    
    private func configureSubviews() {
        contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.text = scoreMessage
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.ccFont(textStyle: .bold, fontSize: 18)
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.text = String("\(score)").asCurrency(locale: Locale.current)
        scoreLabel.textAlignment = .center
        scoreLabel.font = UIFont.ccFont(textStyle: .bold, fontSize: 42)
        scoreLabel.adjustsFontSizeToFitWidth = true
        scoreLabel.minimumScaleFactor = 0.5
        
        myImpulsesSectionLabel = SectionUILabel()
        myImpulsesSectionLabel.translatesAutoresizingMaskIntoConstraints = false
        myImpulsesSectionLabel.text = "MY IMPULSES"
        myImpulsesSectionLabel.textAlignment = .left
        
        activeImpulsesButton = ImpulseOptionButton(frame: CGRect(x: 0, y: 0, width: 10, height: 10), filterType: .active)
        activeImpulsesButton.setLabelText("🛍️  Active Impulses")
        activeImpulsesButton.addTarget(self, action: #selector(goToImpulses), for: .touchUpInside)
        
        pendingImpulsesButton = ImpulseOptionButton(frame: CGRect(x: 0, y: 0, width: 10, height: 10), filterType: .pending)
        pendingImpulsesButton.setLabelText("⏱️  Pending Impulses")
        pendingImpulsesButton.addTarget(self, action: #selector(goToImpulses), for: .touchUpInside)
        
        completedImpulsesButton = ImpulseOptionButton(frame: CGRect(x: 0, y: 0, width: 10, height: 10), filterType: .completed)
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "checkmark.seal")?.withTintColor(.systemGreen)
        let fullString = NSMutableAttributedString(string: "")
        fullString.append(NSAttributedString(attachment: imageAttachment))
        fullString.append(NSAttributedString(string: "  Completed Impulses"))
        completedImpulsesButton.textLabel.attributedText = fullString
        completedImpulsesButton.addTarget(self, action: #selector(goToImpulses), for: .touchUpInside)
        
        optionsStackView = UIStackView()
        optionsStackView.axis = .vertical
        optionsStackView.spacing = 10
        optionsStackView.translatesAutoresizingMaskIntoConstraints = false
        optionsStackView.alignment = .leading
        optionsStackView.distribution = .equalSpacing
    }
    
    private func addSubviewsToView() {
        view.addSubview(scrollView)
        
        contentView.addSubview(messageLabel)
        contentView.addSubview(scoreLabel)
        
        contentView.addSubview(myImpulsesSectionLabel)
        
        optionsStackView.addArrangedSubview(myImpulsesSectionLabel)
        optionsStackView.addArrangedSubview(activeImpulsesButton)
        optionsStackView.addArrangedSubview(pendingImpulsesButton)
        optionsStackView.addArrangedSubview(completedImpulsesButton)
        
        contentView.addSubview(optionsStackView)
        
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
            
            coinHostView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 5),
            coinHostView.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor),
            
            messageLabel.topAnchor.constraint(equalTo: coinHostView.bottomAnchor, constant: 10),
            messageLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            scoreLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor),
            scoreLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            scoreLabel.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.6),
            
            myImpulsesSectionLabel.widthAnchor.constraint(equalToConstant: 100),
            
            activeImpulsesButton.heightAnchor.constraint(equalToConstant: 40),
            activeImpulsesButton.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: 16),
            activeImpulsesButton.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor, constant: -16),
            
            pendingImpulsesButton.heightAnchor.constraint(equalToConstant: 40),
            pendingImpulsesButton.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: 16),
            pendingImpulsesButton.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor, constant: -16),
            
            completedImpulsesButton.heightAnchor.constraint(equalToConstant: 40),
            completedImpulsesButton.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: 16),
            completedImpulsesButton.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor, constant: -16),
            
            optionsStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            optionsStackView.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 20)
        ])
    }
    
    private func updateOnAppear() {
        userLevel = impulsesStateManager.getUserLevel()
        messageLabel.textColor = redOrGreen(for: score)
        scoreLabel.textColor = redOrGreen(for: score)
    }
}

extension ProfileViewController {
    @objc private func goToImpulses(_ sender: ImpulseOptionButton) {
        switch sender.filterType {
        case .active:
            let activeVC = ImpulsesCollectionViewController(impulsesStateManager: impulsesStateManager, impulseOption: .active)
            self.navigationController?.pushViewController(activeVC, animated: true)
        case .pending:
            let pendingVC = ImpulsesCollectionViewController(impulsesStateManager: impulsesStateManager, impulseOption: .pending)
            self.navigationController?.pushViewController(pendingVC, animated: true)
        case .completed:
            let completedVC = ImpulsesCollectionViewController(impulsesStateManager: impulsesStateManager, impulseOption: .completed)
            self.navigationController?.pushViewController(completedVC, animated: true)
        default:
            print("none")
        }
    }
}

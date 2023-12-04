//
//  OnboardingViewController.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 8/5/23.
//

import UIKit

class OnboardingViewController: UIPageViewController {
    var impulsesStateManager: ImpulsesStateManager! = nil
    
    private var pages = [UIViewController]()
    private let initialPage = 0
    
//    private let skipButton = UIButton()
    private let nextButton = UIButton()
    private let pageControl = UIPageControl()
    
    private var pageControlBottomAnchor: NSLayoutConstraint?
    private var skipButtonTopAnchor: NSLayoutConstraint?
    private var nextButtonTopAnchor: NSLayoutConstraint?
    private var nextButtonBottomAnchor: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupPageController()
        
        configureButtons()
        addSubviews()
        configureLayoutConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else { return }
            
            if let page1 = self.pages.first as? WelcomeViewController {
                page1.view.layer.opacity = 1.0
            }
        }
    }
    
    private func setupPageController() {
        delegate = self
        dataSource = self
        
        let page1 = WelcomeViewController()
        page1.view.layer.opacity = 0
        
        let page2Title = "Impulses"
        let page2Subtitle = """
        Impulses are your would-be purchases. \
        \nTap on the Add to Cart button\non the home page \
        to add a new one. \
        \nSet a reminder date and we'll ask you about it later! \
        \nIf you buy it before then, you lose points. If you don't, you score!
        """
        let page2 = SecondOnboardingView(title: page2Title, subtitle: page2Subtitle, imageName: "impulseExample")
        
        let page3 = UsernameOnboardingViewController()
        page3.impulsesStateManager = impulsesStateManager
        
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        
        setViewControllers([pages[initialPage]], direction: .forward, animated: true)
    }
    
    private func configureButtons() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .systemGray2
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = initialPage
//        
//        skipButton.translatesAutoresizingMaskIntoConstraints = false
//        skipButton.setTitleColor(UIColor(named: "ExodusFruit")?.darker(), for: .highlighted)
//        skipButton.setTitleColor(UIColor(named: "ExodusFruit"), for: .normal)
//        skipButton.setTitle("Skip", for: .normal)
//        skipButton.titleLabel?.font = UIFont.ccFont(textStyle: .bold, fontSize: 17)
//        skipButton.addTarget(self, action: #selector(skipTapped), for: .primaryActionTriggered)
        
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setTitleColor(UIColor(named: "ExodusFruit")?.darker(), for: .highlighted)
        nextButton.setTitleColor(UIColor(named: "ExodusFruit"), for: .normal)
        nextButton.setTitle("Next", for: .normal)
        nextButton.titleLabel?.font = UIFont.ccFont(textStyle: .bold, fontSize: 17)
        nextButton.addTarget(self, action: #selector(nextTapped), for: .primaryActionTriggered)
    }
    
    private func addSubviews() {
//        view.addSubview(pageControl)
//        view.addSubview(skipButton)
        view.addSubview(nextButton)
    }
    
    private func configureLayoutConstraints() {
        NSLayoutConstraint.activate([
//            pageControl.widthAnchor.constraint(equalTo: view.widthAnchor),
//            pageControl.heightAnchor.constraint(equalToConstant: 20),
//            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            
//            skipButton.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            
            
//            view.trailingAnchor.constraint(equalToSystemSpacingAfter: nextButton.trailingAnchor, multiplier: 2),
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // Activate these outside of the block above so we have a reference to them to animate.
//        pageControlBottomAnchor = view.bottomAnchor.constraint(equalToSystemSpacingBelow: pageControl.bottomAnchor, multiplier: 2)
//        skipButtonTopAnchor = skipButton.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2)
//        nextButtonTopAnchor = nextButton.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2)
        nextButtonBottomAnchor = nextButton.centerYAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.bottomAnchor, multiplier: -2)
//        pageControlBottomAnchor?.isActive = true
//        skipButtonTopAnchor?.isActive = true
//        nextButtonTopAnchor?.isActive = true
        nextButtonBottomAnchor?.isActive = true
    }
    
//    @objc private func pageControlTapped(_ sender: UIPageControl) {
//        setViewControllers([pages[sender.currentPage]], direction: .forward, animated: true, completion: nil)
//        animateControlsIfNeeded()
//    }
    
//    @objc private func skipTapped(_ sender: UIButton) {
//        let lastPage = pages.count - 1
//        pageControl.currentPage = lastPage
//        
//        goToSpecificPage(index: lastPage, ofViewControllers: pages)
//        animateControlsIfNeeded()
//    }
    
    @objc private func nextTapped(_ sender: UIButton) {
        pageControl.currentPage += 1
        goToNextPage()
//        animateControlsIfNeeded()
    }
}


//MARK: - UIPageViewControllerDataSource
extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // What is the page before the one we're currently on?
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        
        if currentIndex == 0 {
            return nil               // dont allow scrolling left on first page
        } else {
            return pages[currentIndex - 1]  // go to previous
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        // What is the page after the one we're currently on?
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil }
        
        if currentIndex < pages.count - 1 {
            return pages[currentIndex + 1]
        } else {
            return pages.first
        }
    }
}


//MARK: - UIPageViewControllerDelegate
extension OnboardingViewController: UIPageViewControllerDelegate {
    // What do to after the page has changed.
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewControllers = pageViewController.viewControllers else { return }
        guard let currentIndex = pages.firstIndex(of: viewControllers[0]) else { return }
        
        pageControl.currentPage = currentIndex
//        animateControlsIfNeeded()
    }
    
//    private func animateControlsIfNeeded() {
//        let lastPage = pageControl.currentPage == pages.count - 1
//        
//        if lastPage {
//            hideControls()
//        } else {
//            showControls()
//        }
//        
//        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: [.curveLinear], animations: {
//            self.view.layoutIfNeeded()
//        }, completion: nil)
//    }
    
//    private func hideControls() {
//        pageControlBottomAnchor?.constant = -150
//        skipButtonTopAnchor?.constant = -150
//        nextButtonTopAnchor?.constant = -150
//    }
    
//    private func showControls() {
//        pageControlBottomAnchor?.constant = 16
//        skipButtonTopAnchor?.constant = 16
//        nextButtonTopAnchor?.constant = 16
//    }
}

//MARK: - Extensions
extension OnboardingViewController {
    func goToNextPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        guard let currentPage = viewControllers?[0] else { return }
        guard let nextPage = dataSource?.pageViewController(self, viewControllerAfter: currentPage) else { return }
        
        setViewControllers([nextPage], direction: .forward, animated: animated, completion: completion)
    }
    
    func goToPreviousPage(animated: Bool = true, completion: ((Bool) -> Void)? = nil) {
        guard let currentPage = viewControllers?[0] else { return }
        guard let prevPage = dataSource?.pageViewController(self, viewControllerBefore: currentPage) else { return }
        
        setViewControllers([prevPage], direction: .forward, animated: animated, completion: completion)
    }
    
    func goToSpecificPage(index: Int, ofViewControllers pages: [UIViewController]) {
        setViewControllers([pages[index]], direction: .forward, animated: true, completion: nil)
    }
}

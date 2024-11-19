//
//  OnboardingVC.swift
//  ToDoList
//
//  Created by Murat Çimen on 19.11.2024.
//

import UIKit
import SnapKit

class OnboardingVC: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    let pages: [OnboardingPage] = [
        OnboardingPage(title: "Welcome", description: "Discover the app's features!", imageName: "onboarding1"),
        OnboardingPage(title: "Track", description: "Keep track of your progress.", imageName: "onboarding2"),
        OnboardingPage(title: "Achieve", description: "Achieve your goals effortlessly.", imageName: "onboarding3")
    ]
    
    var currentIndex: Int = 0
    let continueButton = UIButton()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.bringSubviewToFront(continueButton) 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        setupInitialPage()
        setupContinueButton()
    }
    
    private func setupInitialPage() {
        if let firstVC = createPageViewController(for: 0) {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    private func setupContinueButton() {
        view.addSubview(continueButton)
        continueButton.setTitle("Continue", for: .normal)
        continueButton.backgroundColor = UIColor(hex: "FFAF5F")
        continueButton.layer.cornerRadius = 8
        continueButton.setTitleColor(.white, for: .normal)
        continueButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        continueButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(56)
        }
        
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
    }
    
    @objc private func continueButtonTapped() {
        if currentIndex < pages.count - 1 {
            currentIndex += 1
            if let nextVC = createPageViewController(for: currentIndex) {
                setViewControllers([nextVC], direction: .forward, animated: false, completion: nil)
            }
        } else {
            finishOnboarding()
        }
    }
    
    private func finishOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        
        guard let window = UIApplication.shared.windows.first else { return }
        let tabBarVC = TabBarViewController()
        window.rootViewController = tabBarVC
        UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }
    
    private func createPageViewController(for index: Int) -> UIViewController? {
        guard index >= 0 && index < pages.count else { return nil }
        let pageData = pages[index]
        let pageVC = SingleOnboardingVC()
        pageVC.pageData = pageData
        pageVC.pageIndex = index
        return pageVC
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let onboardingVC = viewController as? SingleOnboardingVC,
              let index = onboardingVC.pageIndex else { return nil }
        return createPageViewController(for: index - 1)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let onboardingVC = viewController as? SingleOnboardingVC,
              let index = onboardingVC.pageIndex else { return nil }
        return createPageViewController(for: index + 1)
    }
    
}

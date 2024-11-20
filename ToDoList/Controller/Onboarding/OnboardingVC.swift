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
        OnboardingPage(title: "Welcome", description: "Discover the app's features!", imageName: "Onboarding"),
        OnboardingPage(title: "Track", description: "Keep track of your progress.", imageName: "Onboarding"),
        OnboardingPage(title: "Achieve", description: "Achieve your goals effortlessly.", imageName: "Onboarding")
    ]
    
    var currentIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        
        setupInitialPage()
    }
    
    private func setupInitialPage() {
        if let firstVC = createPageViewController(for: 0) {
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    private func createPageViewController(for index: Int) -> UIViewController? {
        guard index >= 0 && index < pages.count else { return nil }
        let pageData = pages[index]
        let pageVC = SingleOnboardingVC()
        pageVC.pageData = pageData
        pageVC.pageIndex = index
        
        
        pageVC.continueCallback = { [weak self] in
            guard let self = self else { return }
            self.goToNextPage()
        }
        
        return pageVC
    }
    
    private func goToNextPage() {
        if currentIndex < pages.count - 1 {
            currentIndex += 1
            if let nextVC = createPageViewController(for: currentIndex) {
                setViewControllers([nextVC], direction: .forward, animated: true, completion: nil)
            }
        } else {
            finishOnboarding()
        }
    }
    
    private func finishOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        
        guard let window = UIApplication.shared.windows.first else {
            print("No window found")
            return
        }
        
        let tabbar = TabBarViewController()
        let navigationController = UINavigationController(rootViewController: tabbar)
        window.rootViewController = navigationController
        
        print("TabBarViewController set as rootViewController")
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

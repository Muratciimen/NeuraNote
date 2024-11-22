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
        OnboardingPage(title: "Plan. Prioritize. Succeed!", description: "With AI-powered task management, easily plan your day, set priorities, and stay on top of your goals.", imageName: "onboarding1"),
        
        OnboardingPage(title: "Find Your Perfect Rhythm", description: "Personalized to-do lists and smart suggestions tailored to your needs—boost your productivity effortlessly.", imageName: "onboarding2"),
        
        OnboardingPage(title: "Less Stress, More Productivity!", description: "Let AI help you organize your tasks and achieve more with less effort. Stay ahead, every day!", imageName: "onboarding3")
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
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed,
           let visibleVC = viewControllers?.first as? SingleOnboardingVC,
           let index = visibleVC.pageIndex {
            currentIndex = index
        }
    }
}

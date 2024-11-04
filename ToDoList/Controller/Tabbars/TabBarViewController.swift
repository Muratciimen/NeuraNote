//
//  TabBarViewController.swift
//  ToDoList
//
//  Created by Murat Çimen on 16.10.2024.
//
import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        let homeViewController = HomeVC()
        homeViewController.tabBarItem = UITabBarItem(
            title: "Home",
            image: UIImage(named: "Home"),
            tag: 1
        )
        
        let calenderViewController = CalenderVC()
        calenderViewController.tabBarItem = UITabBarItem(
            title: "Calendar",
            image: UIImage(named: "Calendar"),
            tag: 2
        )
        
        let settingsViewController = SettingVC()
        settingsViewController.tabBarItem = UITabBarItem(
            title: "Settings",
            image: UIImage(named: "Settings"),
            tag: 3
        )
        
        viewControllers = [homeViewController, calenderViewController, settingsViewController]
        
        tabBar.backgroundColor = UIColor(hex: "#FEFEFE")
        
        tabBar.tintColor = UIColor(hex: "#FFAF5F")
        tabBar.unselectedItemTintColor = UIColor(hex: "#72757F")
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -1)
        tabBar.layer.shadowRadius = 6
        tabBar.layer.shadowOpacity = 0.1
        tabBar.layer.masksToBounds = false
    }
}

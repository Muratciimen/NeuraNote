//
//  SplashVC.swift
//  ToDoList
//
//  Created by Murat Çimen on 16.10.2024.
//

import UIKit
import SnapKit

class SplashVC: UIViewController {

    let appIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "appIcon")
        imageView.layer.cornerRadius = 12
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let loadingBar: UIProgressView = {
        let progressBar = UIProgressView(progressViewStyle: .default)
        progressBar.progressTintColor = UIColor(hex: "#4a4949")
        progressBar.trackTintColor = UIColor.lightGray
        progressBar.setProgress(0.0, animated: true)
        return progressBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(hex: "#EEEEEE")

        setupUI()
        startLoadingAnimation()
    }
    func setupUI() {
      
        view.addSubview(appIconImageView)
        
        appIconImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        view.addSubview(loadingBar)
        
        loadingBar.snp.makeConstraints { make in
            make.top.equalTo(appIconImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
        }
    }
    
    func startLoadingAnimation() {
        var progress: Float = 0.0
        Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { timer in
            progress += 0.01
            self.loadingBar.setProgress(progress, animated: true)
            
            if progress >= 1.0 {
                timer.invalidate()
                self.moveToNextScreen()
            }
        }
    }
    
    func moveToNextScreen() {
        let mainVC = TabBarViewController()
        mainVC.modalTransitionStyle = .crossDissolve
        mainVC.modalPresentationStyle = .fullScreen
        present(mainVC, animated: true, completion: nil)
    }
}

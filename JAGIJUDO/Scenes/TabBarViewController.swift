//
//  TabBarViewController.swift
//  JAGIJUDO
//
//  Created by 박준하 on 7/9/24.
//

import UIKit
import Then

final class TabBarViewController: UITabBarController {
    
    let translateViewController = TranslateViewController().then {
        $0.tabBarItem = UITabBarItem(
            title: "번역",
            image: UIImage(systemName: "mic"),
            selectedImage: UIImage(systemName: "mic.fill")
        )
    }
    
    let bookmarkViewController = UIViewController().then {
        $0.tabBarItem = UITabBarItem(
            title: "즐겨찾기",
            image: UIImage(systemName: "star"),
            selectedImage: UIImage(systemName: "star.fill")
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewControllers = [
            translateViewController,
            bookmarkViewController
        ]
        
        self.tabBar.backgroundColor = .systemBackground
    }
}

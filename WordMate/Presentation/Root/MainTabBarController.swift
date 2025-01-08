//
//  MainTabBarController.swift
//  WordMate
//
//  Created by KangMingyo on 1/8/25.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewController()
        configureTabBarAppearance()
    }
    
    // MARK: - Helpers
    
    func configureViewController() {
        let group = GroupListViewController(viewModel: GroupListViewModel(realmManager: RealmManager()))
        let groupNav = createNavigationController(
            title: "단어장",
            image: UIImage(systemName: "book.fill"),
            tag: 0,
            rootViewController: group
        )

        let learning = LearningViewController(viewModel: LearningViewModel())
        let learningNav = createNavigationController(
            title: "학습",
            image: UIImage(systemName: "pencil.circle.fill"),
            tag: 1,
            rootViewController: learning
        )
        
        viewControllers = [groupNav, learningNav]
    }
    
    func createNavigationController(title: String, image: UIImage?, tag: Int, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem = UITabBarItem(title: title, image: image, tag: tag)
        return nav
    }
    
    private func configureTabBarAppearance() {
        tabBar.backgroundColor = .systemBackground
        tabBar.tintColor = .primaryOrange
        tabBar.unselectedItemTintColor = .systemGray3
        tabBar.layer.borderColor = UIColor.lightGray.cgColor
        tabBar.layer.borderWidth = 0.5
        tabBar.clipsToBounds = true
    }
}

//let settingsVC = SettingsViewController()
//settingsVC.tabBarItem = UITabBarItem(title: "설정", image: UIImage(systemName: "gearshape.fill"), tag: 2)

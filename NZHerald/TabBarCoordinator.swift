//
//  TabBarCoordinator.swift
//  NZHerald
//
//  Created by Will Townsend on 9/05/16.
//
//

import UIKit

class TabBarCoordinator: Coordinator {
    
    let services: Services
    var childCoordinators: [Coordinator] = []
    
    lazy var tabBarController: UITabBarController = {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [
            self.articleIndexCollectionNavigationController,
            self.latestArticlesNavigationController
        ]
        return tabBarController
    }()
    
    lazy var articleIndexCollectionNavigationController: UINavigationController = {
        let articleIndexCollectionNavigationController = UINavigationController(rootViewController: self.articleIndexCollectionViewController)
        return articleIndexCollectionNavigationController
    }()
    
    lazy var articleIndexCollectionViewController: ArticleIndexCollectionViewController = {
        let articleIndexCollectionViewController = ArticleIndexCollectionViewController(services: self.services)
        articleIndexCollectionViewController.delegate = self
        return articleIndexCollectionViewController
    }()
    
    lazy var latestArticlesNavigationController: UINavigationController = {
        let latestArticlesNavigationController = UINavigationController(rootViewController: self.latestArticlesViewController)
        return latestArticlesNavigationController
    }()
    
    lazy var latestArticlesViewController: ArticleIndexCollectionViewController = {
        let latestArticlesViewController = ArticleIndexCollectionViewController(services: self.services)
        latestArticlesViewController.delegate = self
        return latestArticlesViewController
    }()
    
    init(services: Services) {
        self.services = services
    }
    
    deinit {
        print("deinit: \(#file)")
    }
    
    func start() {
        // Nothing to do as this is expected to be used by the AppCoordinator
    }
    
}

extension TabBarCoordinator: ArticleIndexCollectionViewControllerDelegate {
    
    func articleIndexCollectionViewControllerDidTapArticle(viewController: ArticleIndexCollectionViewController, article: Article) {
        print("Did tap article: \(article.headline)")
        
        let articleCoordinator = ArticleCoordinator(services: self.services, rootViewController: self.tabBarController, article: article)
        articleCoordinator.delegate = self
        articleCoordinator.start()
        self.childCoordinators.append(articleCoordinator)
    }
    
}

extension TabBarCoordinator: ArticleViewControllerDelegate {
    
    func articleViewControllerTappedClose(articleViewController: ArticleViewController) {
        print("cloasing")
        articleViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

extension TabBarCoordinator: ArticleCoordinatorDelegate {
    
    func articleCoordinatorDidFinish(articleCoordinator: ArticleCoordinator) {
        
        articleCoordinator.navigationController.dismissViewControllerAnimated(true, completion: nil)
        self.removeChildCoordinator(articleCoordinator)
        
    }
    
}
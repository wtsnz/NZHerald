//
//  ArticleCoordinator.swift
//  NZHerald
//
//  Created by Will Townsend on 9/05/16.
//
//

import UIKit

protocol ArticleCoordinatorDelegate: class {
    func articleCoordinatorDidFinish(articleCoordinator: ArticleCoordinator)
}

class ArticleCoordinator: Coordinator {
    
    let services: Services
    var childCoordinators: [Coordinator] = []
    let rootViewController: UIViewController
    weak var delegate: ArticleCoordinatorDelegate? = nil
    let article: Article
    
    lazy var navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.hidesBarsOnSwipe = true
        navigationController.hidesBarsOnTap = true
        return navigationController
    }()

//    lazy var articleViewController: ArticleViewController = {
//        let articleViewController = ArticleViewController(services: self.services)
//        articleViewController.delegate = self
//        return articleViewController
//    }()
    
    init(services: Services, rootViewController: UIViewController, article: Article) {
        self.rootViewController = rootViewController
        self.services = services
        self.article = article
    }
    
    deinit {
        print("deinit: \(#file)")
    }
    
    func start() {
        let articleViewController = ArticleViewController(services: self.services, article: self.article)
        articleViewController.delegate = self
        self.navigationController.viewControllers = [articleViewController]
        self.rootViewController.presentViewController(self.navigationController, animated: true, completion: nil)
    }
    
}

extension ArticleCoordinator: ArticleViewControllerDelegate {
    
    func articleViewControllerTappedClose(articleViewController: ArticleViewController) {
        self.delegate?.articleCoordinatorDidFinish(self)
    }
    
}

//
//  AppCoordinator.swift
//  NZHerald
//
//  Created by Will Townsend on 9/05/16.
//
//

import UIKit

final class AppCoordinator: Coordinator {
    
    let window: UIWindow
    
    let services: Services
    var childCoordinators: [Coordinator] = []
    
    init(window: UIWindow, services: Services) {
        self.services = services
        
        self.window = window
        self.window.backgroundColor = UIColor.whiteColor()
        self.window.makeKeyAndVisible()
    }
    
    deinit {
        print("deinit: \(#file)")
    }
    
    func start() {
        
        let tabBarCoordinator = TabBarCoordinator(services: self.services)
        tabBarCoordinator.start()
        self.window.rootViewController = tabBarCoordinator.tabBarController
        self.childCoordinators.append(tabBarCoordinator)
        
    }
    
}

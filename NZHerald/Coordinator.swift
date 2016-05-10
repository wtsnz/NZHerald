//
//  Coordinator.swift
//  NZHerald
//
//  Created by Will Townsend on 6/05/16.
//
//

import Foundation
import UIKit

protocol Coordinator: class {
    
    var services: Services { get }
    var childCoordinators: [Coordinator] { get set }
    
    func start()
    func removeChildCoordinator(childCoordinator: Coordinator)
}

extension Coordinator {
    
    func removeChildCoordinator(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators.filter { $0 !== childCoordinator }
    }
    
    func addChildCoordinator(childCoordinator: Coordinator) {
        self.childCoordinators.append(childCoordinator)
    }
    
}

//
//  AppDelegate.swift
//  Workouts
//
//  Created by Mauricio Figueroa on 10-11-23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        setUpRootViewController(with: window)
        return true
    }
    
    private func setUpRootViewController(with window: UIWindow?) {
        let coordinator = ExerciseCoordinatorManager()
        let viewModel = ExerciseListViewModel(coordinator: coordinator)
        let viewController = ExerciseListViewController(viewModel: viewModel)
        
        coordinator.presentationViewController = {
            return viewController
        }
        
        let navigationController = UINavigationController(rootViewController: viewController)
        window?.rootViewController = navigationController
        viewController.load()
    }
}


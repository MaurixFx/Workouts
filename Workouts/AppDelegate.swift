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
        window?.rootViewController = ExerciseListViewController(viewModel: ExerciseListViewModel())
        return true
    }
}


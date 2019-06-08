//
//  AppDelegate.swift
//  ABBYY_Test_Task
//
//  Created by Ирина Соловьева on 06/06/2019.
//  Copyright © 2019 Ирина Соловьева. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.scheme == "ABBYYTestTaskUrl" {
            switch url.host {
            case "TaskListTableViewController":
                let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let initialViewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "ListTask") as UIViewController
                self.window = UIWindow(frame: UIScreen.main.bounds)
                let navigationController = UINavigationController(rootViewController: initialViewController)
                self.window?.rootViewController = navigationController
                self.window?.makeKeyAndVisible()
            case "ViewTaskViewController":
                let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let listTaskViewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "ListTask") as UIViewController
                let initialViewController : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "ViewTask") as UIViewController
                self.window = UIWindow(frame: UIScreen.main.bounds)
                let navigationController = UINavigationController(rootViewController: listTaskViewController)
                self.window?.rootViewController = navigationController
                navigationController.pushViewController(initialViewController, animated: false)
                self.window?.makeKeyAndVisible()
            case "CreateTaskViewController":
                let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let listTaskViewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "ListTask") as UIViewController
                let initialViewController : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "CreateTask") as UIViewController
                self.window = UIWindow(frame: UIScreen.main.bounds)
                let navigationController = UINavigationController(rootViewController: listTaskViewController)
                self.window?.rootViewController = navigationController
                navigationController.pushViewController(initialViewController, animated: false)
                self.window?.makeKeyAndVisible()
            default:
                break
            }
        }
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


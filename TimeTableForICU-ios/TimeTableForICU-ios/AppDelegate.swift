//
//  AppDelegate.swift
//  TimeTableForICU-ios
//
//  Created by 彌平千葉 on 2016/10/30.
//  Copyright © 2016年 彌平千葉. All rights reserved.
//

import UIKit
import DropDown
import SlideMenuControllerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        //SlideMenuの設定
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = storyboard.instantiateViewController(withIdentifier: "MainView") as! ViewController
        
        storyboard = UIStoryboard(name:"LeftSideMenuViewController",bundle:nil)
        let leftViewController = storyboard.instantiateViewController(withIdentifier: "LeftSideMenuViewController") as! LeftSideMenuViewController
        let nvc: UINavigationController = UINavigationController(rootViewController: mainViewController)
        
        leftViewController.mainViewCon = nvc

        
        let slideMenuController = SlideMenuController(mainViewController: nvc, leftMenuViewController: leftViewController)
        slideMenuController.changeLeftViewWidth(CGFloat(UIScreen.main.bounds.size.width*4/5))
        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()

        //GoogleAnyaliticsの設定
        GAUtility.GASetUp()
      
        DropDown.startListeningToKeyboard()

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


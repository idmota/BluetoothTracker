//
//  SceneDelegate.swift
//  BluetoothTracker
//
//  Created by Ruslan Maksiutov on 07.03.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = getTabBar()
        self.window = window
        window.makeKeyAndVisible()
    }
    
    func getTabBar() -> UITabBarController {
        let tabBar = UITabBarController()
        
        let fiendViewController = FiendViewController()
        let compassViewController = CompassViewController()
        let navigation = UINavigationController(rootViewController: fiendViewController)
        let tabOneBarItem = UITabBarItem(title: "All devices", image: UIImage(systemName: "iphone.homebutton.radiowaves.left.and.right"), selectedImage: nil)
        let compasstabOneBarItem = UITabBarItem(title: "compass", image: UIImage(systemName: "location.north.line"), selectedImage: nil)
        navigation.tabBarItem.imageInsets = UIEdgeInsets.init(top: 0,left: 0,bottom: -30,right: 0)
        navigation.tabBarItem = tabOneBarItem
        compassViewController.tabBarItem = compasstabOneBarItem
        
        tabBar.setViewControllers([compassViewController, navigation], animated: false)
        return tabBar
    }

}

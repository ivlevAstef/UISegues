//
//  AppDelegate.swift
//  UISeguesExample
//
//  Created by Ивлев Александр Евгеньевич on 24/08/2018.
//

import UIKit
import UISegues

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func applicationDidFinishLaunching(_ application: UIApplication) {
        _ = UISeguesInitializer()
    }

}


//
//  MangaReaderApp.swift
//  MangaReader
//
//  Created by Felicia Shang on 2023-06-22.
//

import SwiftUI

@main
struct MangaReaderApp: App {
    
    
    var body: some Scene {
        WindowGroup {
            
            HomeView()
        }
    }
}


//class AppDelegate: UIResponder, UIApplicationDelegate {
////  var window: UIWindow?
//
//   func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
//    // Override point for customization after application launch.
//    return true
//  }
//
//  func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
//      AlamofireAPI.sharedInstance.processOAuthStep1Response(url: url)
//
//      return true
//  }
//}

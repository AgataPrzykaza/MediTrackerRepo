//
//  MediTrackerApp.swift
//  MediTracker
//
//  Created by Agata Przykaza on 23/10/2023.
//

import SwiftUI
import FirebaseCore
import UserNotifications


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
      let center = UNUserNotificationCenter.current()
         center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
             // Obsługa błędów lub braku zgody
         }
    return true
  }
}


@main
struct MediTrackerApp: App {
    
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

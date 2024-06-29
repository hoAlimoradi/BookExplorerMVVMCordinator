//
//  AppDelegate.swift
//  SpaceXSingleModule
//
//  Created by ho on 4/8/1403 AP.
//
 

import UIKit
import Combine
import Sentry

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private var cancellables = Set<AnyCancellable>()
    var mainWindow: UIWindow?
    var coordinator: ProjectCoordinatorProtocol?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        mainWindow = UIWindow()
        let factory = DependencyFactory()
        coordinator = ProjectCoordinator(factory: factory)
        guard let mainWindow = mainWindow,
              let coordinator = coordinator else {
            return true
        }
        
        //MARK: setup splashViewController
        let splashViewController = factory.buildSplash(coordinator)
        mainWindow.rootViewController = splashViewController
        mainWindow.makeKeyAndVisible()
        mainWindow.backgroundColor =  ThemeManager.shared.getCurrentThemeColors().white1
        
        // Start the coordinator with the splash screen
        coordinator.start(splashViewController)
        
        //MARK: setup Logger
        exceptionLogger()
        //configSentry() 
        return true
    }
    
    fileprivate func configSentry() {
        SentrySDK.start { options in
            //options.dsn = Environment.current.sentryDsn
            options.debug = false
            options.tracesSampleRate = 1.0
        }
    }
     
    func applicationWillResignActive(_ application: UIApplication) {
        LoggingAPI.shared.log("application Will Resign Active: ", level: .info)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Called when the application has returned to the foreground (after leaving the background).
        LoggingAPI.shared.log("application Did Become Active: ", level: .info)
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate.
        // Save data if appropriate. See also applicationDidEnterBackground:.
        LoggingAPI.shared.log("application Will Terminate: ", level: .info)
    }
   
    
    fileprivate func exceptionLogger() {
        NSSetUncaughtExceptionHandler { exception in
            print("---------------------------------------------------------------")
            LoggingAPI.shared.log("NSSetUncaughtExceptionHandler: \(exception.description)", level: .error)
            print("================================================================")
        }
        
        signal(SIGABRT) { signal in
            print("---------------------------------------------------------------")
            LoggingAPI.shared.log("signal - SIGABRT: \(signal.description)", level: .error)
            print("================================================================")
        }
        
        signal(SIGILL) { signal in
            print("---------------------------------------------------------------")
            LoggingAPI.shared.log("signal SIGILL : \(signal.description)", level: .error)
            print("================================================================")
        }
        
        signal(SIGSEGV) { signal in
            print("---------------------------------------------------------------")
            LoggingAPI.shared.log("signal SIGSEGV: \(signal.description)", level: .error)
            print("================================================================")
        }
        
        signal(SIGFPE) { signal in
            print("---------------------------------------------------------------")
            LoggingAPI.shared.log("signal SIGFPE: \(signal.description)", level: .error)
            print("================================================================")
        }
        
        signal(SIGBUS) { signal in
            print("---------------------------------------------------------------")
            LoggingAPI.shared.log("signal SIGBUS: \(signal.description)", level: .error)
            print("================================================================")
        }
        
        signal(SIGPIPE) { signal in
            print("---------------------------------------------------------------")
            LoggingAPI.shared.log("signal SIGPIPE: \(signal.description)", level: .error)
            print("================================================================")
        }
    }
}



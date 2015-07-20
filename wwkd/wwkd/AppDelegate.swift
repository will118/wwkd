//
//  AppDelegate.swift
//  wwkd
//
//  Created by will on 14/07/2015.
//  Copyright © 2015 will. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    static var notifier: Notifier?
    
    let actionProphetic = "PROPHETIC"
    let actionIdiotic = "IDIOTIC"
    let notificationCategoryIdent  = "ACTIONABLE"

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let types =
            UIUserNotificationType.Badge.union(
            UIUserNotificationType.Alert.union(
            UIUserNotificationType.Sound))

        func makeAction(vote: Vote) -> UIMutableUserNotificationAction {
            let action = UIMutableUserNotificationAction()
            action.activationMode = UIUserNotificationActivationMode.Background
            
            switch vote {
            case .Prophetic:
                action.title = "Prophetic"
                action.identifier = actionProphetic
            case .Idiotic:
                action.title = "Idiotic"
                action.identifier = actionIdiotic
            }
            
            action.destructive = false
            action.authenticationRequired = false
            
            return action
        }
        
        let prophetic = makeAction(Vote.Prophetic)
        let idiotic = makeAction(Vote.Idiotic)
        
        let actionCategory = UIMutableUserNotificationCategory()
        actionCategory.identifier = notificationCategoryIdent
        actionCategory.setActions([prophetic, idiotic], forContext: UIUserNotificationActionContext.Default)
        
        let categories = Set(arrayLiteral: actionCategory)
        
        let settings = UIUserNotificationSettings(forTypes: types, categories: categories)
        
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let characterSet = NSCharacterSet(charactersInString: "<>")
        
        let deviceTokenString =
            deviceToken.description
                .stringByTrimmingCharactersInSet(characterSet)
                .stringByReplacingOccurrencesOfString(" ", withString: "")
        
        AppDelegate.notifier = Notifier(tkn: deviceTokenString)
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print(error.localizedDescription)
    }

    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [NSObject : AnyObject], completionHandler: () -> Void) {
        
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
        
        if let actionId = identifier, let quoteId = userInfo["quoteId"] as? Int {
            switch actionId {
            case actionProphetic:
                vote(quoteId, vote: Vote.Prophetic)
            case actionIdiotic:
                vote(quoteId, vote: Vote.Idiotic)
            default:
                ()
            }
        }
        completionHandler()
    }
    
    func vote(quoteId: Int, vote: Vote) {
        let state = UIApplication.sharedApplication().applicationState
        
        AppDelegate.notifier?.vote(quoteId, vote: vote, state: state)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        self.saveContext()
    }

    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "kushio.sdsd" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
        }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("QuoteLibrary", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
        }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("wwkd.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
        }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

}


//
//  LocalNotificationManager.swift
//  iOs531AppBackup
//
//  Created by Kevin Li on 10/17/19.
//  Copyright © 2019 Kevin Li. All rights reserved.
//

import Foundation
import UserNotifications

class LocalNotificationManager {
    var notifications = [Notification]()
    
    private var options: UNAuthorizationOptions = [.alert, .badge, .sound]
    
    func listScheduledNotifications(){
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { notifications in
            log.info("There are \(notifications.count) pending notifications: ")
            for notification in notifications{
                log.info("Pending notification: \(notification)")
            }
        })
    }
    
    private func requestAuthorization(){
        UNUserNotificationCenter.current().requestAuthorization(options: options, completionHandler: {
            (didAllow, error) in
            if didAllow && error == nil {
                self.scheduleNotifications()
            }
        })
    }
    
    func schedule(){
        UNUserNotificationCenter.current().getNotificationSettings(completionHandler: { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization()
            case .authorized, .provisional:
                self.scheduleNotifications()
            default:
                break
            }
        })
    }
    
    func removeAllNotifications(){
        log.info("Removing all current notifications")
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    private func scheduleNotifications(){
        for notification in notifications {
            let content = UNMutableNotificationContent()
            content.title = notification.title
            content.sound = .default
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: notification.dateTime, repeats: false)
            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                guard error == nil else {
                    return
                }
                
                log.info("Notification with ID - \(notification.id) - scheduled! ")
            })
        }
    }
}

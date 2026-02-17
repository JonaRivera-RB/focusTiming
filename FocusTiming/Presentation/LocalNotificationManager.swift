//
//  LocalNotificationManager.swift
//  FocusTiming
//
//  Created by Jonathan Rivera on 17/02/26.
//

import Foundation
import UserNotifications

final class LocalNotificationManager {
    
    static let shared = LocalNotificationManager()
    
    private init() {}
    
    // MARK: - Request Permission
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            
            if granted {
                print("✅ Notifications authorized")
            } else {
                print("❌ Notifications denied")
            }
        }
    }
    
    // MARK: - Schedule Block Notification
    
    func scheduleBlockCompletionNotification(
        title: String,
        body: String,
        at date: Date,
        identifier: String
    ) {
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let triggerDate = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from: date
        )
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: triggerDate,
            repeats: false
        )
        
        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
        
        print("🔔 Notification scheduled for \(date)")
    }
    
    // MARK: - Cancel All
    
    func cancelAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}

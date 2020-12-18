/*
The MIT License (MIT)

Copyright (c) 2015 AhmetKeskin

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import Foundation
import AVKit

class LocalNotificationHelper: NSObject {
    
    let LOCAL_NOTIFICATION_CATEGORY : String = "LocalNotificationCategory"
    
    // MARK: - Shared Instance
    
    class func sharedInstance() -> LocalNotificationHelper {
        struct Singleton {
            static var sharedInstance = LocalNotificationHelper()
        }
        return Singleton.sharedInstance
    }
    
    // MARK: - Schedule Notification
    
    func scheduleNotificationWithKey(_ key: String, title: String, message: String, seconds: Double, userInfo: [AnyHashable: Any]?) {
        let date = Date(timeIntervalSinceNow: TimeInterval(seconds))
        let notification = notificationWithTitle(key, title: title, message: message, date: date, userInfo: userInfo, soundName: nil, hasAction: true)
        notification.category = LOCAL_NOTIFICATION_CATEGORY
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    func scheduleNotificationWithKey(_ key: String, title: String, message: String, date: Date, userInfo: [AnyHashable: Any]?){
        let notification = notificationWithTitle(key, title: title, message: message, date: date, userInfo: ["key": key], soundName: nil, hasAction: true)
        notification.category = LOCAL_NOTIFICATION_CATEGORY
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    func scheduleNotificationWithKey(_ key: String, title: String, message: String, seconds: Double, soundName: String, userInfo: [AnyHashable: Any]?){
        let date = Date(timeIntervalSinceNow: TimeInterval(seconds))
        let notification = notificationWithTitle(key, title: title, message: message, date: date, userInfo: ["key": key], soundName: soundName, hasAction: true)
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    func scheduleNotificationWithKey(_ key: String, title: String, message: String, date: Date, soundName: String, userInfo: [AnyHashable: Any]?){
        let notification = notificationWithTitle(key, title: title, message: message, date: date, userInfo: ["key": key], soundName: soundName, hasAction: true)
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    // MARK: - Present Notification
    
    func presentNotificationWithKey(_ key: String, title: String, message: String, soundName: String, userInfo: [AnyHashable: Any]?) {
        let notification = notificationWithTitle(key, title: title, message: message, date: nil, userInfo: ["key": key], soundName: nil, hasAction: true)
        UIApplication.shared.presentLocalNotificationNow(notification)
    }
    
    // MARK: - Create Notification
    
    func notificationWithTitle(_ key : String, title: String, message: String, date: Date?, userInfo: [AnyHashable: Any]?, soundName: String?, hasAction: Bool) -> UILocalNotification {
        
        var dct : Dictionary<String,AnyObject> = userInfo as! Dictionary<String,AnyObject>
        dct["key"] = NSString(string: key) as String as String as AnyObject?
        
        let notification = UILocalNotification()
        notification.alertAction = title
        notification.alertBody = message
        notification.userInfo = dct
        notification.soundName = soundName ?? UILocalNotificationDefaultSoundName
        notification.fireDate = date
        notification.hasAction = hasAction
        return notification
    }
    
    func getNotificationWithKey(_ key : String) -> UILocalNotification {
        
        var notif : UILocalNotification?
        
        for notification in UIApplication.shared.scheduledLocalNotifications! where notification.userInfo!["key"] as! String == key{
            notif = notification
            break
        }
        
        return notif!
    }
    
    func cancelNotification(_ key : String){
        
        for notification in UIApplication.shared.scheduledLocalNotifications! where notification.userInfo!["key"] as! String == key{
            UIApplication.shared.cancelLocalNotification(notification)
            break
        }
    }
    
    func getAllNotifications() -> [UILocalNotification]? {
        return UIApplication.shared.scheduledLocalNotifications
    }
    
    func cancelAllNotifications() {
        UIApplication.shared.cancelAllLocalNotifications()
    }
    
    func registerUserNotificationWithActionButtons(actions : [UIUserNotificationAction]){
        
        let category = UIMutableUserNotificationCategory()
        category.identifier = LOCAL_NOTIFICATION_CATEGORY
        
        category.setActions(actions, for: UIUserNotificationActionContext.default)
        
        let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: NSSet(object: category) as? Set<UIUserNotificationCategory>)
        UIApplication.shared.registerUserNotificationSettings(settings)
    }
    
    func registerUserNotification(){
        
        let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(settings)
    }
    
    func createUserNotificationActionButton(identifier : String, title : String) -> UIUserNotificationAction{
        
        let actionButton = UIMutableUserNotificationAction()
        actionButton.identifier = identifier
        actionButton.title = title
        actionButton.activationMode = UIUserNotificationActivationMode.background
        actionButton.isAuthenticationRequired = true
        actionButton.isDestructive = false
        
        return actionButton
    }
    
}

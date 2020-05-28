//
//  PushNotificationSender.swift
//  AgriGuardian
//
//  Created by Davy Chuon on 5/27/20.
//  Copyright © 2020 Team Kadd. All rights reserved.
//

import UIKit

class PushNotificationSender {
    func sendPushNotification(to token: String, title: String, body: String) {
        print("FINNA SEND NOTIF \(token), \(title), \(body)")
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        let paramString: [String : Any] = ["to" : token,
                                           "priority" : "high",
                                           "content_available" : true,
                                           "notification" : ["title" : title, "body" : body],
                                           "data" : ["user" : "test_id"]
        ]
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AAAALkhx-UA:APA91bGf8Kpg6t7T5KSpNQxKGCEEmVHhIQUJg5IC8fsx7jJv1d_OYa4lI_SAz_JCDkKTc2AtQdd6nHkqFvhl9N-6LjqiZA2MS_wMr2cruZmp8fULS-yLB4QlvE19AjZh2eoj622zzsLV", forHTTPHeaderField: "Authorization")
        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
}

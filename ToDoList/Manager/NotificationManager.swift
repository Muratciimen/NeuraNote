//
//  NotificationManager.swift
//  ToDoList
//
//  Created by Murat Çimen on 15.11.2024.
//

import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    // MARK: - Bildirim İzni İsteme
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in
            if let error = error {
                print("Bildirim izni hatası: \(error.localizedDescription)")
            }
            completion(granted)
        }
    }
    
    // MARK: - Bildirim Planlama (Yerel Saat Kullanılarak)
    func scheduleNotification(title: String, body: String, date: Date, identifier: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let timeZone = TimeZone(identifier: "Europe/Istanbul")!
        let triggerDateComponents = Calendar.current.dateComponents(in: timeZone, from: date)

        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .full
        formatter.timeZone = timeZone
        print("Planlanan Bildirim Tarihi (Yerel): \(formatter.string(from: date))")
        print("Trigger Date Components: \(triggerDateComponents)")

        guard let hour = triggerDateComponents.hour, let minute = triggerDateComponents.minute else {
            print("Saat veya dakika bulunamadı. Bildirim planlaması iptal edildi.")
            return
        }
        print("Bildirim saati: \(hour):\(minute)")

        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Bildirim planlama hatası: \(error.localizedDescription)")
            } else {
                print("Bildirim başarıyla planlandı: \(identifier), Tarih: \(formatter.string(from: date))")
            }
        }
    }

    // MARK: - Bildirimi İptal Etme
    func cancelNotification(identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        print("Bildirim iptal edildi: \(identifier)")
    }
    
    // MARK: - Tüm Bildirimleri İptal Etme
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("Tüm bildirimler iptal edildi.")
    }
}

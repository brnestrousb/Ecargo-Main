import FirebaseMessaging
import UserNotifications

class MessagingService: NSObject, UNUserNotificationCenterDelegate, MessagingDelegate {
    static let shared = MessagingService()

    func configure() {
        // Set up notification delegates
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self

        // Request notification permissions
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
            if granted {
                print("Notification permissions granted.")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("Notification permissions denied.")
            }
        }
    }

    // Handle FCM token updates
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        // Save the token or send it to your server
    }

    // Handle notifications when the app is in the foreground
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.alert, .badge, .sound])
    }

    // Handle notification interactions
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        completionHandler()
    }
}
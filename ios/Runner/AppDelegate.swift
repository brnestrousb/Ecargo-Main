import UIKit
import Flutter
import Firebase
import FirebaseMessaging
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // Initialize Firebase first
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        
        // Register plugins
        GeneratedPluginRegistrant.register(with: self)

        // Set up notification delegates
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self

        // Request notification permissions
        requestNotificationPermissions()

        // Set up Flutter Method Channel
        setupMethodChannels()

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func requestNotificationPermissions() {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    
    private func setupMethodChannels() {
        if let controller = window?.rootViewController as? FlutterViewController {
            let channel = FlutterMethodChannel(name: "com.example.ecarrgo/channel", binaryMessenger: controller.binaryMessenger)
            
            channel.setMethodCallHandler { (call, result) in
                if call.method == "launchURL",
                   let args = call.arguments as? [String: Any],
                   let urlString = args["url"] as? String,
                   let url = URL(string: urlString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    result("Success")
                } else {
                    result(FlutterError(code: "UNAVAILABLE", message: "Invalid URL", details: nil))
                }
            }
        }
    }

    // Handle APNS token registration
    override func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("APNS token received: \(tokenString)")
        
        // Set the APNS token to Firebase Messaging
        Messaging.messaging().apnsToken = deviceToken

        // Notify Dart code that the token is available
        if let controller = window?.rootViewController as? FlutterViewController {
            let channel = FlutterMethodChannel(name: "com.example/appleToken", binaryMessenger: controller.binaryMessenger)
            channel.invokeMethod("appleTokenReceived", arguments: tokenString)
        }

        super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
    
    // Handle APNS registration failure
    override func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print("Failed to register for remote notifications: \(error)")
        super.application(application, didFailToRegisterForRemoteNotificationsWithError: error)
    }
}

// MARK: - MessagingDelegate
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        
        // Send token to Flutter
        if let controller = window?.rootViewController as? FlutterViewController {
            let channel = FlutterMethodChannel(name: "com.example/fcmToken", binaryMessenger: controller.binaryMessenger)
            channel.invokeMethod("fcmTokenReceived", arguments: fcmToken)
        }
    }
}
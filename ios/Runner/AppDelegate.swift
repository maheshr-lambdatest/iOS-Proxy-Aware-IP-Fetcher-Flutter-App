import UIKit
import Flutter
import os.log

@main
@objc class AppDelegate: FlutterAppDelegate {

  // MARK: - Properties
  private let channelName = "com.example.iosProxyApp/ip"
  private let ipLogger = OSLog(subsystem: "com.example.iosProxyApp", category: "public-ip")

  // MARK: - UIApplicationDelegate
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // 1. Get the FlutterViewController
    guard let controller = window?.rootViewController as? FlutterViewController else {
      fatalError("rootViewController is not a FlutterViewController")
    }

    // 2. Create the FlutterMethodChannel
    let channel = FlutterMethodChannel(name: channelName,
                                       binaryMessenger: controller.binaryMessenger)

    // 3. Register the handler
    channel.setMethodCallHandler { [weak self] (call, result) in
      guard call.method == "getPublicIP" else {
        result(FlutterMethodNotImplemented)
        return
      }
      self?.fetchPublicIP(result: result)
    }

    // 4. Let FlutterAppDelegate finish setup
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // MARK: - Private Helpers
  private func fetchPublicIP(result: @escaping FlutterResult) {
    // Build the URL
    guard let url = URL(string: "https://api.ipify.org/?format=text") else {
      result(FlutterError(code: "INVALID_URL",
                          message: "Invalid URL",
                          details: nil))
      return
    }

    // Start the network call
    let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
      // Handle network errors
      if let error = error {
        result(FlutterError(code: "NETWORK_ERROR",
                            message: error.localizedDescription,
                            details: nil))
        return
      }

      // Validate data
      guard let data = data, let ip = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines), !ip.isEmpty else {
        result(FlutterError(code: "DATA_ERROR",
                            message: "Failed to read response",
                            details: nil))
        return
      }

      // Return to Flutter side
      result(ip)
    }

    task.resume()
  }
}

import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

// TODO: Add your API key
    GMSServices.provideAPIKey("AIzaSyC_Bx2N5saBoMoJiXeCDURYK2DGCCWUu6Q")

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

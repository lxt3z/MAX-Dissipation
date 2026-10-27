import Flutter
import UIKit

final class KometGlass {
  static let shared = KometGlass()

  func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getDisplayCornerRadius":
      var cornerRadius: CGFloat = 0.0
      if let window = UIApplication.shared.windows.first {
        if let radiusNumber = window.screen.value(forKey: "_displayCornerRadius") as? NSNumber {
          cornerRadius = CGFloat(radiusNumber.floatValue)
        }
      } else if let screen = UIScreen.screens.first {
        if let radiusNumber = screen.value(forKey: "_displayCornerRadius") as? NSNumber {
          cornerRadius = CGFloat(radiusNumber.floatValue)
        }
      }
      result(NSNumber(value: Double(cornerRadius)))
    case "supportsLiquidGlass":
      result(NSNumber(value: true))
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}

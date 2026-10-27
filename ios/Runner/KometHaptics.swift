import Flutter
import UIKit

final class KometHaptics {
  static let shared = KometHaptics()

  private let lightGenerator = UIImpactFeedbackGenerator(style: .light)
  private let mediumGenerator = UIImpactFeedbackGenerator(style: .medium)
  private let heavyGenerator = UIImpactFeedbackGenerator(style: .heavy)
  private let selectionGenerator = UISelectionFeedbackGenerator()
  private let notificationGenerator = UINotificationFeedbackGenerator()

  private lazy var rigidGenerator: UIImpactFeedbackGenerator = {
    if #available(iOS 13.0, *) {
      return UIImpactFeedbackGenerator(style: .rigid)
    }
    return UIImpactFeedbackGenerator(style: .medium)
  }()

  private lazy var softGenerator: UIImpactFeedbackGenerator = {
    if #available(iOS 13.0, *) {
      return UIImpactFeedbackGenerator(style: .soft)
    }
    return UIImpactFeedbackGenerator(style: .light)
  }()

  func prepare() {
    lightGenerator.prepare()
    selectionGenerator.prepare()
  }

  func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "light":
      lightGenerator.impactOccurred()
      result(nil)
    case "medium":
      mediumGenerator.impactOccurred()
      result(nil)
    case "heavy":
      heavyGenerator.impactOccurred()
      result(nil)
    case "rigid":
      rigidGenerator.impactOccurred()
      result(nil)
    case "soft":
      softGenerator.impactOccurred()
      result(nil)
    case "selection":
      selectionGenerator.selectionChanged()
      result(nil)
    case "success":
      notificationGenerator.notificationOccurred(.success)
      result(nil)
    case "warning":
      notificationGenerator.notificationOccurred(.warning)
      result(nil)
    case "error":
      notificationGenerator.notificationOccurred(.error)
      result(nil)
    case "prepare":
      prepare()
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}

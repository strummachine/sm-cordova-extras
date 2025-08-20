import StoreKit
import UIKit
import AVFoundation

@objc(SMExtras) class SMExtras : CDVPlugin {

    var buildInfo: [String:String?]?

    @objc(getBuildInfo:) func getBuildInfo(command: CDVInvokedUrlCommand) {
        DispatchQueue.main.async {
            self.buildInfo = self.buildInfo ?? [
                "packageName": Bundle.main.bundleIdentifier,
                "basePackageName": Bundle.main.bundleIdentifier,
                "displayName": Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String,
                "version": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
                "versionCode": Bundle.main.infoDictionary?["CFBundleVersion"] as? String,
            ]
            self.commandDelegate!.send(
                CDVPluginResult(status: CDVCommandStatus_OK, messageAs: self.buildInfo),
                callbackId: command.callbackId
            )
        }
    }

    @objc(getLatency:) func getLatency(command: CDVInvokedUrlCommand) {
        DispatchQueue.main.async {
            let latency = AVAudioSession.sharedInstance().outputLatency + AVAudioSession.sharedInstance().ioBufferDuration
            self.commandDelegate!.send(
                CDVPluginResult(
                    status: CDVCommandStatus_OK,
                    messageAs: latency * 1000   // return latency in milliseconds
                ),
                callbackId: command.callbackId
            )
        }
    }

    @objc(detectMuteSwitch:) func detectMuteSwitch(command: CDVInvokedUrlCommand) {
        DispatchQueue.main.async {
            MuteSwitchDetector.checkSwitch({ success, silent in
                self.commandDelegate!.send(
                    CDVPluginResult(
                        status: CDVCommandStatus_OK,
                        messageAs: success && silent
                    ),
                    callbackId: command.callbackId
                )
            })
        }
    }

    @objc(disableIdleTimeout:) func disableIdleTimeout(command: CDVInvokedUrlCommand) {
        DispatchQueue.main.async {
            UIApplication.shared.isIdleTimerDisabled = true

            self.commandDelegate!.send(
                CDVPluginResult(status: CDVCommandStatus_OK),
                callbackId: command.callbackId
            )
        }
    }

    @objc(enableIdleTimeout:) func enableIdleTimeout(command: CDVInvokedUrlCommand) {
        DispatchQueue.main.async {
            UIApplication.shared.isIdleTimerDisabled = false

            self.commandDelegate!.send(
                CDVPluginResult(status: CDVCommandStatus_OK),
                callbackId: command.callbackId
            )
        }
    }

    // Note: Because this method may not present an alert, it isn’t appropriate to call requestReview() or requestReview(in:) in response to a button tap or other user action.
    @objc(requestAppReview:) func requestAppReview(command: CDVInvokedUrlCommand) {
        DispatchQueue.main.async {
            if #available(iOS 14.0, *) {
                if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                    SKStoreReviewController.requestReview(in: scene)
                }
            } else {
                // Fallback on earlier versions
                SKStoreReviewController.requestReview()
            }

            self.commandDelegate!.send(
                CDVPluginResult(status: CDVCommandStatus_OK),
                callbackId: command.callbackId
            )
        }
    }

    @objc(manageSubscriptions:) func manageSubscriptions(command: CDVInvokedUrlCommand) {
        DispatchQueue.main.async {
            if #available(iOS 15.3, *), let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                Task {
                    do {
                        try await AppStore.showManageSubscriptions(in: scene)
                    } catch {
                        debugPrint(error)
                    }
                }
            } else {
                // Fallback on earlier versions
                let URL = URL(string: "https://apps.apple.com/account/subscriptions")!
                UIApplication.shared.open(URL as URL, options: [:])
            }

            self.commandDelegate!.send(
                CDVPluginResult(status: CDVCommandStatus_OK),
                callbackId: command.callbackId
            )
        }
    }

    @objc(openURL:) func openURL(command: CDVInvokedUrlCommand) {
        DispatchQueue.main.async {
            let url = command.arguments[0] as? String ?? ""
            // e.g. https://itunes.apple.com/app/XXXXXXXXXX?action=write-review

            let writeReviewURL = URL(string: url)!
            UIApplication.shared.open(writeReviewURL, options: [:])

            self.commandDelegate!.send(
                CDVPluginResult(status: CDVCommandStatus_OK),
                callbackId: command.callbackId
            )
        }
    }

}

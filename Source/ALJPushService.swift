//
//                            Open Your Mind!
//
//                  .-~~~~~~~~~-._       _.-~~~~~~~~~-.
//              __.'              ~.   .~              `.__
//            .'//                  \./                  \\`.
//          .'//                     |                     \\`.
//        .'// .-~"""""""~~~~-._     |     _,-~~~~"""""""~-. \\`.
//      .'//.-"                 `-.  |  .-'                 "-.\\`.
//    .'//______.============-..   \ | /   ..-============.______\\`.
//  .'______________________________\|/______________________________`.
//
//  ALJPushService.swift
//  ALJPushService
//
//  Created by Alirio Lau on 2020/3/28.
//  Copyright © 2020 com.alirio.lau.www. All rights reserved.
//

import UIKit
import UserNotifications

public class ALJPushService: NSObject {

  public static let shared = ALJPushService()
  private var isOnline = false

  private var _parseUserInfo: ((_ userInfo: [AnyHashable : Any]) -> Void)?
  public func parseUserInfo(_ block: ((_ userInfo: [AnyHashable : Any]) -> Void)?) {
    _parseUserInfo = block
  }

  private override init() { }

  public func start(
    withAppKey appKey: String,
    launchOptions: [UIApplication.LaunchOptionsKey: Any]?,
    isOnline: Bool
  ) {
    self.isOnline = isOnline

    JPUSHService.setup(
      withOption: launchOptions,
      appKey: appKey,
      channel: "",
      apsForProduction: true
    )

    DispatchQueue.main.async {
      self.registerNotice()
    }
  }

  public func setJPushAlias(_ alias: String) {
    JPUSHService.setAlias(alias, completion: { [weak self] (_, iAlias, seq) in
      guard let self = self else { return }
      if self.isOnline == false {
        print("********************** setAlias completion ***** iAlias = \(iAlias ?? "nil"), seq = \(seq)")
      }
    }, seq: Int(Date().timeIntervalSince1970))
  }

  public func registerDeviceToken(_ deviceToken: Data) {
    JPUSHService.registerDeviceToken(deviceToken)
  }

  private func registerNotice() {
    var options: JPAuthorizationOptions = [.alert, .badge, .sound]

    if #available(iOS 12, *) {
      options.insert(.providesAppNotificationSettings)
    }

    let entity = JPUSHRegisterEntity()
    entity.types = Int(options.rawValue)

    JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)

    JPUSHService.registrationIDCompletionHandler { [weak self] (_, registrationID) in
      guard let self = self else { return }
      if self.isOnline == false {
        print("********************** registrationID = \(registrationID ?? "nil")")
      }
    }
  }

  private func parseNotificationUserInfo(_ userInfo: [AnyHashable : Any]) {
    _parseUserInfo?(userInfo)
  }

}

extension ALJPushService: JPUSHRegisterDelegate {
  
  public func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {

    guard let trigger = notification.request.trigger, trigger.isKind(of: UNPushNotificationTrigger.self) else { return }

    let userInfo = notification.request.content.userInfo

    JPUSHService.handleRemoteNotification(userInfo)

    let option: UNNotificationPresentationOptions = [.badge, .sound, .alert]

    completionHandler(Int(option.rawValue))
  }

  public func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {

    guard let trigger = response.notification.request.trigger, trigger.isKind(of: UNPushNotificationTrigger.self) else { return }

    let userInfo = response.notification.request.content.userInfo

    JPUSHService.handleRemoteNotification(userInfo)

    parseNotificationUserInfo(userInfo)

    completionHandler()
  }

  @available(iOS 12, *)
  public func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification!) {

  }

  public func jpushNotificationAuthorization(_ status: JPAuthorizationStatus, withInfo info: [AnyHashable : Any]!) {

  }

}

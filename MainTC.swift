//
//  MainTC.swift
//  TryLocal
//
//  Created by 시모니의 맥북 on 6/19/25.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    var token: String?  // ✅ LoginVC에서 전달받는 토큰
    var userName: String? // Login에서 받은 유저이름
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarAppearance()
        injectTokenToChildVCs()  // ✅ 토큰 + 유저이름 주입
    }
    
    private func injectTokenToChildVCs() {
          guard let token = token , let userName = userName else { return }
          
          for vc in viewControllers ?? [] {
              if let nav = vc as? UINavigationController {
                  if let homeVC = nav.topViewController as? HomeVC {
                      homeVC.vm = HomeVM(token: token , userName: userName)
                  } else if let journeyVC = nav.topViewController as? JourneyVC {
                      journeyVC.vm = JourneyVM(token: token , userName: userName)
                  } else if let myPageVC = nav.topViewController as? MyPageVC {
                      myPageVC.vm = MyPageVM(token: token , userName: userName)
                  }
              } else {
                  if let homeVC = vc as? HomeVC {
                      homeVC.vm = HomeVM(token: token , userName: userName)
                  } else if let journeyVC = vc as? JourneyVC {
                      journeyVC.vm = JourneyVM(token: token , userName: userName)
                  } else if let myPageVC = vc as? MyPageVC {
                      myPageVC.vm = MyPageVM(token: token , userName: userName)
                  }
              }
          }
      }
    
    private func setupTabBarAppearance() {
            if #available(iOS 13.0, *) {
                let appearance = UITabBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = .white  // 탭바 전체 배경색

                // 비선택 상태
                appearance.stackedLayoutAppearance.normal.iconColor = .gray
                appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                    .foregroundColor: UIColor.gray
                ]

                // 선택 상태
                appearance.stackedLayoutAppearance.selected.iconColor = UIColor(hex: "#E7AC52")
                appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
                    .foregroundColor: UIColor(hex: "#E7AC52")
                ]

                // 적용
                tabBar.standardAppearance = appearance
                if #available(iOS 15.0, *) {
                    tabBar.scrollEdgeAppearance = appearance
                }
            } else {
                // iOS 12 이하 대응 (간단하게만 설정 가능)
                UITabBar.appearance().barTintColor = .white
                UITabBar.appearance().tintColor = UIColor(hex: "#E7AC52")
                UITabBar.appearance().unselectedItemTintColor = .gray
            }
        }
    
}


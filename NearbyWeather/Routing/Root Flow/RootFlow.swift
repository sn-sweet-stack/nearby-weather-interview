//
//  RootFlow.swift
//  NearbyWeather
//
//  Created by Erik Maximilian Martens on 19.04.20.
//  Copyright © 2020 Erik Maximilian Martens. All rights reserved.
//

import RxFlow

class RootFlow: Flow {
  
  // MARK: - Assets
  
  var root: Presentable {
    rootWindow
  }
  
  // MARK: - Properties
  
  let rootWindow: UIWindow
  
  // MARK: - Initialization
  
  init(rootWindow: UIWindow) {
    self.rootWindow = rootWindow
  }
  
  // MARK: - Functions
  
  func navigate(to step: Step) -> FlowContributors {
    guard let step = transform(step: step) as? RootStep else {
      return .none
    }
    switch step {
    case .main:
      return summonMainWindow()
    case .welcome:
      return summonWelcomeWindow()
    case .dimissWelcome:
      return dismissWelcomeWindow()
    }
  }
  
  private func transform(step: Step) -> Step? {
    if let welcomeStep = step as? WelcomeStep {
      switch welcomeStep {
      case .launchApp:
        return RootStep.main
      default:
        return nil
      }
    }
    return step
  }
}

private extension RootFlow {
  
  func summonMainWindow() -> FlowContributors {
    let mainFlow = MainFlow()
    
    Flows.whenReady(flow1: mainFlow) { [rootWindow] (mainRoot: UITabBarController) in
      rootWindow.rootViewController = mainRoot
      rootWindow.makeKeyAndVisible()
    }
    
    return .one(flowContributor: .contribute(withNextPresentable: mainFlow, withNextStepper: MainStepper()))
  }
  
  func summonWelcomeWindow() -> FlowContributors {
    let welcomeFlow = WelcomeFlow()
    
    Flows.whenReady(flow1: welcomeFlow) { [rootWindow] (welcomeRoot: UITabBarController) in
      rootWindow.rootViewController = welcomeRoot
      rootWindow.makeKeyAndVisible()
    }
    
    return .one(flowContributor: .contribute(withNextPresentable: welcomeFlow, withNextStepper: WelcomeStepper()))
  }
  
  func dismissWelcomeWindow() -> FlowContributors {
    let mainFlow = MainFlow()
    
    Flows.whenReady(flow1: mainFlow) { [rootWindow] (mainRoot: UITabBarController) in
      UIView.animate(withDuration: 0.2, animations: {
        rootWindow.alpha = 0
        rootWindow.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
      }, completion: { _ in
        rootWindow.rootViewController = mainRoot
        rootWindow.alpha = 1
      })
    }
    
    return .one(flowContributor: .contribute(withNextPresentable: mainFlow, withNextStepper: MainStepper()))
  }
}

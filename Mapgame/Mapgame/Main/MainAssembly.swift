//
//  MainAssembly.swift
//  Mapgame
//
//  Created by Бабочиев Эдуард Таймуразович on 27.04.2025.
//

import UIKit

final class MainAssembly {
  func assembly() -> UIViewController {
    let viewController = MainViewController()
    let router = MainRouter()
    let presenter = MainPresenter(view: viewController)
    
    let interactor = MainInteractor(
      presenter: presenter,
      networkService: FirebaseNetwork(),
      router: router
    )
    
    viewController.interactor = interactor
    router.presentableView = viewController
    
    let navigationController = UINavigationController(rootViewController: viewController)
    navigationController.navigationBar.prefersLargeTitles = true
    navigationController.navigationBar.isHidden = true
    
    return navigationController
  }
}

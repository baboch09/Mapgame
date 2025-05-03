//
//  MapAssembly.swift
//  Mapgame
//
//  Created by Бабочиев Эдуард Таймуразович on 27.04.2025.
//

import UIKit

final class MapAssembly {
  func assembly() -> UIViewController {
    let viewController = MapViewController()
    let presenter = MapPresenter(view: viewController)
    let interactor = MapInteractor(
      presenter: presenter,
      networkService: FirebaseNetwork()
    )
    
    viewController.interactor = interactor
    
    return viewController
  }
}

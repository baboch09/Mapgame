//
//  PromotionsAssembly.swift
//  Mapgame
//
//  Created by Бабочиев Эдуард Таймуразович on 27.04.2025.
//

import UIKit

final class PromotionsAssembly {
    func assembly() -> UIViewController {
        let viewController = PromotionsViewController()
        let presenter = PromotionsPresenter(view: viewController)
        let interactor = PromotionsInteractor(presenter: presenter)
        
        viewController.interactor = interactor
      
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.isHidden = true
        
        return navigationController
    }
} 

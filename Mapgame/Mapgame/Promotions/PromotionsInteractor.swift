//
//  PromotionsInteractor.swift
//  Mapgame
//
//  Created by Бабочиев Эдуард Таймуразович on 27.04.2025.
//

import Foundation

class PromotionsInteractor: PromotionsInteractorProtocol {
  var presenter: PromotionsPresenterProtocol?
  private let networkService: FirebaseNetwork
  
  init(presenter: PromotionsPresenterProtocol, networkService: FirebaseNetwork) {
    self.presenter = presenter
    self.networkService = networkService
  }
  
  func fetchPromotions() {
    networkService.fetchPromos { [weak self] result in
      switch result {
      case .success(let promotions):
        let promos: [Promotion] = promotions.map(\.1)
        self?.presenter?.didFetchPromotions(promos)
      case .failure(let error):
        self?.presenter?.didFailToFetchPromotions(error)
      }
    }
  }
} 

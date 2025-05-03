//
//  PromotionsInteractor.swift
//  Mapgame
//
//  Created by Бабочиев Эдуард Таймуразович on 27.04.2025.
//

import Foundation

class PromotionsInteractor: PromotionsInteractorProtocol {
    var presenter: PromotionsPresenterProtocol?
    
    init(presenter: PromotionsPresenterProtocol) {
        self.presenter = presenter
    }
    
    func fetchPromotions() {
//        networkService.fetchPromotions { [weak self] result in
//            switch result {
//            case .success(let promotions):
//                self?.presenter?.didFetchPromotions(promotions)
//            case .failure(let error):
//                self?.presenter?.didFailToFetchPromotions(error)
//            }
//        }
    }
} 

//
//  PromotionsPresenter.swift
//  Mapgame
//
//  Created by Бабочиев Эдуард Таймуразович on 27.04.2025.
//

import Foundation


class PromotionsPresenter: PromotionsPresenterProtocol {
    var view: PromotionsViewProtocol?
    
    init(view: PromotionsViewProtocol) {
        print("PromotionsPresenter: init with view")
        self.view = view
    }
    
    func didFetchPromotions(_ promotions: [Promotion]) {
        print("PromotionsPresenter: didFetchPromotions called with \(promotions.count) promotions")
        print("PromotionsPresenter: view is \(view == nil ? "nil" : "not nil")")
        view?.showPromotions(promotions)
    }
    
    func didFailToFetchPromotions(_ error: Error) {
        print("PromotionsPresenter: didFailToFetchPromotions called with error: \(error.localizedDescription)")
        print("PromotionsPresenter: view is \(view == nil ? "nil" : "not nil")")
        view?.showError(error.localizedDescription)
    }
} 

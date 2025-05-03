//
//  PromotionsProtocols.swift
//  Mapgame
//
//  Created by Бабочиев Эдуард Таймуразович on 27.04.2025.
//

import Foundation

// MARK: - View Protocol
protocol PromotionsViewProtocol: AnyObject {
    func showPromotions(_ promotions: [Promotion])
    func showError(_ message: String)
}

// MARK: - Presenter Protocol
protocol PromotionsPresenterProtocol: AnyObject {
    func didFetchPromotions(_ promotions: [Promotion])
    func didFailToFetchPromotions(_ error: Error)
}

// MARK: - Interactor Protocol
protocol PromotionsInteractorProtocol: AnyObject {
    func fetchPromotions()
} 
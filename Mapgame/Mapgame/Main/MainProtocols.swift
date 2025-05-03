//
//  MainProtocols.swift
//  Mapgame
//
//  Created by Бабочиев Эдуард Таймуразович on 27.04.2025.
//

import Foundation

// MARK: - View Protocol
protocol MainViewProtocol: AnyObject {
  func showClubs(_ clubs: [ComputerClub])
  func showError(_ message: String)
  func showLoaderView()
  func hideLoaderView()
}

// MARK: - Presenter Protocol
protocol MainPresenterProtocol: AnyObject {
  func didFetchClubs(_ clubs: [ComputerClub])
  func didFailToFetchClubs(_ error: Error)
  func showLoader()
  func hideLoader()
}

// MARK: - Interactor Protocol
protocol MainInteractorProtocol: AnyObject {
  func fetchClubs()
  func routeToClubDetails(with club: ComputerClub)
}

// MARK: - Router Protocol
protocol MainRouterProtocol: AnyObject {
  func routeToClubDetail(club: ComputerClub)
}

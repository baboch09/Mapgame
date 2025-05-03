//
//  MainInteractor.swift
//  Mapgame
//
//  Created by Бабочиев Эдуард Таймуразович on 27.04.2025.
//

import Foundation
import FirebaseDatabase

class MainInteractor: MainInteractorProtocol {
  var presenter: MainPresenterProtocol?
  let router: MainRouterProtocol?
  private let networkService: FirebaseNetwork
  
  init(presenter: MainPresenterProtocol, networkService: FirebaseNetwork, router: MainRouterProtocol) {
    self.presenter = presenter
    self.networkService = networkService
    self.router = router
  }
  
  func fetchClubs() {
    presenter?.showLoader()
    networkService.fetchClubs { [weak self] result in
      self?.presenter?.hideLoader()
      switch result {
      case .success(let clubs):
        let filtredClubs: [ComputerClub] = clubs.map(\.1).sorted(by: { $0.id > $1.id })
        self?.presenter?.didFetchClubs(filtredClubs)
      case .failure(let error):
        self?.presenter?.didFailToFetchClubs(error)
      }
    }
  }
  
  func routeToClubDetails(with club: ComputerClub) {
    router?.routeToClubDetail(club: club)
  }
}

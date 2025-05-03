//
//  MainPresenter.swift
//  Mapgame
//
//  Created by Бабочиев Эдуард Таймуразович on 27.04.2025.
//

import UIKit


class MainPresenter: MainPresenterProtocol {
  weak var view: MainViewProtocol?
  
  init(view: MainViewProtocol) {
    self.view = view
  }
  
  func didFetchClubs(_ clubs: [ComputerClub]) {
    view?.showClubs(clubs)
  }
  
  func didFailToFetchClubs(_ error: Error) {
    view?.showError(error.localizedDescription)
  }
  
  func showLoader() {
    view?.showLoaderView()
  }
  
  func hideLoader() {
    view?.hideLoaderView()
  }
}

//
//  MapPresenter.swift
//  Mapgame
//
//  Created by Бабочиев Эдуард Таймуразович on 27.04.2025.
//

import Foundation
import CoreLocation

class MapPresenter: MapPresenterProtocol {
  var view: MapViewProtocol?
  
  init(view: MapViewProtocol) {
    self.view = view
  }
  
  func didFetchClubs(_ geocodedClubs: [(club: ComputerClub, coordinate: CLLocationCoordinate2D)]) {
    view?.showClubs(geocodedClubs)
  }
  
  func didFailToFetchClubs(_ error: Error) {
    view?.showError(error.localizedDescription)
  }
  
  func shopClubPopup(_ club: ComputerClub) {
    view?.shopClubPopup(club)
  }
}

//
//  MapProtocols.swift
//  Mapgame
//
//  Created by Бабочиев Эдуард Таймуразович on 27.04.2025.
//

import Foundation
import MapKit

// MARK: - View Protocol
protocol MapViewProtocol: AnyObject {
  func showClubs(_ geocodedClubs: [(club: ComputerClub, coordinate: CLLocationCoordinate2D)])
  func shopClubPopup(_ club: ComputerClub)
  func showError(_ message: String)
}

// MARK: - Presenter Protocol
protocol MapPresenterProtocol: AnyObject {
  func didFetchClubs(_ geocodedClubs: [(club: ComputerClub, coordinate: CLLocationCoordinate2D)])
  func didFailToFetchClubs(_ error: Error)
  func shopClubPopup(_ club: ComputerClub)
}

// MARK: - Interactor Protocol
protocol MapInteractorProtocol: AnyObject {
  func fetchClubs()
  func assemblePopup(_ id: String)
}

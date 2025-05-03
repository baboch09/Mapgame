//
//  MapInteractor.swift
//  Mapgame
//
//  Created by Бабочиев Эдуард Таймуразович on 27.04.2025.
//

import Foundation
import CoreLocation

class MapInteractor: MapInteractorProtocol {
  var presenter: MapPresenterProtocol?
  
  private let networkService: FirebaseNetwork
  private let geocoder = CLGeocoder()
  private var clubs: [ComputerClub] = []
  
  init(presenter: MapPresenterProtocol, networkService: FirebaseNetwork) {
    self.presenter = presenter
    self.networkService = networkService
  }
  
  func fetchClubs() {
    networkService.fetchClubs { result in
      switch result {
      case .success(let clubs):
        let clubs: [ComputerClub] = clubs.map(\.1).sorted(by: { $0.id > $1.id })
        self.clubs = clubs
        self.geocodeClubs(clubs)
      case .failure(let error):
        print(error.localizedDescription)
      }
    }
    
  }
  
  func assemblePopup(_ id: String) {
    guard let club = clubs.first(where: { $0.id == id }) else {
      return
    }
    presenter?.shopClubPopup(club)
  }

  
  private func geocodeClubs(_ clubs: [ComputerClub]) {
    var geocodedClubs: [(club: ComputerClub, coordinate: CLLocationCoordinate2D)] = []
    let group = DispatchGroup()
    
    for club in clubs {
      group.enter()
      geocodeAddressString(club.address) { [weak self] coordinate in
        defer { group.leave() }
        
        if let coordinate = coordinate {
          geocodedClubs.append((club: club, coordinate: coordinate))
        }
      }
    }
    
    group.notify(queue: .main) { [weak self] in
      // Сортируем клубы в том же порядке, в котором они были в исходном массиве
      let sortedClubs = geocodedClubs.sorted { club1, club2 in
        guard let index1 = clubs.firstIndex(where: { $0.id == club1.club.id }),
              let index2 = clubs.firstIndex(where: { $0.id == club2.club.id }) else {
          return false
        }
        return index1 < index2
      }
      self?.presenter?.didFetchClubs(sortedClubs)
    }
  }
  
  private func geocodeAddressString(_ address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
    let geocoder = CLGeocoder()
    
    // Добавляем "Санкт-Петербург" к адресу, если его нет
    let fullAddress = address.contains("Санкт-Петербург") ? address : "Санкт-Петербург, \(address)"
    
    geocoder.geocodeAddressString(fullAddress) { placemarks, error in
      if let error = error {
        print("Ошибка геокодирования для адреса \(address): \(error.localizedDescription)")
        
        // Пробуем альтернативный вариант с другим форматированием
        let alternativeAddress = address.replacingOccurrences(of: ",", with: " ")
        geocoder.geocodeAddressString("Санкт-Петербург, \(alternativeAddress)") { placemarks, error in
          if let error = error {
            print("Ошибка альтернативного геокодирования: \(error.localizedDescription)")
            completion(nil)
            return
          }
          
          if let location = placemarks?.first?.location?.coordinate {
            completion(location)
          } else {
            print("Не удалось получить координаты для адреса: \(address)")
            completion(nil)
          }
        }
        return
      }
      
      if let location = placemarks?.first?.location?.coordinate {
        completion(location)
      } else {
        print("Не удалось получить координаты для адреса: \(address)")
        completion(nil)
      }
    }
  }
}

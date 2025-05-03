//
//  FirebaseNetwork.swift
//  Mapgame
//
//  Created by Бабочиев Эдуард Таймуразович on 03.05.2025.
//

import Foundation
import Firebase
import FirebaseDatabase
import Moya


public final class FirebaseNetwork {

  let provider = MoyaProvider<FirebaseService>()
  
  init() { }
  
  func fetchClubs(completion: @escaping (Result<[(String, ComputerClub)], Error>) -> Void) {
    provider.request(.getClubs) { result in
      switch result {
      case .success(let response):
        do {
          let decoded = try JSONDecoder().decode([String: ComputerClub].self, from: response.data)
          let clubs = decoded.map { clubId, club in
            (clubId: clubId, club: club)
          }
          completion(.success(clubs))
        } catch {
          completion(.failure(error))
        }
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }
}

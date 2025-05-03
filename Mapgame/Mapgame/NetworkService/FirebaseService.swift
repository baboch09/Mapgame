//
//  FirebaseService.swift
//  Mapgame
//
//  Created by Бабочиев Эдуард Таймуразович on 03.05.2025.
//

import Moya
import Foundation

enum FirebaseService {
    case getClubs
    case addClub(club: ComputerClub)
}

extension FirebaseService: TargetType {
    var baseURL: URL {
        return URL(string: "https://gamersmap-a1154-default-rtdb.firebaseio.com")!
    }

    var path: String {
        switch self {
        case .getClubs, .addClub:
            return "/clubs.json"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getClubs:
            return .get
        case .addClub:
            return .post
        }
    }

    var task: Task {
        switch self {
        case .getClubs:
            return .requestPlain
        case .addClub(let club):
            let data = try? JSONEncoder().encode(club)
            let json = try? JSONSerialization.jsonObject(with: data ?? Data())
            return .requestParameters(parameters: json as? [String: Any] ?? [:], encoding: JSONEncoding.default)
        }
    }

    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}

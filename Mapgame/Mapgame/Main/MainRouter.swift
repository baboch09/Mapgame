//
//  MainRouter.swift
//  Mapgame
//
//  Created by Бабочиев Эдуард Таймуразович on 27.04.2025.
//

import UIKit


final class MainRouter: MainRouterProtocol {
  weak var presentableView: UIViewController?
  
  func routeToClubDetail(club: ComputerClub) {
    let detailVC = ClubDetailViewController(club: club)
    detailVC.navigationController?.navigationBar.isHidden = false
    presentableView?.navigationController?.pushViewController(detailVC, animated: true)
  }
}

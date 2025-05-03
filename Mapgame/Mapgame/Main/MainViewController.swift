//
//  MainViewController.swift
//  Mapgame
//
//  Created by Бабочиев Эдуард Таймуразович on 27.04.2025.
//

import UIKit
import MapKit

class MainViewController: UIViewController, MainViewProtocol, UITableViewDataSource, UITableViewDelegate {
  
  var interactor: MainInteractorProtocol?
  private var clubs: [ComputerClub] = []
  
  private var mapViewController: MapViewController?
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "Mapgame"
    label.font = .systemFont(ofSize: 18, weight: .bold)
    label.textAlignment = .center
    return label
  }()
  
  private let searchContainer: UIView = {
    let view = UIView()
    view.backgroundColor = .rayFlowerBackground
    view.layer.cornerRadius = 12
    return view
  }()
  
  private let searchIcon: UIImageView = {
    let imageView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
    imageView.tintColor = .systemGray2
    return imageView
  }()
  
  private let searchField: UITextField = {
    let tf = UITextField()
    tf.placeholder = "Найти клуб"
    tf.borderStyle = .none
    tf.backgroundColor = .clear
    tf.font = .systemFont(ofSize: 16)
    return tf
  }()
  
  private let viewToggle: UISegmentedControl = {
    let items = ["Список", "Карта"]
    let segmentedControl = UISegmentedControl(items: items)
    segmentedControl.selectedSegmentIndex = 0
    segmentedControl.backgroundColor = UIColor(white: 0.95, alpha: 1)
    segmentedControl.selectedSegmentTintColor = .white
    let normalAttributes: [NSAttributedString.Key: Any] = [
      .font: UIFont.systemFont(ofSize: 16, weight: .medium),
      .foregroundColor: UIColor.systemGray
    ]
    let selectedAttributes: [NSAttributedString.Key: Any] = [
      .font: UIFont.systemFont(ofSize: 16, weight: .medium),
      .foregroundColor: UIColor.black
    ]
    segmentedControl.setTitleTextAttributes(normalAttributes, for: .normal)
    segmentedControl.setTitleTextAttributes(selectedAttributes, for: .selected)
    segmentedControl.layer.cornerRadius = 12
    segmentedControl.clipsToBounds = true
    return segmentedControl
  }()
  
  private let tableView: UITableView = {
    let tableView = UITableView()
    tableView.backgroundColor = .clear
    tableView.separatorStyle = .none
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 240
    tableView.showsVerticalScrollIndicator = false
    tableView.register(ComputerClubCell.self, forCellReuseIdentifier: ComputerClubCell.identifier)
    return tableView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupConstraints()
    setupTableView()
    setupViewToggle()
    setupMapViewController()
    
    
    interactor?.fetchClubs()
  }
  
  private func setupViews() {
    view.backgroundColor = .white
    view.addSubview(titleLabel)
    view.addSubview(searchContainer)
    searchContainer.addSubview(searchIcon)
    searchContainer.addSubview(searchField)
    view.addSubview(viewToggle)
    view.addSubview(tableView)
  }
  
  private func setupConstraints() {
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    searchContainer.translatesAutoresizingMaskIntoConstraints = false
    searchIcon.translatesAutoresizingMaskIntoConstraints = false
    searchField.translatesAutoresizingMaskIntoConstraints = false
    viewToggle.translatesAutoresizingMaskIntoConstraints = false
    tableView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
      titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      
      searchContainer.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
      searchContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      searchContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      searchContainer.heightAnchor.constraint(equalToConstant: 44),
      
      searchIcon.centerYAnchor.constraint(equalTo: searchContainer.centerYAnchor),
      searchIcon.leadingAnchor.constraint(equalTo: searchContainer.leadingAnchor, constant: 12),
      searchIcon.widthAnchor.constraint(equalToConstant: 22),
      searchIcon.heightAnchor.constraint(equalToConstant: 22),
      
      searchField.centerYAnchor.constraint(equalTo: searchContainer.centerYAnchor),
      searchField.leadingAnchor.constraint(equalTo: searchIcon.trailingAnchor, constant: 8),
      searchField.trailingAnchor.constraint(equalTo: searchContainer.trailingAnchor, constant: -8),
      searchField.heightAnchor.constraint(equalTo: searchContainer.heightAnchor),
      
      viewToggle.topAnchor.constraint(equalTo: searchContainer.bottomAnchor, constant: 16),
      viewToggle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      viewToggle.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      viewToggle.heightAnchor.constraint(equalToConstant: 40),
      
      tableView.topAnchor.constraint(equalTo: viewToggle.bottomAnchor, constant: 10),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
  }
  
  private func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  private func setupViewToggle() {
    viewToggle.addTarget(self, action: #selector(viewToggleChanged), for: .valueChanged)
  }
  
  private func setupMapViewController() {
    guard let mapVC = MapAssembly().assembly() as? MapViewController else { return }
    addChild(mapVC)
    view.addSubview(mapVC.view)
    mapVC.view.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      mapVC.view.topAnchor.constraint(equalTo: viewToggle.bottomAnchor, constant: 10),
      mapVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      mapVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      mapVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
    mapVC.didMove(toParent: self)
    mapVC.view.isHidden = true
    self.mapViewController = mapVC
  }
  
  @objc private func viewToggleChanged() {
    if viewToggle.selectedSegmentIndex == 0 {
      tableView.isHidden = false
      mapViewController?.view.isHidden = true
    } else {
      tableView.isHidden = true
      mapViewController?.view.isHidden = false
//      mapViewController?.updateClubs(clubs)
    }
  }
  
  // MARK: - MainViewProtocol
  
  func showClubs(_ clubs: [ComputerClub]) {
    self.clubs = clubs
    tableView.reloadData()
//    mapViewController?.updateClubs(clubs)
  }
  
  func showError(_ message: String) {
    let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    present(alert, animated: true)
  }
  
  func showLoaderView() {
    //TODO: Сделать
  }
  
  func hideLoaderView() {
    //TODO: Сделать
  }
  
  // MARK: - UITableViewDataSource
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return clubs.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: ComputerClubCell.identifier, for: indexPath) as? ComputerClubCell else {
      return UITableViewCell()
    }
    
    let club = clubs[indexPath.row]
    cell.configure(with: club)
    cell.onAddressTap = { [weak self] in
      self?.openMapForAddress(club.address)
    }
    return cell
  }
  
  // MARK: - UITableViewDelegate
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let club = clubs[indexPath.row]
    interactor?.routeToClubDetails(with: club)
  }
}

// MARK: - UISearchBarDelegate
extension MainViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    // Implement search functionality
  }
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }
}

extension MainViewController {
  func openMapForAddress(_ address: String) {
    let encoded = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? address
    if let url = URL(string: "yandexmaps://maps.yandex.ru/?text=\(encoded)") {
      if UIApplication.shared.canOpenURL(url) {
        UIApplication.shared.open(url)
      } else {
        // Если Яндекс Карты не установлены, открываем в браузере
        if let webUrl = URL(string: "https://yandex.ru/maps/?text=\(encoded)") {
          UIApplication.shared.open(webUrl)
        }
      }
    }
  }
}

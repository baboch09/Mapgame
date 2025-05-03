import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
  var interactor: MapInteractorProtocol?
  private let locationManager = CLLocationManager()
  
  let mapView : MKMapView = {
    let map = MKMapView()
    map.showsUserLocation = true
    map.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: "CustomAnnotation")
    return map
  }()
  
  let locationButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(systemName: "location.fill"), for: .normal)
    button.backgroundColor = .white
    button.tintColor = .black
    button.layer.cornerRadius = 12
    button.layer.shadowColor = UIColor.black.cgColor
    button.layer.shadowOffset = CGSize(width: 0, height: 2)
    button.layer.shadowRadius = 2
    button.layer.shadowOpacity = 0.2
    button.translatesAutoresizingMaskIntoConstraints = false
    button.widthAnchor.constraint(equalToConstant: 50).isActive = true
    button.heightAnchor.constraint(equalToConstant: 50).isActive = true
    return button
  }()
  
  let nearestButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(systemName: "mappin.and.ellipse"), for: .normal)
    button.setTitle("Рядом", for: .normal)
    button.backgroundColor = .white
    button.tintColor = .black
    button.layer.cornerRadius = 12
    button.layer.shadowColor = UIColor.black.cgColor
    button.layer.shadowOffset = CGSize(width: 0, height: 2)
    button.layer.shadowRadius = 2
    button.layer.shadowOpacity = 0.2
    button.translatesAutoresizingMaskIntoConstraints = false
    button.widthAnchor.constraint(equalToConstant: 100).isActive = true
    button.heightAnchor.constraint(equalToConstant: 50).isActive = true
    return button
  }()
  
  let clubPopup: CustomMapPopup = {
    let popup = CustomMapPopup(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    popup.translatesAutoresizingMaskIntoConstraints = false
    return popup
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    setupViews()
    setupLocationManager()
    

    let cityCenter = CLLocationCoordinate2D(latitude: 59.9342802, longitude: 30.3350986)
    
    // Устанавливаем регион (широкий охват = только город)
    let region = MKCoordinateRegion(
      center: cityCenter,
      span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    ) // Масштаб под город
    mapView.setRegion(region, animated: true)
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    interactor?.fetchClubs()
  }
  
  private func setupViews() {
    mapView.delegate = self
    
    view.addSubview(mapView)
    mapView.translatesAutoresizingMaskIntoConstraints = false
    mapView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
    mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    mapView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
    mapView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    
    view.addSubview(locationButton)
    locationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
    locationButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
    
    view.addSubview(nearestButton)
    nearestButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
    nearestButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
  }
  
  private func setupLocationManager() {
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestWhenInUseAuthorization()
    
    locationButton.addTarget(self, action: #selector(locationButtonTapped), for: .touchUpInside)
    nearestButton.addTarget(self, action: #selector(nearestButtonTapped), for: .touchUpInside)
    
  }
  
  @objc private func locationButtonTapped() {
    locationManager.startUpdatingLocation()
  }
  
  @objc private func nearestButtonTapped() {
    guard let userLocation = mapView.userLocation.location else {
      print("Нет данных о геолокации пользователя")
      return
    }
    
    let annotations = mapView.annotations.filter { !($0 is MKUserLocation) }
    guard !annotations.isEmpty else {
      print("Нет аннотаций на карте")
      return
    }
    
    let nearestAnnotation = annotations.min { (a, b) -> Bool in
      let locA = CLLocation(latitude: a.coordinate.latitude, longitude: a.coordinate.longitude)
      let locB = CLLocation(latitude: b.coordinate.latitude, longitude: b.coordinate.longitude)
      return locA.distance(from: userLocation) < locB.distance(from: userLocation)
    }
    
    if let nearest = nearestAnnotation {
      mapView.selectAnnotation(nearest, animated: true)
      let region = MKCoordinateRegion(center: nearest.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
      mapView.setRegion(region, animated: true)
    }
  }
}

extension MapViewController: MapViewProtocol {
  func shopClubPopup(_ club: ComputerClub) {
    clubPopup.configure(with: club)
    view.addSubview(clubPopup)
    
    clubPopup.onClose = { [weak self] in
      self?.mapViewDeselectAnnotation()
    }
    clubPopup.onDetails = { [weak self] in
      let clubDetailsVC = ClubDetailViewController(club: club)
      self?.mapViewDeselectAnnotation()
      self?.navigationController?.pushViewController(clubDetailsVC, animated: true)
    }
    
    NSLayoutConstraint.activate([
      clubPopup.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      clubPopup.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      clubPopup.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
    ])
  }
  
  func showClubs(_ geocodedClubs: [(club: ComputerClub, coordinate: CLLocationCoordinate2D)]) {
    let oldAnnotations = mapView.annotations.filter { !($0 is MKUserLocation) }
    mapView.removeAnnotations(oldAnnotations)
    
    let clubsPins = geocodedClubs.map { club, coordinate in
      CustomAnnotation(
        coordinate: coordinate,
        title: club.name,
        subtitle: club.address,
        clubID: club.id,
        hasLicense: club.hasLicense
      )
    }
    
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.mapView.addAnnotations(clubsPins)
      
      if !clubsPins.isEmpty {
        self.mapView.showAnnotations(clubsPins, animated: true)
      }
    }
  }
  
  func showError(_ message: String) { }
}

extension MapViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard annotation is CustomAnnotation else {
      return nil
    }
    
    let identifier = "CustomAnnotation"
    var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? CustomAnnotationView
    
    if annotationView == nil {
      annotationView = CustomAnnotationView(annotation: annotation, reuseIdentifier: identifier)
    } else {
      annotationView?.annotation = annotation
    }
    
    return annotationView
  }
  
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    if let annotation = view.annotation as? CustomAnnotation, let clubId = annotation.clubID {
      interactor?.assemblePopup(clubId)
    }
  }
  
  private func mapViewDeselectAnnotation() {
    mapView.selectedAnnotations.forEach { mapView.deselectAnnotation($0, animated: false) }
    clubPopup.removeFromSuperview()
  }
}

extension MapViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.first else { return }
    
    let coordinate = location.coordinate
    let region = MKCoordinateRegion(
      center: coordinate,
      span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    mapView.setRegion(region, animated: true)
    
    locationManager.stopUpdatingLocation()
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Ошибка определения местоположения: \(error.localizedDescription)")
  }
}

import MapKit

class CustomAnnotation: NSObject, MKAnnotation {
  let coordinate: CLLocationCoordinate2D
  let title: String?
  let subtitle: String?
  let clubID: String?
  let hasLicense: Bool
  
  init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, clubID: String, hasLicense: Bool = false) {
    self.coordinate = coordinate
    self.clubID = clubID
    self.title = title
    self.subtitle = subtitle
    self.hasLicense = hasLicense
    
    super.init()
  }
}

class CustomAnnotationView: MKMarkerAnnotationView {
  override var annotation: MKAnnotation? {
    didSet {
      guard let customAnnotation = annotation as? CustomAnnotation else { return }
      
      // Настройка внешнего вида маркера
      markerTintColor = customAnnotation.hasLicense ? UIColor.rayFlower : .red
      glyphImage = UIImage(systemName: "gamecontroller.fill")
      glyphTintColor = .white
      
      // Настройка всплывающего окна
      canShowCallout = true
      
    }
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    if selected {
      jumpAnimation()
    }//Todo: останавливать анимацию
  }
  
  func jumpAnimation() {
    let jump = CABasicAnimation(keyPath: "position.y")
    jump.byValue = -15
    jump.duration = 0.2
    jump.autoreverses = true
    jump.repeatCount = 2
    layer.add(jump, forKey: "jump")
  }
}

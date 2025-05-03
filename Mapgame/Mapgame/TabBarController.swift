
import UIKit

class TabBarController: UITabBarController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViewControllers()
    setupTabBarAppeareance()
  }
  
  private func setupViewControllers() {
    let mainVC = MainAssembly().assembly()
    mainVC.tabBarItem = UITabBarItem(title: "Главная", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
    
    let promotionsVC = PromotionsAssembly().assembly()
    promotionsVC.tabBarItem = UITabBarItem(title: "Акции", image: UIImage(systemName: "tag"), selectedImage: UIImage(systemName: "tag.fill"))
    
    let profileVC = UIViewController() // Заглушка для профиля
    profileVC.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))
    
    viewControllers = [
      mainVC,
      promotionsVC,
      UINavigationController(rootViewController: profileVC)
    ]
  }
  
  func setupTabBarAppeareance() {
    let itemCount: CGFloat = 4
    let posX: CGFloat = 16
    let posY: CGFloat = 8
    let width = tabBar.bounds.width - posX * 2
    let height = tabBar.bounds.height + posY * 2
    let blurRect = CGRect(
      x: 0,
      y: tabBar.bounds.minY - posY,
      width: tabBar.bounds.width,
      height: tabBar.bounds.height + height
    )
    let tabBarRect = CGRect(
      x: posX,
      y: tabBar.bounds.minY - posY,
      width: width,
      height: height
    )
    
    // Blur
    let blurEffect = UIBlurEffect(style: .light)
    let blurView = UIVisualEffectView(effect: blurEffect)
    blurView.frame = blurRect
    blurView.layer.cornerRadius = 0
    blurView.clipsToBounds = true
    tabBar.insertSubview(blurView, at: 0)
    
    //Tabbar
    let roundLayer = CAShapeLayer()
    let bezierPath = UIBezierPath(
      roundedRect: tabBarRect,
      cornerRadius: 12
    )
    roundLayer.path = bezierPath.cgPath
    tabBar.layer.insertSublayer(roundLayer, at: 1)
    
    
    tabBar.itemWidth = width / itemCount
    tabBar.itemPositioning = .centered
    
    roundLayer.fillColor = UIColor.rayFlower.cgColor
    
    tabBar.tintColor = .black
    tabBar.unselectedItemTintColor = .gray
  }
}

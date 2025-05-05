
import UIKit
import Lottie

class TabBarController: UITabBarController {
  var lotties: [TabBarItemView] = []
  private let animationNames: [TabBarItemType] = [.home, .promo, .profile]
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViewControllers()
    setupTabBarAppeareance()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    setupTabBarItems()
  }
  
  private func setupViewControllers() {
    let mainVC = MainAssembly().assembly()
    mainVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(), selectedImage: UIImage())
    
    let promotionsVC = PromotionsAssembly().assembly()
    promotionsVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(), selectedImage: UIImage())
    
    let profileVC = UIViewController() // Заглушка для профиля
    profileVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(), selectedImage: UIImage())
    
    viewControllers = [
      mainVC,
      promotionsVC,
      UINavigationController(rootViewController: profileVC)
    ]
  }
  
  func setupTabBarAppeareance() {
    guard let items = tabBar.items else { return }
    
    let itemCount = CGFloat(items.count)
    let posX: CGFloat = 16
    let posY: CGFloat = 8
    let width = tabBar.bounds.width - posX * 2
    let height = tabBar.bounds.height + posY * 2
    
    // Blur
    let blurEffect = UIBlurEffect(style: .light)
    let blurView = UIVisualEffectView(effect: blurEffect)
    blurView.frame = CGRect(
      x: 0,
      y: tabBar.bounds.minY - posY,
      width: tabBar.bounds.width,
      height: tabBar.bounds.height + height
    )
    tabBar.insertSubview(blurView, at: 0)
    
    //Tabbar
    let tabBarLayer = CAShapeLayer()
    let tabBarRect = CGRect(
      x: posX,
      y: tabBar.bounds.minY - posY,
      width: width,
      height: height
    )
    let tabBarPath = UIBezierPath(
      roundedRect: tabBarRect,
      cornerRadius: 12
    )
    tabBarLayer.path = tabBarPath.cgPath
    tabBarLayer.fillColor = UIColor.rayFlower.cgColor
    tabBar.layer.insertSublayer(tabBarLayer, at: 1)
    
    
    tabBar.itemWidth = width / itemCount
  }
  
  func setupTabBarItems() {
    guard let tabBarItems = tabBar.items else { return }
    
    let tabBarButtons = tabBar.subviews.filter { String(describing: type(of: $0)) == "UITabBarButton" }
    guard tabBarButtons.count == tabBarItems.count else { return }
    
    for (index, button) in tabBarButtons.enumerated() {
      
      let lottieView = TabBarItemView(viewType: animationNames[index])
      lottieView.setColor(selectedIndex == index ? .black : .gray)
      lottieView.translatesAutoresizingMaskIntoConstraints = false
      button.addSubview(lottieView)
      
      NSLayoutConstraint.activate([
        lottieView.centerXAnchor.constraint(equalTo: button.centerXAnchor)
      ])
      
      lotties.append(lottieView)
    }
    lotties[selectedIndex].play()
  }
}

extension TabBarController {
  override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
    guard let index = tabBar.items?.firstIndex(of: item) else { return }
    for (i, view) in lotties.enumerated() {
      if i == index {
        view.setColor(.black)
        view.play()
      } else {
        view.setColor(.gray)
        view.stop()
      }
    }
  }
}

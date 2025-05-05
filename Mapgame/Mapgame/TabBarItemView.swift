//
//  TabBarItemView.swift
//  Mapgame
//
//  Created by Бабочиев Эдуард Таймуразович on 04.05.2025.
//

import UIKit
import Lottie


class TabBarItemView: UIView {
  private let animationView: LottieAnimationView
  var animationType: TabBarItemType
  
  init(viewType: TabBarItemType) {
    animationView = .init(name: viewType.name)
    animationType = viewType
    
    super.init(frame: .zero)
    setupView()
  }
  
  private func setupView() {
    animationView.translatesAutoresizingMaskIntoConstraints = false
    animationView.contentMode = .scaleAspectFit
    animationView.loopMode = .playOnce
    animationView.backgroundColor = .clear
    
    addSubview(animationView)
    setupConstraints(type: animationType)
  }
  
  func setColor(_ uiColor: UIColor) {
    let colorValue = uiColor.lottieColorValue
    
    let keypaths = [
        "**.Fill 1.Color",
        "**.Stroke 1.Color"
    ]
    
    for path in keypaths {
      let provider = ColorValueProvider(colorValue)
      animationView.setValueProvider(provider, keypath: AnimationKeypath(keypath: path))
    }
  }
  
  func play() {
    animationView.play()
  }
  
  func stop() {
    animationView.stop()
    animationView.currentProgress = 0
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension TabBarItemView {
  func setupConstraints(type: TabBarItemType) {
    switch type {
    case .home:
      setupSizeConstraints(widht: 50, height: 50)
      animationView.topAnchor.constraint(equalTo: topAnchor, constant: -5).isActive = true
    case .promo:
      setupSizeConstraints(widht: 45, height: 45)
      animationView.topAnchor.constraint(equalTo: topAnchor, constant: 3).isActive = true
    case .profile:
      setupSizeConstraints(widht: 40, height: 40)
      animationView.topAnchor.constraint(equalTo: topAnchor, constant: 3).isActive = true
    }
    
    NSLayoutConstraint.activate([
      animationView.bottomAnchor.constraint(equalTo: bottomAnchor),
      animationView.leadingAnchor.constraint(equalTo: leadingAnchor),
      animationView.trailingAnchor.constraint(equalTo: trailingAnchor)
    ])
  }
  
  func setupSizeConstraints(widht: CGFloat, height: CGFloat) {
    NSLayoutConstraint.activate([
      animationView.widthAnchor.constraint(equalToConstant: widht),
      animationView.heightAnchor.constraint(equalToConstant: height),
    ])
  }
}

extension TabBarItemView {
  override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    return false
  }
}


public enum TabBarItemType: String {
  case home = "home"
  case promo = "promo"
  case profile = "profile"
  
  var name: String {
    return rawValue
  }
}

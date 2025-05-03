import UIKit

class CustomMapPopup: UIView {
  // MARK: - UI Elements
  private let titleLabel = UILabel()
  private let addressLabel = UILabel()
  private let licenseLabel = UILabel()
  
  private lazy var closeButton: UIButton = {
    let button = UIButton(type: .system)
    button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
    button.tintColor = .gray
    button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    return button
  }()
  
  private lazy var detailsButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Подробнее", for: .normal)
    button.backgroundColor = .rayFlower
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 8
    button.addTarget(self, action: #selector(detailsButtonTapped), for: .touchUpInside)
    return button
  }()
  
  // MARK: - Callbacks
  var onClose: (() -> Void)?
  var onDetails: (() -> Void)?
  
  // MARK: - Initialization
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupUI()
  }
  
  // MARK: - Setup
  private func setupUI() {
    setupContainerView()
    setupLabels()
    setupButtons()
    setupConstraints()
  }
  
  private func setupContainerView() {
    backgroundColor = .white
    layer.cornerRadius = 16
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOpacity = 0.2
    layer.shadowOffset = CGSize(width: 0, height: 4)
    layer.shadowRadius = 8
    
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  private func setupLabels() {
    // Title Label
    titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
    titleLabel.textColor = .black
    titleLabel.numberOfLines = 0
    addSubview(titleLabel)
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    // Address Label
    addressLabel.font = .systemFont(ofSize: 14)
    addressLabel.textColor = .gray
    addressLabel.numberOfLines = 0
    addSubview(addressLabel)
    addressLabel.translatesAutoresizingMaskIntoConstraints = false
    
    // License Label
    licenseLabel.font = .systemFont(ofSize: 14)
    addSubview(licenseLabel)
    licenseLabel.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private func setupButtons() {
    addSubview(closeButton)
    closeButton.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(detailsButton)
    detailsButton.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      // Container View
      leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
      trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
      bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
      
      // Close Button
      closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 12),
      closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
      closeButton.widthAnchor.constraint(equalToConstant: 24),
      closeButton.heightAnchor.constraint(equalToConstant: 24),
      
      // Title Label
      titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      titleLabel.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -8),
      
      // Address Label
      addressLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
      addressLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      addressLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      
      // License Label
      licenseLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 8),
      licenseLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      
      // Details Button
      detailsButton.topAnchor.constraint(equalTo: licenseLabel.bottomAnchor, constant: 16),
      detailsButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      detailsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      detailsButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
      detailsButton.heightAnchor.constraint(equalToConstant: 44)
    ])
  }
  
  // MARK: - Configuration
  func configure(with club: ComputerClub) {
    titleLabel.text = club.name
    addressLabel.text = club.address
    licenseLabel.text = club.hasLicense ? "✅ Есть лицензия" : "❌ Нет лицензии"
    licenseLabel.textColor = club.hasLicense ? .systemGreen : .systemRed
  }
  
  // MARK: - Actions
  @objc private func closeButtonTapped() {
    onClose?()
  }
  
  @objc private func detailsButtonTapped() {
    onDetails?()
  }
}

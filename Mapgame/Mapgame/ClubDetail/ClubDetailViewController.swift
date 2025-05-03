import UIKit

class ClubDetailViewController: UIViewController {
  
  private let club: ComputerClub
  
  private let scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.showsVerticalScrollIndicator = false
    return scrollView
  }()
  
  private let contentView: UIView = {
    let view = UIView()
    return view
  }()
  
  private let clubImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "CompPlaceholder")
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 16
    return imageView
  }()
  
  private let nameLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 28, weight: .bold)
    label.numberOfLines = 0
    return label
  }()
  
  private let addressLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16)
    label.textColor = .gray
    label.numberOfLines = 0
    return label
  }()
  
  private let licenseStatusView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 12
    return view
  }()
  
  private let licenseLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16, weight: .medium)
    return label
  }()
  
  private let infoStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 16
    stackView.distribution = .fill
    return stackView
  }()
  
  private let workingHoursView: UIView = {
    let view = UIView()
    view.backgroundColor = .systemGray6
    view.layer.cornerRadius = 12
    return view
  }()
  
  private let workingHoursLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16)
    label.text = "Working Hours: 24/7"
    return label
  }()
  
  private let priceView: UIView = {
    let view = UIView()
    view.backgroundColor = .systemGray6
    view.layer.cornerRadius = 12
    return view
  }()
  
  private let priceLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16)
    label.text = "Price: 200₽/hour"
    return label
  }()
  
  private let descriptionView: UIView = {
    let view = UIView()
    view.backgroundColor = .systemGray6
    view.layer.cornerRadius = 12
    return view
  }()
  
  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16)
    label.numberOfLines = 0
    label.text = "Modern gaming club with high-end equipment and comfortable gaming stations. Perfect for both casual and professional gamers."
    return label
  }()
  
  private let callButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Call Club", for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
    button.backgroundColor = .rayFlower
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 12
    return button
  }()
  
  init(club: ComputerClub) {
    self.club = club
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupConstraints()
    configureWithClub()
  }
  
  private func setupViews() {
    navigationController?.navigationBar.isHidden = false
    view.backgroundColor = .systemBackground
    title = "Club Details"
    
    view.addSubview(scrollView)
    scrollView.addSubview(contentView)
    
    contentView.addSubview(clubImageView)
    contentView.addSubview(nameLabel)
    contentView.addSubview(addressLabel)
    contentView.addSubview(licenseStatusView)
    licenseStatusView.addSubview(licenseLabel)
    
    contentView.addSubview(infoStackView)
    infoStackView.addArrangedSubview(workingHoursView)
    infoStackView.addArrangedSubview(priceView)
    infoStackView.addArrangedSubview(descriptionView)
    
    workingHoursView.addSubview(workingHoursLabel)
    priceView.addSubview(priceLabel)
    descriptionView.addSubview(descriptionLabel)
    
    contentView.addSubview(callButton)
  }
  
  private func setupConstraints() {
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    contentView.translatesAutoresizingMaskIntoConstraints = false
    clubImageView.translatesAutoresizingMaskIntoConstraints = false
    nameLabel.translatesAutoresizingMaskIntoConstraints = false
    addressLabel.translatesAutoresizingMaskIntoConstraints = false
    licenseStatusView.translatesAutoresizingMaskIntoConstraints = false
    licenseLabel.translatesAutoresizingMaskIntoConstraints = false
    infoStackView.translatesAutoresizingMaskIntoConstraints = false
    workingHoursLabel.translatesAutoresizingMaskIntoConstraints = false
    priceLabel.translatesAutoresizingMaskIntoConstraints = false
    descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
    callButton.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      
      contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
      contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
      contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
      contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
      contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
      
      clubImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
      clubImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      clubImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      clubImageView.heightAnchor.constraint(equalToConstant: 250),
      
      nameLabel.topAnchor.constraint(equalTo: clubImageView.bottomAnchor, constant: 20),
      nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      
      addressLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
      addressLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      addressLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      
      licenseStatusView.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 16),
      licenseStatusView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      licenseStatusView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      licenseStatusView.heightAnchor.constraint(equalToConstant: 40),
      
      licenseLabel.centerXAnchor.constraint(equalTo: licenseStatusView.centerXAnchor),
      licenseLabel.centerYAnchor.constraint(equalTo: licenseStatusView.centerYAnchor),
      
      infoStackView.topAnchor.constraint(equalTo: licenseStatusView.bottomAnchor, constant: 20),
      infoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      infoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      
      workingHoursLabel.leadingAnchor.constraint(equalTo: workingHoursView.leadingAnchor, constant: 16),
      workingHoursLabel.trailingAnchor.constraint(equalTo: workingHoursView.trailingAnchor, constant: -16),
      workingHoursLabel.topAnchor.constraint(equalTo: workingHoursView.topAnchor, constant: 12),
      workingHoursLabel.bottomAnchor.constraint(equalTo: workingHoursView.bottomAnchor, constant: -12),
      
      priceLabel.leadingAnchor.constraint(equalTo: priceView.leadingAnchor, constant: 16),
      priceLabel.trailingAnchor.constraint(equalTo: priceView.trailingAnchor, constant: -16),
      priceLabel.topAnchor.constraint(equalTo: priceView.topAnchor, constant: 12),
      priceLabel.bottomAnchor.constraint(equalTo: priceView.bottomAnchor, constant: -12),
      
      descriptionLabel.leadingAnchor.constraint(equalTo: descriptionView.leadingAnchor, constant: 16),
      descriptionLabel.trailingAnchor.constraint(equalTo: descriptionView.trailingAnchor, constant: -16),
      descriptionLabel.topAnchor.constraint(equalTo: descriptionView.topAnchor, constant: 12),
      descriptionLabel.bottomAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: -12),
      
      callButton.topAnchor.constraint(equalTo: infoStackView.bottomAnchor, constant: 24),
      callButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      callButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      callButton.heightAnchor.constraint(equalToConstant: 50),
      callButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
    ])
  }
  
  private func configureWithClub() {
    nameLabel.text = club.name
    addressLabel.text = club.address
    
    if club.hasLicense {
      licenseStatusView.backgroundColor = .systemGreen.withAlphaComponent(0.2)
      licenseLabel.text = "Licensed"
      licenseLabel.textColor = .rayFlower
    } else {
      licenseStatusView.backgroundColor = .systemRed.withAlphaComponent(0.2)
      licenseLabel.text = "Not Licensed"
      licenseLabel.textColor = .systemRed
    }
    
    // Load image from URL (you'll need to implement image loading)
    if let url = URL(string: club.imageURL) {
      // Implement image loading here
    }
  }
}

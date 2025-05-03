import UIKit

class ComputerClubCell: UITableViewCell {
  static let identifier = "ComputerClubCell"
  
  var onAddressTap: (() -> Void)?
  
  private let cardView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.layer.cornerRadius = 20
    view.layer.shadowColor = UIColor.rayFlowerBackground.cgColor
    view.layer.shadowOpacity = 1
    view.layer.shadowOffset = CGSize(width: 0, height: 2)
    view.layer.shadowRadius = 8
    view.layer.masksToBounds = false
    return view
  }()
  
  private let clubImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 16
    imageView.backgroundColor = .systemGray5
    return imageView
  }()
  
  private let nameLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 20, weight: .bold)
    label.numberOfLines = 2
    label.textColor = .black
    return label
  }()
  
  private let addressLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16)
    label.numberOfLines = 0
    label.isUserInteractionEnabled = true
    return label
  }()
  
  private let licenseLabel: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 16)
    label.textColor = UIColor.systemRed // Для отладки
    label.numberOfLines = 1
    return label
  }()
  
  private let infoStack: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.spacing = 6
    stack.alignment = .leading
    return stack
  }()
  
  private var imageTask: URLSessionDataTask?
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    backgroundColor = .clear
    selectionStyle = .none
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    clubImageView.image = nil
    imageTask?.cancel()
  }
  
  private func setupViews() {
    contentView.addSubview(cardView)
    cardView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
      cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
      cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
      cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
    ])
    
    cardView.addSubview(clubImageView)
    clubImageView.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      clubImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 0),
      clubImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 0),
      clubImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: 0),
      clubImageView.heightAnchor.constraint(equalToConstant: 201)
    ])
    
    cardView.addSubview(infoStack)
    infoStack.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      infoStack.topAnchor.constraint(equalTo: clubImageView.bottomAnchor, constant: 16),
      infoStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
      infoStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
      infoStack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -24)
    ])
    
    infoStack.addArrangedSubview(nameLabel)
    infoStack.addArrangedSubview(addressLabel)
    infoStack.addArrangedSubview(licenseLabel)
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(addressTapped))
    addressLabel.addGestureRecognizer(tap)
  }
  
  @objc private func addressTapped() {
    onAddressTap?()
  }
  
  func configure(with club: ComputerClub) {
    print("CONFIGURE:", club.name, club.address, club.hasLicense)
    nameLabel.text = club.name
    
    // Адрес как ссылка (синий, подчёркнутый)
    let attributedAddress = NSAttributedString(
      string: club.address,
      attributes: [
        .foregroundColor: UIColor.gray,
        .underlineStyle: NSUnderlineStyle.single.rawValue
      ]
    )
    addressLabel.attributedText = attributedAddress
    
    licenseLabel.text = club.hasLicense ? "Проверенный клуб" : "Не проверенный клуб"
    licenseLabel.textColor = club.hasLicense ? UIColor.systemGreen : UIColor.systemRed
    
    // Загрузка картинки из интернета
    clubImageView.image = UIImage(named: "placeholder")
    if let url = URL(string: club.imageURL) {
      imageTask = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
        guard let self = self, let data = data, let image = UIImage(data: data) else { return }
        DispatchQueue.main.async {
          self.clubImageView.image = image
        }
      }
      imageTask?.resume()
    }
  }
}

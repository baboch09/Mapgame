import UIKit

struct Promotion {
    let id: String
    let title: String
    let description: String
    let imageURL: String
    let validUntil: String
}

class PromotionsViewController: UIViewController, PromotionsViewProtocol, UITableViewDataSource, UITableViewDelegate {
    var interactor: PromotionsInteractorProtocol?
    
    private let tableView = UITableView()
    private var promotions: [Promotion] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Акции"
        view.backgroundColor = .white
        setupTableView()
      
        interactor?.fetchPromotions()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PromotionCell.self, forCellReuseIdentifier: "PromotionCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.rowHeight = 160
    }
    
    // MARK: - PromotionsViewProtocol
    
    func showPromotions(_ promotions: [Promotion]) {
        print("PromotionsViewController: showPromotions called with \(promotions.count) promotions")
        self.promotions = promotions
        tableView.reloadData()
    }
    
    func showError(_ message: String) {
        print("PromotionsViewController: showError called with message: \(message)")
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("PromotionsViewController: numberOfRowsInSection called, promotions.count = \(promotions.count)")
        return promotions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PromotionCell", for: indexPath) as! PromotionCell
        cell.configure(with: promotions[indexPath.row])
        return cell
    }
}

class PromotionCell: UITableViewCell {
    private let promoImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descLabel = UILabel()
    private let dateLabel = UILabel()
    private let cardView = UIView()
    private var imageTask: URLSessionDataTask?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        setupViews()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        promoImageView.image = nil
        imageTask?.cancel()
    }
    
    private func setupViews() {
        contentView.addSubview(cardView)
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 18
        cardView.layer.shadowColor = UIColor.black.withAlphaComponent(0.08).cgColor
        cardView.layer.shadowOpacity = 1
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 8
        cardView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
        
        cardView.addSubview(promoImageView)
        promoImageView.translatesAutoresizingMaskIntoConstraints = false
        promoImageView.contentMode = .scaleAspectFill
        promoImageView.clipsToBounds = true
        promoImageView.layer.cornerRadius = 14
        NSLayoutConstraint.activate([
            promoImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 10),
            promoImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 10),
            promoImageView.widthAnchor.constraint(equalToConstant: 120),
            promoImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        let vStack = UIStackView(arrangedSubviews: [titleLabel, descLabel, dateLabel])
        vStack.axis = .vertical
        vStack.spacing = 6
        vStack.alignment = .leading
        cardView.addSubview(vStack)
        vStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            vStack.leadingAnchor.constraint(equalTo: promoImageView.trailingAnchor, constant: 14),
            vStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            vStack.bottomAnchor.constraint(lessThanOrEqualTo: cardView.bottomAnchor, constant: -12)
        ])
        
        titleLabel.font = .systemFont(ofSize: 17, weight: .bold)
        titleLabel.textColor = .black
        descLabel.font = .systemFont(ofSize: 15)
        descLabel.textColor = .darkGray
        descLabel.numberOfLines = 2
        dateLabel.font = .systemFont(ofSize: 14)
        dateLabel.textColor = .systemBlue
    }
    
    func configure(with promo: Promotion) {
        titleLabel.text = promo.title
        descLabel.text = promo.description
        dateLabel.text = promo.validUntil
        promoImageView.image = UIImage(named: "placeholder")
        
        if let url = URL(string: promo.imageURL) {
            imageTask = URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                guard let self = self, let data = data, let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    self.promoImageView.image = image
                }
            }
            imageTask?.resume()
        }
    }
} 

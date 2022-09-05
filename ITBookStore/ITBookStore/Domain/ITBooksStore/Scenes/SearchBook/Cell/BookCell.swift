import Foundation
import UIKit

class BookCell: UITableViewCell {
    
    static let identifier: String = "bookCell"
    
    // MARK: UI Setup
    let coverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 14
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "photo.circle")
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        separatorInset = .zero
        selectionStyle = .gray
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupConstraints() {
        // Container View Setup
        addSubview(containerView)
        containerView.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 12).isActive = true
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12).isActive = true
        // Image Setup
        containerView.addSubview(coverImage)
        coverImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        coverImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        coverImage.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12).isActive = true
        // Label Setup
        containerView.addSubview(titleLabel)
        titleLabel.centerYAnchor.constraint(equalTo: coverImage.centerYAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: coverImage.trailingAnchor, constant: 8).isActive = true
    }
    
    func configure(with img: String, title: String) {
        self.titleLabel.text = title
    }
    
}

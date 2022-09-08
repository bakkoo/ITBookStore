import Foundation
import UIKit

class BookCell: UITableViewCell {
    
    static let identifier: String = "bookCell"
    
    // MARK: UI Setup
    let coverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "photo.circle")
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .white
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
        contentView.backgroundColor = .black
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
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        // Image Setup
        containerView.addSubview(coverImage)
        coverImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        coverImage.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10).isActive = true
        coverImage.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10).isActive = true
        coverImage.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10).isActive = true
        // Label Setup
        containerView.addSubview(titleLabel)
        titleLabel.centerYAnchor.constraint(equalTo: coverImage.centerYAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: coverImage.trailingAnchor, constant: 8).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -20).isActive = true
        titleLabel.numberOfLines = 3
    }
    
    func configure(with img: UIImage?, title: String) {
        self.titleLabel.text = title
        self.coverImage.image = img
    }
    
}

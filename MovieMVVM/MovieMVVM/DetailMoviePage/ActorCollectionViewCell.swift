// ActorCollectionViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Настройка  Актеров
final class ActorCollectionViewCell: UICollectionViewCell {
    // MARK: Private Constant

    private enum Constants {
        static let getImageURL = "https://image.tmdb.org/t/p/w500"
    }

    // MARK: - Private Visual Components

    private let actorImageView: UIImageView = {
        let image = UIImageView(frame: CGRect(x: 5, y: 5, width: 140, height: 190))
        return image
    }()

    private let actorNameLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 5, y: 200, width: 140, height: 20))
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()

    private let actorRoleLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 5, y: 220, width: 140, height: 20))
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 13)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()

    // MARK: - Init

    override private init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("")
    }

    // MARK: - Private Metods

    private func setupUI() {
        addSubview(actorImageView)
        addSubview(actorNameLabel)
        addSubview(actorRoleLabel)
        actorImageView.layer.cornerRadius = 20
        actorImageView.clipsToBounds = true
    }

    // MARK: - Public Metods

    func setupActor(_ actror: Actor) {
        guard let urlImage = URL(string: "\(Constants.getImageURL) \(actror.actorImageName)") else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: urlImage) { data, _, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.actorImageView.image = image
            }
        }
        task.resume()
        actorNameLabel.text = actror.actorName
        actorRoleLabel.text = actror.actorRoleName
    }
}

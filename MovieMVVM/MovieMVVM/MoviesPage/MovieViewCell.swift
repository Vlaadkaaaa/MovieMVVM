// MovieViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Настройка ячейки с фильмом
final class MovieViewCell: UITableViewCell {
    // MARK: - Private Constants

    private enum Constants {
        static let imageURL = "https://image.tmdb.org/t/p/w500"
        static let movieAgeLimitTitle = "18+"
        static let oneStarImageName = "oneStar"
        static let twoStarImageName = "twoStar"
        static let threeStarImageName = "threeStar"
        static let fourStarImageName = "fourStar"
        static let fiveStarImageName = "fiveStar"
    }

    // MARK: - Private Visual Components

    private let moviePosterImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 10
        image.contentMode = .scaleToFill
        return image
    }()

    private let movieNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 17)
        return label
    }()

    private let genreNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 16)
        return label
    }()

    private let movieDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 15)
        return label
    }()

    private let movieAgeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.movieAgeLimitTitle
        label.font = .systemFont(ofSize: 15)
        label.textColor = .lightGray
        return label
    }()

    private let movieRatingImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()

    // MARK: - Init

    override private init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("")
    }

    // MARK: Methods

    func setupView(movie: Movies) {
        setupImage(movie: movie)
        setupLabel(movie: movie)
    }

    // MARK: Private Methods

    private func setupUI() {
        addSubview(moviePosterImageView)
        addSubview(movieNameLabel)
        addSubview(genreNameLabel)
        addSubview(movieDateLabel)
        addSubview(movieAgeLabel)
        addSubview(movieRatingImageView)
        configureConstraints()
    }

    private func setupImage(movie: Movies) {
        guard let urlImage = URL(string: Constants.imageURL + movie.movieImageName) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: urlImage) { data, _, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                self.moviePosterImageView.image = image
            }
        }
        task.resume()
        movieRatingImageView.image = {
            switch movie.ratingValue {
            case 0 ... 2: return UIImage(named: Constants.oneStarImageName)
            case 2 ... 4: return UIImage(named: Constants.twoStarImageName)
            case 4 ... 6: return UIImage(named: Constants.threeStarImageName)
            case 6 ... 8: return UIImage(named: Constants.fourStarImageName)
            case 8 ... 10: return UIImage(named: Constants.fiveStarImageName)
            default: return UIImage(named: Constants.oneStarImageName)
            }
        }()
    }

    private func setupLabel(movie: Movies) {
        genreNameLabel.text = movie.movieGenreName
        movieNameLabel.text = movie.movieNameText
        movieDateLabel.text = movie.movieDateText
    }

    private func configureConstraints() {
        NSLayoutConstraint.activate([
            moviePosterImageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            moviePosterImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            moviePosterImageView.heightAnchor.constraint(equalToConstant: 150),
            moviePosterImageView.widthAnchor.constraint(equalToConstant: 100),
            moviePosterImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            movieNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            movieNameLabel.leadingAnchor.constraint(equalTo: moviePosterImageView.trailingAnchor, constant: 20),
            movieNameLabel.widthAnchor.constraint(equalToConstant: 260),
            genreNameLabel.topAnchor.constraint(equalTo: movieNameLabel.bottomAnchor, constant: 5),
            genreNameLabel.leadingAnchor.constraint(equalTo: moviePosterImageView.trailingAnchor, constant: 20),
            movieDateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            movieDateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            movieAgeLabel.leadingAnchor.constraint(equalTo: moviePosterImageView.trailingAnchor, constant: 20),
            movieRatingImageView.topAnchor.constraint(equalTo: movieAgeLabel.bottomAnchor, constant: 0),
            movieRatingImageView.leadingAnchor.constraint(equalTo: moviePosterImageView.trailingAnchor, constant: 15),
            movieRatingImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -200),
            movieRatingImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            movieRatingImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}

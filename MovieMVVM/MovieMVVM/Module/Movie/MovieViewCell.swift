// MovieViewCell.swift
// Copyright © Vlaadkaaaa. All rights reserved.

import UIKit

/// Настройка ячейки с фильмом
final class MovieViewCell: UITableViewCell {
    // MARK: - Private Constants

    private enum Constants {
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

    private let imageNetwork: ImageNetworkServiceProtocol = ImageNetworkService()

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

    func configureCell(movie: Movie) {
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

    private func setupImage(movie: Movie) {
        imageNetwork.fetchImageData(path: movie.posterPath) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(data):
                DispatchQueue.main.async {
                    self.moviePosterImageView.image = UIImage(data: data)
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
        movieRatingImageView.image = UIImage(named: updateRating(voteAverage: movie.voteAverage))
    }

    private func updateRating(voteAverage: Double) -> String {
        switch voteAverage {
        case 0 ... 2: return Constants.oneStarImageName
        case 2 ... 4: return Constants.twoStarImageName
        case 4 ... 6: return Constants.threeStarImageName
        case 6 ... 8: return Constants.fourStarImageName
        case 8 ... 10: return Constants.fiveStarImageName
        default: return Constants.oneStarImageName
        }
    }

    private func setupLabel(movie: Movie) {
        movieNameLabel.text = movie.title
        genreNameLabel.text = movie.overview
        movieDateLabel.text = movie.releaseDate
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

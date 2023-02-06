// MoviesDescriptionViewController.swift
// Copyright © Vlaadkaaaa. All rights reserved.

import UIKit

/// Страница конкретного фильма
final class MoviesDescriptionViewController: UIViewController {
    // MARK: Private Constant

    private enum Constants {
        static let resultDateFormat = "yyyy-MM-dd"
        static let editDateFormat = "yyyy"
        static let watchImageName = "watch"
        static let actorCellIdentifier = "ActorCell"
        static let actorTitleText = "Актеры"
        static let descriptionTitleText = "Описание"
        static let starSystemImageName = "star.fill"
        static let bookmarkSystemImageName = "bookmark.fill"
        static let shareSystemImageName = "square.and.arrow.up.fill"
        static let moreSystemImageName = "ellipsis"
        static let favoriteTitleText = "Оценить"
        static let bookmarkTitleText = "Буду смотреть"
        static let shareTitleText = "Поделиться"
        static let moreTitleText = "Ещё"
        static let imageRequestURL = "https://image.tmdb.org/t/p/w500"
        static let apiRequestURL = "https://api.themoviedb.org/3/movie/"
        static let apiKeyURL = "api_key=d9e4494907230d135d6f6fd47beca82e"
        static let apiLanguageURL = "language=ru"
        static let apiResponseURL = "append_to_response=videos"
        static let apiCreditsGenreURL = "/credits"
    }

    // MARK: Private visual Components

    private let moviePosterImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 400, height: 500))

    private lazy var contentScrollView: UIScrollView = {
        let scroll = UIScrollView(frame: view.bounds)
        scroll.showsVerticalScrollIndicator = false
        scroll.contentSize = CGSize(width: view.frame.width, height: 1250)
        scroll.addSubview(backgroundBlackView)
        return scroll
    }()

    private lazy var backgroundBlackView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 300, width: 400, height: 1000))
        view.backgroundColor = .black
        view.addSubview(movieNameLabel)
        view.addSubview(ratingLabel)
        view.addSubview(genreLabel)
        view.addSubview(seeMovieButton)
        view.addSubview(tabBarActionView)
        view.addSubview(actorCollectionView)
        view.addSubview(actorsLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(descriptionTitleLabel)
        return view
    }()

    private let movieNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 3
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()

    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()

    private let genreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = .lightGray
        return label
    }()

    private let seeMovieButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(named: Constants.watchImageName), for: .normal)
        return button
    }()

    private lazy var actorCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: actorCollectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentSize = CGSize(width: 1000, height: 250)
        collectionView.register(ActorCollectionViewCell.self, forCellWithReuseIdentifier: Constants.actorCellIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()

    private let actorCollectionViewLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 150, height: 250)
        layout.scrollDirection = .horizontal
        return layout
    }()

    private let actorsLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.actorTitleText
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()

    private let descriptionTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 18)
        label.text = Constants.descriptionTitleText
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()

    private let favotiteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: Constants.starSystemImageName), for: .normal)
        return button
    }()

    private let favotiteLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.favoriteTitleText
        label.font = .systemFont(ofSize: 11)
        return label
    }()

    private let bookmarkButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: Constants.bookmarkSystemImageName), for: .normal)
        return button
    }()

    private let bookmarkLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.bookmarkTitleText
        label.font = .systemFont(ofSize: 11)
        return label
    }()

    private let button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: Constants.shareSystemImageName), for: .normal)
        return button
    }()

    private let shareLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.shareTitleText
        label.font = .systemFont(ofSize: 11)
        return label
    }()

    private let moreButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: Constants.moreSystemImageName), for: .normal)
        return button
    }()

    private let moreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.moreTitleText
        label.font = .systemFont(ofSize: 11)
        return label
    }()

    private lazy var tabBarActionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .lightGray
        view.addSubview(favotiteLabel)
        view.addSubview(favotiteButton)
        view.addSubview(bookmarkLabel)
        view.addSubview(bookmarkButton)
        view.addSubview(shareLabel)
        view.addSubview(button)
        view.addSubview(moreLabel)
        view.addSubview(moreButton)
        return view
    }()

    // MARK: - Private Property

    private var networkManager = NetworkService()
    private var casts: [Cast] = []
    private var genres = String()

    // MARK: Public Property

    var data: Movie?

    // MARK: - Lyfe Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI(data: data)
        configureConstraint()
    }

    // MARK: Private Methods

    private func setupUI(data: Movie?) {
        getAndSetupAnotherUI(data: data)
        setupGenre(data)
    }

    private func getAndSetupAnotherUI(data: Movie?) {
        view.addSubview(moviePosterImageView)
        view.addSubview(contentScrollView)
        guard let dataPosterImage = data?.posterPath,
              let dataRating = data?.voteAverage,
              let movieId = data?.id
        else { return }
        updateImage(dataPosterImage: dataPosterImage)
        movieNameLabel.text = data?.title
        ratingLabel.text = String(dataRating)
        descriptionLabel.text = data?.overview
        ratingLabel.textColor = updateRating(rating: dataRating)
        fetchCast(id: "\(movieId)\(Constants.apiCreditsGenreURL)")
    }

    private func fetchCast(id: String) {
        networkManager.fetchCast(id: id) { result in
            switch result {
            case let .success(actor):
                DispatchQueue.main.async {
                    self.casts += actor.cast
                    self.actorCollectionView.reloadData()
                }
            case let .failure(error):
                print(error)
            }
        }
    }

    private func updateRating(rating: Double) -> UIColor {
        guard let rating = Double(ratingLabel.text ?? String()) else { return .lightGray }
        switch rating {
        case 5 ..< 7:
            return .lightGray
        case 7 ... 10:
            return .green
        default:
            return .systemRed
        }
    }

    private func updateImage(dataPosterImage: String) {
        ImageNetworkService().fetchImageData(path: dataPosterImage) { result in
            switch result {
            case let .success(data):
                DispatchQueue.main.async {
                    self.moviePosterImageView.image = UIImage(data: data)
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }

    private func setupGenre(_ data: Movie?) {
        guard let id = data?.id else { return }
        networkManager.fetchDetail(id: "\(id)") { result in
            switch result {
            case let .success(genre):
                self.updateGenres(genres: genre.genres)
            case let .failure(failure):
                print(failure.localizedDescription)
            }
        }
    }

    private func updateGenres(genres: [Genre]) {
        for genre in genres {
            if self.genres.isEmpty {
                self.genres += genre.name
            } else {
                self.genres += ", " + genre.name
            }
            DispatchQueue.main.async {
                self.genreLabel.text = self.genres
            }
        }
    }

    private func configureConstraint() {
        NSLayoutConstraint.activate([
            movieNameLabel.topAnchor.constraint(equalTo: backgroundBlackView.topAnchor, constant: 25),
            movieNameLabel.widthAnchor.constraint(equalToConstant: backgroundBlackView.frame.width - 100),
            movieNameLabel.centerXAnchor.constraint(equalTo: backgroundBlackView.centerXAnchor, constant: 0),
            ratingLabel.topAnchor.constraint(equalTo: movieNameLabel.bottomAnchor, constant: 15),
            ratingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            genreLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 5),
            genreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            seeMovieButton.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 10),
            seeMovieButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            seeMovieButton.heightAnchor.constraint(equalToConstant: 70),
            seeMovieButton.widthAnchor.constraint(equalToConstant: 250),
            tabBarActionView.topAnchor.constraint(equalTo: seeMovieButton.bottomAnchor, constant: 70),
            tabBarActionView.leadingAnchor.constraint(equalTo: backgroundBlackView.leadingAnchor, constant: 60),
            actorsLabel.topAnchor.constraint(equalTo: tabBarActionView.bottomAnchor, constant: 20),
            actorsLabel.leadingAnchor.constraint(equalTo: backgroundBlackView.leadingAnchor, constant: 20),
            actorCollectionView.topAnchor.constraint(equalTo: tabBarActionView.bottomAnchor, constant: 50),
            actorCollectionView.leadingAnchor.constraint(equalTo: backgroundBlackView.leadingAnchor, constant: 0),
            actorCollectionView.trailingAnchor.constraint(equalTo: backgroundBlackView.trailingAnchor, constant: 0),
            actorCollectionView.heightAnchor.constraint(equalToConstant: 250),
            actorCollectionView.widthAnchor.constraint(equalToConstant: backgroundBlackView.frame.width),
            descriptionTitleLabel.topAnchor.constraint(equalTo: actorCollectionView.bottomAnchor, constant: 15),
            descriptionTitleLabel.leadingAnchor.constraint(equalTo: backgroundBlackView.leadingAnchor, constant: 20),
            descriptionLabel.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: backgroundBlackView.leadingAnchor, constant: 20),
            descriptionLabel.widthAnchor.constraint(equalToConstant: 360)
        ])
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension MoviesDescriptionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        casts.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView
            .dequeueReusableCell(
                withReuseIdentifier: Constants.actorCellIdentifier,
                for: indexPath
            ) as? ActorCollectionViewCell
        else { return UICollectionViewCell() }
        cell.setupActor(casts[indexPath.row])
        return cell
    }
}

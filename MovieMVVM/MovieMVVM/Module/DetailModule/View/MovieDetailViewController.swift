// MovieDetailViewController.swift
// Copyright © Vlaadkaaaa. All rights reserved.

import UIKit

/// Страница конкретного фильма
final class MovieDetailViewController: UIViewController {
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
        let view = UIView(frame: CGRect(x: 0, y: 300, width: view.bounds.width, height: 1000))
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

    private lazy var favotiteButton: UIButton = createMoreButton(imageName: Constants.starSystemImageName)
    private lazy var favotiteLabel: UILabel = createMoreLabel(text: Constants.favoriteTitleText)
    private lazy var bookmarkButton: UIButton = createMoreButton(imageName: Constants.bookmarkSystemImageName)
    private lazy var bookmarkLabel: UILabel = createMoreLabel(text: Constants.bookmarkTitleText)
    private lazy var button: UIButton = createMoreButton(imageName: Constants.shareSystemImageName)
    private lazy var shareLabel: UILabel = createMoreLabel(text: Constants.shareTitleText)
    private lazy var moreButton: UIButton = createMoreButton(imageName: Constants.moreSystemImageName)
    private lazy var moreLabel: UILabel = createMoreLabel(text: Constants.moreTitleText)

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

    // MARK: - Init

    init(detailViewModel: MovieDetailViewModelProtocol?) {
        self.detailViewModel = detailViewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Property

    private var detailViewModel: MovieDetailViewModelProtocol?
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
        view.addSubview(moviePosterImageView)
        view.addSubview(contentScrollView)
        updateUI(from: data)
        fetchGenre(data)
    }

    private func updateUI(from data: Movie?) {
        fetchImage(dataPosterImage: data?.posterPath)
        movieNameLabel.text = data?.title
        updateRating(rating: data?.voteAverage)
        descriptionLabel.text = data?.overview
        fetchCast(id: data?.id)
    }

    private func fetchCast(id: Int?) {
        guard let id else { return }
        detailViewModel?.fetchCast(id: "\(id)\(Constants.apiCreditsGenreURL)")
        updateCast()
    }

    private func updateCast() {
        detailViewModel?.updateViewData = { cast in
            DispatchQueue.main.async {
                self.casts = cast
                self.actorCollectionView.reloadData()
            }
        }
    }

    private func updateRating(rating: Double?) {
        guard let rating else { return }
        ratingLabel.text = "\(rating)"
        detailViewModel?.updateColor(rating: rating)
        updateRatingColor()
    }

    private func updateRatingColor() {
        detailViewModel?.updateColor = { name in
            self.ratingLabel.textColor = UIColor(named: name)
        }
    }

    private func fetchImage(dataPosterImage: String?) {
        guard let dataPosterImage else { return }
        detailViewModel?.fetchImageData(path: dataPosterImage)
        updateImage()
    }

    private func updateImage() {
        detailViewModel?.updateImage = { data in
            DispatchQueue.main.async {
                self.moviePosterImageView.image = UIImage(data: data)
            }
        }
    }

    private func fetchGenre(_ data: Movie?) {
        guard let id = data?.id else { return }
        detailViewModel?.fetchDetail(id: "\(id)")
        updateGenres()
    }

    private func updateGenres() {
        detailViewModel?.updateGenre = { genre in
            DispatchQueue.main.async {
                self.genreLabel.text = genre
            }
        }
    }

    private func createMoreLabel(text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = .systemFont(ofSize: 11)
        return label
    }

    private func createMoreButton(imageName: String) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: imageName), for: .normal)
        return button
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

extension MovieDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {
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
            ) as? ActorCollectionViewCell,
            let imageService = detailViewModel?.imageService
        else { return UICollectionViewCell() }
        cell.congigureCell(casts[indexPath.row], imageService: imageService)
        return cell
    }
}

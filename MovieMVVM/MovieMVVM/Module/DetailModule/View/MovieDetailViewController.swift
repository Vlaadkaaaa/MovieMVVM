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
        static let playSystemImageName = "play.fill"
        static let squareSystemImageName = "square.and.arrow.down"
        static let watchTitlteText = "Смотреть"
        static let favoriteTitleText = "Оценить"
        static let bookmarkTitleText = "Буду смотреть"
        static let shareTitleText = "Поделиться"
        static let moreTitleText = "Ещё"
        static let apiCreditsGenreURL = "/credits"
    }

    // MARK: Private visual Components

    private lazy var moviePosterImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 400, height: 500))

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
        var views = [
            movieNameLabel,
            ratingLabel,
            genreLabel,
            seeMovieButton,
            downloadMovieButton,
            tabBarActionView,
            actorCollectionView,
            actorsLabel,
            descriptionLabel,
            descriptionTitleLabel
        ]
        views.forEach { view.addSubview($0) }
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

    private lazy var seeMovieButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: Constants.playSystemImageName), for: .normal)
        button.imageView?.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.imageEdgeInsets.right = 30
        button.setTitle(Constants.watchTitlteText, for: .normal)
        button.applyGradient(colors: [UIColor.orange.cgColor, UIColor.yellow.cgColor])
        return button
    }()

    private var downloadMovieButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: Constants.squareSystemImageName), for: .normal)
        button.tintColor = .gray
        return button
    }()

    private lazy var actorCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: actorCollectionViewLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentSize = CGSize(width: 1000, height: 250)
        collectionView.register(ActorCollectionViewCell.self, forCellWithReuseIdentifier: Constants.actorCellIdentifier)
        collectionView.dataSource = self
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

    private var hStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 7
        return stack

    }()

    private lazy var favotiteButton: UIButton = createMoreButton(imageName: Constants.starSystemImageName)
    private lazy var favotiteLabel: UILabel = createMoreLabel(text: Constants.favoriteTitleText)
    private lazy var bookmarkButton: UIButton = createMoreButton(imageName: Constants.bookmarkSystemImageName)
    private lazy var bookmarkLabel: UILabel = createMoreLabel(text: Constants.bookmarkTitleText)
    private lazy var shareButton: UIButton = createMoreButton(imageName: Constants.shareSystemImageName)
    private lazy var shareLabel: UILabel = createMoreLabel(text: Constants.shareTitleText)
    private lazy var moreButton: UIButton = createMoreButton(imageName: Constants.moreSystemImageName)
    private lazy var moreLabel: UILabel = createMoreLabel(text: Constants.moreTitleText)

    private lazy var tabBarActionView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .lightGray
        return view
    }()

    private func configureMoreBlock() {
        tabBarActionView.addSubview(hStackView)
        addButtonsToStackView()
        setStackConstraint()
    }

    // MARK: - Init

    init(detailViewModel: MovieDetailViewModelProtocol?) {
        self.detailViewModel = detailViewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
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
        configureMoreBlock()
    }

    // MARK: Private Methods

    private func setupUI(data: Movie?) {
        view.addSubview(moviePosterImageView)
        view.addSubview(contentScrollView)
        updateUI(from: data)
        fetchGenre(data)
        setupNavBar()
    }

    private func setupNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .action)
    }

    private func updateUI(from data: Movie?) {
        fetchImage(dataPosterImage: data?.posterPath)
        updateImage()
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
        detailViewModel?.updateViewDataHandler = { cast in
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
        detailViewModel?.updateColorHandler = { name in
            self.ratingLabel.textColor = UIColor(named: name)
        }
    }

    private func fetchImage(dataPosterImage: String?) {
        guard let dataPosterImage else { return }
        detailViewModel?.fetchImageData(path: dataPosterImage)
    }

    private func updateImage() {
        detailViewModel?.updateImageHandler = { data in
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
        detailViewModel?.updateGenreHandler = { genre in
            DispatchQueue.main.async {
                self.genreLabel.text = genre
            }
        }
    }

    private func createMoreLabel(text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = .boldSystemFont(ofSize: 11)
        return label
    }

    private func createMoreButton(imageName: String) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: imageName), for: .normal)
        return button
    }

    func createVStack(button: UIButton, label: UILabel) -> UIStackView {
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.distribution = .fillEqually
        vStack.alignment = .center
        vStack.spacing = 5
        vStack.addArrangedSubview(button)
        vStack.addArrangedSubview(label)
        return vStack
    }

    func addButtonsToStackView() {
        hStackView.addArrangedSubview(createVStack(button: favotiteButton, label: favotiteLabel))
        hStackView.addArrangedSubview(createVStack(button: bookmarkButton, label: bookmarkLabel))
        hStackView.addArrangedSubview(createVStack(button: shareButton, label: shareLabel))
        hStackView.addArrangedSubview(createVStack(button: moreButton, label: moreLabel))
    }

    private func setStackConstraint() {
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        hStackView.topAnchor.constraint(equalTo: tabBarActionView.safeAreaLayoutGuide.topAnchor, constant: 0)
            .isActive = true
        hStackView.leadingAnchor.constraint(equalTo: tabBarActionView.safeAreaLayoutGuide.leadingAnchor, constant: 0)
            .isActive = true
        hStackView.trailingAnchor.constraint(
            equalTo: tabBarActionView.safeAreaLayoutGuide.trailingAnchor,
            constant: 0
        )
        .isActive = true
        hStackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    private func configureHeaderConstraint() {
        NSLayoutConstraint.activate([
            movieNameLabel.topAnchor.constraint(equalTo: backgroundBlackView.topAnchor, constant: 25),
            movieNameLabel.widthAnchor.constraint(equalToConstant: backgroundBlackView.frame.width - 100),
            movieNameLabel.centerXAnchor.constraint(equalTo: backgroundBlackView.centerXAnchor, constant: 0),
            ratingLabel.topAnchor.constraint(equalTo: movieNameLabel.bottomAnchor, constant: 15),
            ratingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            genreLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 5),
            genreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
        ])
    }

    private func configureCastConstraint() {
        NSLayoutConstraint.activate([
            actorsLabel.topAnchor.constraint(equalTo: tabBarActionView.bottomAnchor, constant: 63),
            actorsLabel.leadingAnchor.constraint(equalTo: backgroundBlackView.leadingAnchor, constant: 20),
            actorCollectionView.topAnchor.constraint(equalTo: tabBarActionView.bottomAnchor, constant: 93),
            actorCollectionView.leadingAnchor.constraint(equalTo: backgroundBlackView.leadingAnchor, constant: 0),
            actorCollectionView.trailingAnchor.constraint(equalTo: backgroundBlackView.trailingAnchor, constant: 0),
            actorCollectionView.heightAnchor.constraint(equalToConstant: 250),
            actorCollectionView.widthAnchor.constraint(equalToConstant: backgroundBlackView.frame.width)
        ])
    }

    private func configureMoreBlockConstraint() {
        NSLayoutConstraint.activate([
            seeMovieButton.topAnchor.constraint(equalTo: genreLabel.bottomAnchor, constant: 10),
            seeMovieButton.leadingAnchor.constraint(equalTo: backgroundBlackView.leadingAnchor, constant: 60),
            seeMovieButton.heightAnchor.constraint(equalToConstant: 70),
            seeMovieButton.widthAnchor.constraint(equalToConstant: 200),
            downloadMovieButton.leadingAnchor.constraint(equalTo: seeMovieButton.trailingAnchor, constant: 20),
            downloadMovieButton.centerYAnchor.constraint(equalTo: seeMovieButton.centerYAnchor),
            downloadMovieButton.heightAnchor.constraint(equalToConstant: 25),
            downloadMovieButton.widthAnchor.constraint(equalToConstant: 25),
            tabBarActionView.topAnchor.constraint(equalTo: seeMovieButton.bottomAnchor, constant: 30),
            tabBarActionView.centerXAnchor.constraint(equalTo: backgroundBlackView.centerXAnchor),
        ])
    }

    private func configureFooterBlockConstraint() {
        NSLayoutConstraint.activate([
            descriptionTitleLabel.topAnchor.constraint(equalTo: actorCollectionView.bottomAnchor, constant: 15),
            descriptionTitleLabel.leadingAnchor.constraint(equalTo: backgroundBlackView.leadingAnchor, constant: 20),
            descriptionLabel.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: backgroundBlackView.leadingAnchor, constant: 20),
            descriptionLabel.widthAnchor.constraint(equalToConstant: 360)
        ])
    }

    private func configureRatingConstraint() {
        NSLayoutConstraint.activate([
            movieNameLabel.topAnchor.constraint(equalTo: backgroundBlackView.topAnchor, constant: 25),
            movieNameLabel.widthAnchor.constraint(equalToConstant: backgroundBlackView.frame.width - 100),
            movieNameLabel.centerXAnchor.constraint(equalTo: backgroundBlackView.centerXAnchor, constant: 0),
            ratingLabel.topAnchor.constraint(equalTo: movieNameLabel.bottomAnchor, constant: 15),
            ratingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            genreLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 5),
            genreLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
        ])
    }

    private func configureConstraint() {
        configureHeaderConstraint()
        configureRatingConstraint()
        configureMoreBlockConstraint()
        configureCastConstraint()
        configureFooterBlockConstraint()
    }
}

// MARK: - UICollectionViewDataSource

extension MovieDetailViewController: UICollectionViewDataSource {
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
            var viewModel = detailViewModel
        else { return UICollectionViewCell() }
        viewModel.updateCast(casts[indexPath.row])
        cell.congigureCell(viewModel: &viewModel)
        return cell
    }
}

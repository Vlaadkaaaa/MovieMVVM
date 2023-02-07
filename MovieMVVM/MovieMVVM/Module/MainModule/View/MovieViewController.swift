// MovieViewController.swift
// Copyright © Vlaadkaaaa. All rights reserved.

import UIKit

/// Главная страница со списком фильмов
final class MovieViewController: UIViewController {
    // MARK: Private Costants

    private enum Constants {
        static let segmentControlItems = ["Популярное", "Ожидаемые", "Лучшие"]
        static let movieTitleText = "Фильмы"
        static let movieCellIdentifier = "MovieCell"
    }

    // MARK: - Private Visual Component

    private lazy var filtherMovieSegmentControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: Constants.segmentControlItems)
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(changeSegmentAction), for: .valueChanged)
        return segment
    }()

    private let movieTableView: UITableView = {
        let table = UITableView(frame: CGRect(), style: .plain)
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    private var activityIndicatorView = UIActivityIndicatorView(style: .large)

    // MARK: Private Property

    private var movies: [Movie] = []
    private var movieViewModel: MovieViewModelProtocol?

    private var props = MovieViewData.loading {
        didSet {
            switch props {
            case .loading:
                activityIndicatorView.startAnimating()
            case let .success(movies):
                DispatchQueue.main.async {
                    self.activityIndicatorView.stopAnimating()
                    self.movies = movies
                    self.movieTableView.reloadData()
                }
            case let .failure(error):
                showAlert(message: error.localizedDescription)
            }
        }
    }

    var toDetailViewControllerHandler: ((Movie) -> ())?

    // MARK: - Init

    init(movieViewModel: MovieViewModelProtocol?) {
        self.movieViewModel = movieViewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Lyfe Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    // MARK: Private Methods

    private func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .white
        title = Constants.movieTitleText
        view.addSubview(filtherMovieSegmentControl)
        fetchMovie(genre: .popular)
        setupRefreshControl()
        setupMovieTableView()
        updateViewData()
    }

    private func updateViewData() {
        movieViewModel?.updateViewData = { viewData in
            self.props = viewData
        }
    }

    private func setupMovieTableView() {
        view.addSubview(movieTableView)
        movieTableView.delegate = self
        movieTableView.dataSource = self
        movieTableView.register(MovieViewCell.self, forCellReuseIdentifier: Constants.movieCellIdentifier)
        addContraint()
    }

    private func setupRefreshControl() {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshPageAction), for: .valueChanged)
        movieTableView.refreshControl = refresh
    }

    private func fetchMovie(genre: MovieCategory) {
        movieViewModel?.fetchMovie(category: genre)
    }

    private func addContraint() {
        NSLayoutConstraint.activate([
            filtherMovieSegmentControl.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            filtherMovieSegmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            filtherMovieSegmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            movieTableView.topAnchor.constraint(equalTo: filtherMovieSegmentControl.bottomAnchor, constant: 20),
            movieTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            movieTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            movieTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }

    @objc private func refreshPageAction() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.movieTableView.reloadData()
            self.movieTableView.refreshControl?.endRefreshing()
        }
    }

    @objc private func changeSegmentAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            fetchMovie(genre: .popular)
        case 1:
            fetchMovie(genre: .upcoming)
        default:
            fetchMovie(genre: .topRated)
        }
    }
}

// MARK: - UITableViewDataSource

extension MovieViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Constants.movieCellIdentifier,
            for: indexPath
        ) as? MovieViewCell,
            let imageService = movieViewModel?.imageService
        else { return UITableViewCell() }
        cell.selectionStyle = .none
        cell.configureCell(movie: movies[indexPath.row], imageService: imageService)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MovieViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        toDetailViewControllerHandler?(movies[indexPath.row])
    }
}
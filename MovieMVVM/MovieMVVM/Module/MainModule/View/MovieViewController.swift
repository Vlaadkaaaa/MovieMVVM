// MovieViewController.swift
// Copyright © Vlaadkaaaa. All rights reserved.

import UIKit

/// Главная страница со списком фильмов
final class MovieViewController: UIViewController {
    // MARK: - Private Visual Component

    private lazy var filtherMovieSegmentControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: [Constants.popularText, Constants.upcomingText, Constants.topRatedText])
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

    // MARK: - Public Property

    var toDetailViewControllerHandler: ((Movie) -> ())?

    // MARK: Private Property

    private var movieViewModel: MovieViewModelProtocol?
    private var props = MovieViewData.loading {
        didSet {
            switch props {
            case .loading:
                activityIndicatorView.startAnimating()
            case .success:
                DispatchQueue.main.async {
                    self.activityIndicatorView.stopAnimating()
                    self.movieTableView.reloadData()
                }
            case let .failure(error):
                showAlert(message: error.localizedDescription)
            }
        }
    }

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
        bind()
        setupMovieTableView()
        checkApiKey()
        setupRefreshControl()
    }

    private func bind() {
        movieViewModel?.updateViewDataHandler = { [weak self] viewData in
            guard let self else { return }
            self.props = viewData
        }
    }

    private func checkApiKey() {
        movieViewModel?.checkApiKey {
            saveKeyAlert { [weak self] key in
                guard let self else { return }
                self.movieViewModel?.updateApiKey(key)
            }
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
        movieViewModel?.setupCategory(choose: sender.selectedSegmentIndex)
    }
}

// MARK: - UITableViewDataSource

extension MovieViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if case let .success(movies) = props {
            return movies.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if case let .success(movies) = props {
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: Constants.movieCellIdentifier,
                for: indexPath
            ) as? MovieViewCell,
                var viewModel = movieViewModel
            else { return UITableViewCell() }
            cell.selectionStyle = .none
            cell.configureCell(viewModel: &viewModel)
            viewModel.updateMovieCell(movies[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - UITableViewDelegate

extension MovieViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if case let .success(movies) = props {
            toDetailViewControllerHandler?(movies[indexPath.row])
        }
    }
}

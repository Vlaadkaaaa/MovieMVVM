// MovieViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Главная страница со списком фильмов
final class MovieViewController: UIViewController {
    // MARK: Private Costants

    private enum Constants {
        static let segmentControlItems = ["Популярное", "Ожидаемые", "Лучшие"]
        static let movieTitleText = "Фильмы"
        static let movieCellIdentifier = "MovieCell"
        static let genres = ["popular", "upcoming"]
        static let resultDateFormat = "yyyy-MM-dd"
        static let editDateFormat = "dd MMM yyyy"
        static let adImageName = "adsLogo"
        static let apiRequestURL = "https://api.themoviedb.org/3/movie/"
        static let apiKeyURL = "api_key=d9e4494907230d135d6f6fd47beca82e"
        static let apiLanguageURL = "language=ru"
        static let appendResponseVideosURL = "append_to_response=videos"
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

    // MARK: Private Property

    private let dateFormater = DateFormatter()
    private var networkManager = NetworkManager()
    private var moviewDataSource: MoviesNetwork?
    private var movie: Movies?
    private var genres = String()

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
        dateFormater.dateFormat = Constants.resultDateFormat
        view.addSubview(filtherMovieSegmentControl)
        getMovies(genre: Constants.genres[0])
        setupRefreshControl()
        setupMovieTableView()
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

    @objc private func refreshPageAction() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.movieTableView.reloadData()
            self.movieTableView.refreshControl?.endRefreshing()
        }
    }

    private func getMovies(genre: String) {
        networkManager.getMovies(genre: genre) { [weak self] result in
            switch result {
            case let .successMovies(movies):
                self?.moviewDataSource = movies
                DispatchQueue.main.async {
                    self?.movieTableView.reloadData()
                }
            case let .failure(error):
                print(error)
            default:
                break
            }
        }
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

    private func getMovieGenre(data: Results?) {
        guard let movieId = data?.id,
              let url =
              URL(
                  string: "\(Constants.apiRequestURL)\(movieId)?\(Constants.apiKeyURL)&" +
                      "\(Constants.appendResponseVideosURL)&\(Constants.apiLanguageURL)"
              )
        else { return }
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, _, error in
            if error == nil, let parseData = data {
                guard let genre = try? JSONDecoder().decode(MovieGenreNetwork.self, from: parseData) else { return }
                self.genres = String()
                for genre in genre.genres {
                    if self.genres.isEmpty {
                        self.genres += genre.name
                    } else {
                        self.genres += ", " + genre.name
                    }
                }
            }
        }
        task.resume()
    }

    @objc private func changeSegmentAction(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            getMovies(genre: Constants.genres[0])
        default:
            getMovies(genre: Constants.genres[1])
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MovieViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        moviewDataSource?.results.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = moviewDataSource?.results[indexPath.row]
    
            let cell = tableView.dequeueReusableCell(
                withIdentifier: Constants.movieCellIdentifier,
                for: indexPath
            ) as? MovieViewCell
            cell?.selectionStyle = .none
            guard let dataRelease = data?.releaseDate,
                  let dataPosterPath = data?.posterPath,
                  let dataTitle = data?.title,
                  let dataVoteAverange = data?.voteAverage else { fatalError() }
            let date = dateFormater.date(from: dataRelease)
            dateFormater.dateFormat = Constants.editDateFormat
            getMovieGenre(data: data)
            let movie = Movies(
                movieImageName: dataPosterPath,
                movieGenreName: genres,
                movieNameText: dataTitle,
                movieDateText: dateFormater.string(from: date ?? Date()),
                ratingValue: dataVoteAverange
            )
            self.movie = movie
            cell?.setupView(movie: movie)
            return cell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = MoviesDescriptionViewController()
        let data = moviewDataSource?.results[indexPath.row]
        vc.data = data
        navigationController?.pushViewController(vc, animated: true)
    }
}

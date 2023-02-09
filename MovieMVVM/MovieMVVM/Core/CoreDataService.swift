// CoreDataService.swift
// Copyright © Vlaadkaaaa. All rights reserved.

import CoreData

/// Сервис  работы с БД
final class CoreDataService: CoreDataServiceProtocol {
    // MARK: - Private Constants

    private enum Constants {
        static let movieStorageEntityText = "MovieStorage"
        static let byCategoryFilter = "category == %@"
        static let emptyText = ""
    }

    // MARK: - Public Method

    func saveData(_ data: [Movie], category: String) {
        let context = AppDelegate.sharedAppDelegate.persistentContainer.viewContext
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        saveMovie(movie: data, context: context, category: category)
        do {
            try context.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    func getData(category: String) -> [Movie]? {
        let context = AppDelegate.sharedAppDelegate.persistentContainer.viewContext
        return getMovie(context: context, category: category)
    }

    // MARK: - Private Method

    private func saveMovie(movie: [Movie], context: NSManagedObjectContext, category: String) {
        guard let entity = NSEntityDescription.entity(forEntityName: Constants.movieStorageEntityText, in: context)
        else { return }
        movie.forEach {
            let object = MovieStorage(entity: entity, insertInto: context)
            object.id = Int64($0.id)
            object.title = $0.title
            object.overview = $0.overview
            object.posterPath = $0.posterPath
            object.releaseDate = $0.releaseDate
            object.voteAverage = $0.voteAverage
            object.voteCount = Int64($0.voteCount)
            object.category = category
        }
    }

    private func getMovie(context: NSManagedObjectContext, category: String) -> [Movie]? {
        var movies: [Movie] = []
        let request: NSFetchRequest<MovieStorage> = MovieStorage.fetchRequest()
        let predicate = NSPredicate(format: Constants.byCategoryFilter, category)
        request.predicate = predicate
        do {
            try context.fetch(request).forEach {
                movies.append(contertMovie(object: $0))
            }
            return movies
        } catch {
            return nil
        }
    }

    private func contertMovie(object: MovieStorage) -> Movie {
        Movie(
            id: Int(object.id),
            overview: object.overview ?? Constants.emptyText,
            posterPath: object.posterPath ?? Constants.emptyText,
            releaseDate: object.releaseDate ?? Constants.emptyText,
            title: object.title ?? Constants.emptyText,
            voteAverage: object.voteAverage,
            voteCount: Int(object.voteCount)
        )
    }
}

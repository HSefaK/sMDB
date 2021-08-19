import Foundation
import CoreData

class FavoriteMaker {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MovieApp")        
        container.loadPersistentStores { _, error in
            guard error == nil else {
                fatalError("Unresolved error \(error!)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = false
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.undoManager = nil
        return container
    }()
    
    private func newTaskContext() -> NSManagedObjectContext {
        let taskContext = persistentContainer.newBackgroundContext()
        taskContext.undoManager = nil
        taskContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return taskContext
    }
    
    func makeFavorite(
        _ id: Int,
        _ title: String,
        _ backdrop: Data,
        _ poster: Data,
        _ overview: String,
        _ releaseDate: String,
        _ rating: String,
        _ genres: String,
        completion: @escaping() -> Void
    ) {
        let taskContext = newTaskContext()
        taskContext.perform {
            if let entity = NSEntityDescription.entity(forEntityName: "Favorites", in: taskContext) {
                let movie = NSManagedObject(entity: entity, insertInto: taskContext)
                movie.setValue(id, forKey: "id")
                movie.setValue(title, forKey: "title")
                movie.setValue(backdrop, forKey: "backdrop")
                movie.setValue(poster, forKey: "poster")
                movie.setValue(overview, forKey: "overview")
                movie.setValue(releaseDate, forKey: "releaseDate")
                movie.setValue(rating, forKey: "rating")
                
                do {
                    try taskContext.save()
                    completion()
                } catch let error as NSError {
                    print("Error!Not Save! \(error), \(error.userInfo)")
                }
            }
        }
    }
    func getFavorites(completion: @escaping(_ favorites: [Favorite]) -> Void) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Favorites")
            do {
                let results = try taskContext.fetch(fetchRequest)
                var favorites: [Favorite] = []
                for result in results {
                    let favorite = Favorite(
                        id: result.value(forKey: "id") as? Int,
                        title: result.value(forKey: "title") as? String,
                        backdrop: result.value(forKey: "backdrop") as? Data,
                        poster: result.value(forKey: "poster") as? Data,
                        overview: result.value(forKey: "overview") as? String,
                        releaseDate: (result.value(forKey: "releaseDate") as? String)!,
                        rating: result.value(forKey: "rating") as? String,
                        genres: result.value(forKey: "genres") as? String
                    )
                    favorites.append(favorite)
                }
                completion(favorites)
            } catch let error as NSError {
                print("Fetching Error! \(error), \(error.userInfo)")
            }
        }
    }
    
    func checkData(_ id: Int) -> Bool {
        var isExist = false
        let taskContext = newTaskContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Favorites")
        fetchRequest.predicate = NSPredicate(format: "id == \(id)")
        do {
            let result = try taskContext.fetch(fetchRequest)
            if result.count > 0 {
                isExist = true
            }
        } catch let error as NSError {
            print("Fetching Error! \(error), \(error.userInfo)")
        }
        return isExist
    }
    func removeFromFavorite(_ id: Int, completion: @escaping() -> Void) {
        let taskContext = newTaskContext()
        taskContext.perform {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorites")
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(format: "id == \(id)")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            batchDeleteRequest.resultType = .resultTypeCount
            if let batchDeleteResult =
                try? taskContext.execute(batchDeleteRequest) as? NSBatchDeleteResult,
                batchDeleteResult.result != nil {
                completion()
            }
        }
    }
}

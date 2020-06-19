//
//  CalorieEntryController.swift
//  CALORIE-TRACKER
//
//  Created by Kelson Hartle on 6/19/20.
//  Copyright © 2020 Kelson Hartle. All rights reserved.
//

import Foundation
import CoreData

//MARK: - Enums
enum NetworkError: Error {
    case noIdentifier
    case otherError
    case noData
    case noDecode
    case noEncode
    case noRep

}

//https://caloriet-e38be.firebaseio.com/

class CalorieEntryController {

    let baseURL = URL(string: "https://caloriet-e38be.firebaseio.com/")!

    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void

    let jsonDecoder = JSONDecoder()

    init() {
        fetchTrackedCaloriesFromServer()
    }
    
    //MARK: - Networking
    func fetchTrackedCaloriesFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json")

        URLSession.shared.dataTask(with: requestURL) { data, _, error in
            if let error = error {
                NSLog("Error fetching tracked calories: \(error)")
                completion(.failure(.otherError))
                return
            }

            guard let data = data else {
                NSLog("No data returned from Firebase (fetching tracked calories).")
                completion(.failure(.noData))
                return
            }

            do {
                let entryRepresentations = Array(try self.jsonDecoder.decode([String: EntryRepresentation].self, from: data).values)
                try self.updateEntries(with: entryRepresentations)
            } catch {
                NSLog("Error deocding entries from Firebase: \(error)")
                completion(.failure(.noDecode))
            }
        }.resume()
    }

    func sendTrackedCaloriesToServer(entry: CalorieIntake, completion: @escaping CompletionHandler = { _ in }) {

        guard let identifier = entry.identifier else {
            completion(.failure(.noIdentifier))
            return
        }
        let requestURL = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"

        do {
            guard var representation = entry.entryRepresentation else {
                completion(.failure(.noRep))
                return
            }
            representation.identifier = identifier //extra
            entry.identifier = identifier
            try CoreDataStack.shared.mainContext.save()

            request.httpBody = try JSONEncoder().encode(representation)

        } catch {
            NSLog("Error encoding entries \(entry): \(error)")
            completion(.failure(.noEncode))
            return
        }

        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                NSLog("Error sending tracked calories to server: \(error)")
                completion(.failure(.otherError))
                return
            }

            completion(.success(true))
        }.resume()
    }

    func deleteTrackedCaloriesFromServer(_ entry: CalorieIntake, completion: @escaping CompletionHandler = { _ in}) {
        guard let identifier = entry.identifier else {
            completion(.failure(.noIdentifier))
            return
        }
        let requestURL = baseURL.appendingPathComponent(identifier).appendingPathExtension("json")

        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"

        URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                NSLog("Error deleting tracked calories from server: \(error)")
                completion(.failure(.otherError))
                return
            }
            completion(.success(true))
        }.resume()
    }

    private func updateEntries(with representations: [EntryRepresentation]) throws {
        let identifiersToFetch = representations.compactMap { $0.identifier }
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        var entriesToCreate = representationsByID

        let fetchRequest: NSFetchRequest<CalorieIntake> = CalorieIntake.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)

        let context = CoreDataStack.shared.container.newBackgroundContext()

        var error: Error?

        context.performAndWait {
            do {
                let existingEntries = try context.fetch(fetchRequest)

                for entry in existingEntries {
                    guard let identifier = entry.identifier,
                        let representation = representationsByID[identifier] else { continue }

                    self.update(entry: entry, entryRepresentation: representation)
                    entriesToCreate.removeValue(forKey: identifier)//Updates
                }

            } catch let fetchError {
                error = fetchError
            }

            for representation in entriesToCreate.values { //creates
                CalorieIntake(entryRepresentation: representation, context: context)
            }
        }

        if let error = error { throw error }
        try CoreDataStack.shared.save(context: context)
    }

    private func update(entry: CalorieIntake, entryRepresentation: EntryRepresentation) {

        entry.identifier = entryRepresentation.identifier
        entry.numOfCalories = entryRepresentation.numOfCalories
        entry.timeStamp = entryRepresentation.timeStamp

    }
}

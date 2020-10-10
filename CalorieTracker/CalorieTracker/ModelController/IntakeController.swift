//
//  IntakeController.swift
//  CalorieTracker
//
//  Created by Cora Jacobson on 10/10/20.
//

import Foundation
import CoreData

enum NetworkError: Error {
    case noIdentifier
    case otherError
    case noData
    case noDecode
    case noEncode
    case noRep
}

let baseURL = URL(string: "https://calorietracker-21b6b.firebaseio.com/")!

class IntakeController {
    
    init() {
        fetchIntakesFromServer()
    }
    
    typealias CompletionHandler = (Result<Bool, NetworkError>) -> Void
    
    func fetchIntakesFromServer(completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathExtension("json")
        let task = URLSession.shared.dataTask(with: requestURL) { data, _, error in
            if let error = error {
                print("Error fetching intakes: \(error)")
                completion(.failure(.otherError))
                return
            }
            guard let data = data else {
                print("No data returned by data task.")
                completion(.failure(.noData))
                return
            }
            do {
                let intakeRepresentations = Array(try JSONDecoder().decode([String: IntakeRepresentation].self, from: data).values)
                try self.updateIntakes(with: intakeRepresentations)
                completion(.success(true))
            } catch {
                print("Error decoding intake representations: \(error)")
                completion(.failure(.noDecode))
                return
            }
        }
        task.resume()
    }
    
    func deleteIntakeFromServer(_ intake: Intake, completion: @escaping CompletionHandler = { _ in }) {
        guard let uuid = intake.identifier else {
            completion(.failure(.noIdentifier))
            return
        }
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) { _, _, _ in
            completion(.success(true))
        }
        task.resume()
    }
    
    private func update(intake: Intake, representation: IntakeRepresentation) {
        intake.calories = Int16(representation.calories)
        intake.timestamp = representation.timestamp
    }
    
    private func updateIntakes(with representations: [IntakeRepresentation]) throws {
        let context = CoreDataStack.shared.container.newBackgroundContext()
        let identifiersToFetch = representations.compactMap({ UUID(uuidString: $0.identifier) })
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        var intakesToCreate = representationsByID
        let fetchRequest: NSFetchRequest<Intake> = Intake.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
        context.performAndWait {
            do {
                let existingIntakes = try context.fetch(fetchRequest)
                for intake in existingIntakes {
                    guard let id = intake.identifier,
                        let representation = representationsByID[id] else {
                            continue }
                    update(intake: intake, representation: representation)
                    intakesToCreate.removeValue(forKey: id)
                }
                for representation in intakesToCreate.values {
                    Intake(intakeRepresentation: representation, context: context)
                }
            } catch {
                print("Error fetching intakes for UUIDs: \(error)")
            }
        }
        try CoreDataStack.shared.save(context: context)
    }
    
    func sendIntakeToServer(intake: Intake, completion: @escaping CompletionHandler = { _ in }) {
        guard let uuid = intake.identifier else {
            completion(.failure(.noIdentifier))
            return
        }
        let requestURL = baseURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = "PUT"
        
        do {
            guard let representation = intake.intakeRepresentation else {
                completion(.failure(.noRep))
                return
            }
            request.httpBody = try JSONEncoder().encode(representation)
        } catch {
            print("Error encoding intake: \(error)")
            completion(.failure(.noEncode))
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) { _, _, error in
            if let error = error {
                print("Error PUTting intake to server: \(error)")
                completion(.failure(.otherError))
                return
            }
            completion(.success(true))
        }
        task.resume()
    }
    
}

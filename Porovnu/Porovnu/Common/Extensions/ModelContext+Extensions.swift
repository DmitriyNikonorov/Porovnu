//
//  ModelContext+Extensions.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 09.02.2026.
//

import Foundation
import SwiftData

extension ModelContext {

    func fetchModelById<T: PersistentModel>(_ type: T.Type, id: UUID) -> T? where T: IdentifiableModel {
        do {
            let predicate = #Predicate<T> { $0.id == id }
            let descriptor = FetchDescriptor(predicate: predicate)
            return try fetch(descriptor).first
        } catch {
            debugPrint("Fetching model error: \(error)")
            return nil
        }
    }

    func fetchModels<T: PersistentModel>(_ type: T.Type) -> [T] where T: IdentifiableModel {
        do {
            let descriptor = FetchDescriptor<T>()
            debugPrint("Fetching models  \(type.self)")
            return try fetch(descriptor)
        } catch {
            debugPrint("Fetch error: \(error)")
        }

        return []
    }

    // MARK: - переписать на  func saveModel<T: PersistentModel>(_ model: T) throws {
    // и отлавливать ошибки в менеджере
    func saveModel<T: PersistentModel>(_ model: T) {
        do {
            insert(model)
            try save()
            print("✅ save event in database")
        } catch {
            debugPrint("Save error: \(error)")
        }
    }

    func deleteModel<T: PersistentModel>(_ model: T) {
        do {
            delete(model)
            try save()
        } catch {
            debugPrint("Delete error: \(error)")
        }
    }

    func deleteModelById<T: PersistentModel>(_ type: T.Type, id: UUID) where T: IdentifiableModel {
        do {
            let predicate = #Predicate<T> { $0.id == id }
            let models = try fetch(FetchDescriptor<T>(predicate: predicate))

            guard let model = models.first else { return }
            delete(model)

            try save()
            print("✅ delete \(type) id: \(id.uuidString.prefix(8))")
        } catch {
            debugPrint("Delete error: \(error)")
        }
    }
}

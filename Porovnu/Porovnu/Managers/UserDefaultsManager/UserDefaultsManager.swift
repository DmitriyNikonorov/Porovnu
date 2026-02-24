//
//  UserDefaultsManager.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 22.02.2026.
//

import Foundation

enum UserDefaultsManagerEnum: String, Hashable, CaseIterable {
    case lastOpenedEvent
}

struct UserDefaultsManager {
    static func setLastOpenedEventId(_ id: UUID) {
        UserDefaults.standard.setValue(id.uuidString, forKeyPath: UserDefaultsManagerEnum.lastOpenedEvent.rawValue)
    }

    static func fetchLastOpenedEventId() -> UUID? {
        guard
            let string = UserDefaults.standard.string(forKey: UserDefaultsManagerEnum.lastOpenedEvent.rawValue)
        else {
            return nil
        }
        return UUID(uuidString: string)
    }


//    private func loadAll() {
//        Task { @MainActor in
//            settings.theme = loadCodable(Theme.self, key: "theme") ?? .system
//        }
//    }

    // MARK: - Save Async

    private func saveCodable<T: Codable>(_ value: T, key: String) async {
        do {
            let data = try JSONEncoder().encode(value)
            UserDefaults.standard.set(data, forKey: key)
        } catch {
            print("UserDefaults save error: \(error)")
        }
    }

    private func loadCodable<T: Codable>(_ type: T.Type, key: String) -> T? {
        guard let data = UserDefaults.standard.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }


    func clearAll() async {
        let keys = UserDefaultsManagerEnum.allCases
        keys.forEach {
            UserDefaults.standard.removeObject(forKey: $0.rawValue)
        }
    }

    func resetAll() async {
        await clearAll()
        await loadAll()
    }

    func loadAll() async {

    }
}

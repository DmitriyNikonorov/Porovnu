//
//  EventViewModel.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 05.02.2026.
//

import SwiftUI
import SwiftData

struct EventViewInputModule {
    let event: Event
}

@Observable
final class EventViewModel: ViewModel {
    var event: Event

    /// Траты каждого участника. id участника: [Его Траты]
    private var allSpendings = [UUID: [Spending]]()
    /// Траты по которым участник является должником. id участника: [Трата по которой он должник]
    private var contributorsDebts = [UUID: [Spending]]()

    /// Достается из SwiftData и маппится в словарь
    /// Быстрый доступ к тратам по id
    private var spendingsDict = [UUID: Spending]()


//    @Published var artСheckedModel: ShortListModel?
//    @Published var disneyСheckedModel: ShortListModel?

    init(event: Event) {
        self.event = event
        super.init()
        setupModelContainer()
//        startSetup()
//        bind()

//        events = [Event(name: "Рутовеч", participants: []), Event(name: "Поход", participants: [])]
    }
}

// MARK: - Private

private extension EventViewModel {
    func calculateSpendings() {
        // Пока берем первого участника, потом брать того кто isUser
        // Маппим траты каждого участника
        allSpendings = Dictionary(uniqueKeysWithValues: event.contributors.map { ($0.id, $0.spendings) })

        /// При подсчете трат составляется словарь в рамках модуля, где ключ - id участника, значением - массив с Тратами.
        /// Это пригодится, чтобы показать детализацию трат для каждого участника.
        ///  Для отображения всех трат не нужно сразу использовать взаимозачет, надо показывать суммы по каждой транзакции. И общую сумму долгов, из которой уже вычитается общая сумма трат при взаимозачете, и общая сумма будет с взаимозачетом
        allSpendings.forEach { creditorId, spendings in
            let holders = spendings.flatMap { $0.holders }
            holders.forEach { holder in
                if let spending = spendingsDict[holder.spendingId] {
                    contributorsDebts[holder.contributorId, default: []].append(spending)
                }
            }
        }

        let updatedContributors = event.contributors.reduce(into: [Contributor]()) { result, contributor in
            if let debts = contributorsDebts[contributor.id] {
                contributor.caclulateTotalDebts(for: debts)
                result.append(contributor)
            }
        }

        event = event.updateContributors(with: updatedContributors)
    }


    private func setupModelContainer() {
//        do {
//            // Создаем контейнер только с нужными моделями
//            let schema = Schema([DBShortListModel.self])
//            let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//            modelContainer = try ModelContainer(for: schema, configurations: [config])
//
//            if let container = modelContainer {
//                modelContext = ModelContext(container)
//            }
//        } catch {
//            debugPrint("Failed to create model container: \(error)")
//        }
    }
}

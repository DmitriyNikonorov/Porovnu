//
//  NavigationCoordinator.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 07.02.2026.
//

import Foundation
import SwiftUI
import Combine

enum AppRoute: Hashable {
    case createEvent
    case eventDetails(Event)
}

enum RouteAction: String {
    case back = "Back"
    case toRoot = "To Root"
    case backSteps = "Back Steps:"
}

// MARK: - Coordinator Protocol

protocol Coordinatable: ObservableObject {
    associatedtype Route: Hashable
    var homePath: NavigationPath { get set }
    func navigate(to route: Route)
    func navigateBack()
    func navigateToRoot()
}

enum TabItem: Int, Hashable {
    case home, profile

    var image: Image {
        switch self {
        case .home:
            AppImages.homeTab.image

        case .profile:
            AppImages.profileTab.image
        }
    }

    var imageName: String {
        switch self {
        case .home:
            AppImages.homeTab.tabBarImageName

        case .profile:
            AppImages.profileTab.tabBarImageName
        }
    }

    var title: String {
        switch self {
        case .home:
            return "Мероприятия"

        case .profile:
            return "Профиль"
        }
    }
}


class NavigationCoordinator: ObservableObject, Coordinatable {
    typealias Route = AppRoute

    // MARK: - Published Properties

    @Published var selectedTab: TabItem = .home
    @Published var homePath = NavigationPath()
    @Published var profilePath = NavigationPath()

    // MARK: - Navigation Methods

    func navigate(to route: AppRoute) {
        switch selectedTab {
        case .home:
            homePath.append(route)

        case .profile:
            profilePath.append(route)
        }
        logNavigation(to: route)
    }

    func navigateBack() {
        switch selectedTab {
        case .home where !homePath.isEmpty:
            homePath.removeLast()

        case .profile where !profilePath.isEmpty:
            profilePath.removeLast()

        default:
            break
        }

        logNavigation(action: RouteAction.back.rawValue)
    }

    func navigateToRoot() {
        switch selectedTab {
        case .home where !homePath.isEmpty:
            homePath = NavigationPath()

        case .profile where !profilePath.isEmpty:
            profilePath = NavigationPath()

        default:
            break
        }

        logNavigation(action: RouteAction.toRoot.rawValue)
    }

    func navigateBack(steps: Int) {
        switch selectedTab {
        case .home where !homePath.isEmpty:
            guard steps >= homePath.count else {
                return
            }

            for _ in 0..<steps {
                navigateBack()
            }

        case .profile where !profilePath.isEmpty && steps >= profilePath.count:
            for _ in 0..<steps {
                navigateBack()
            }

        default:
            break
        }

        logNavigation(action: RouteAction.backSteps.rawValue + "\(steps)")
    }

//    func navigate(to route: AppRoute) {
//        guard !isNavigating else { return }
//
//        isNavigating = true
//        DispatchQueue.main.async { [weak self] in
//            guard let self = self else { return }
//            self.navigationPath.append(route)
//            self.isNavigating = false
//            self.logNavigation(to: route)
//        }
//    }

    var isHomeRoot: Bool {
        homePath.isEmpty
    }

    var isProfileRoot: Bool {
        profilePath.isEmpty
    }


    // MARK: - Convenience Methods
    
    func goToCreateEvent() {
        navigate(to: .createEvent)
    }
//
//    func goToEventDetails(_ event: Event) {
//        navigate(to: .eventDetails(event))
//    }
//
//    func goToSettings() {
//        navigate(to: .settings)
//    }
//
//    func goToProfile(userId: String) {
//        navigate(to: .profile(userId: userId))
//    }
//
// MARK: - Navigation State

    /// Текущий активный маршрут
//    var currentRoute: AppRoute? {
//        guard let last = path.last else {
//            return nil
//        }
//
//        return last as? AppRoute
//    }
//
//    func isCurrentlyOn(_ route: AppRoute) -> Bool {
//        return currentRoute == route
//    }

//    var navigationHistory: [AnyHashable] {
//        return navigationPath.reversed()
//    }
}

private extension NavigationCoordinator {

    func logNavigation(to route: AppRoute? = nil, action: String? = nil) {
        #if DEBUG
        let routeDescription = route.map { "to \($0)" } ?? ""
        let actionDescription = action.map { "\($0)" } ?? ""
        let tabDiscription = selectedTab.rawValue
        print("Current tab: \(tabDiscription)\nNavigationCoordinator: \(actionDescription) \(routeDescription)")
        print("Path count: \(homePath.count)")
        print("")
        #endif
    }
}



// 1. Deeplink Handling
//extension NavigationCoordinator {
//    func handleDeepLink(_ url: URL) {
//        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
//              let host = components.host else { return }
//
//        switch host {
//        case "event":
//            if let id = components.queryItems?.first(where: { $0.name == "id" })?.value {
//                // Загрузка события по ID и навигация
//                navigate(to: .eventDetails(Event(name: "Event \(id)", contributors: [])))
//            }
//        case "create":
//            navigate(to: .createEvent)
//        default:
//            break
//        }
//    }
//}

// 2. Navigation Middleware (для логирования, аналитики и т.д.)
//protocol NavigationMiddleware {
//    func willNavigate(to route: AppRoute)
//    func didNavigate(to route: AppRoute)
//}
//
//extension NavigationCoordinator {
//    private var middlewares: [NavigationMiddleware] {
//        return [
//            AnalyticsMiddleware(),
//            LoggingMiddleware()
//        ]
//    }
//
//    private func notifyWillNavigate(to route: AppRoute) {
//        middlewares.forEach { $0.willNavigate(to: route) }
//    }
//
//    private func notifyDidNavigate(to route: AppRoute) {
//        middlewares.forEach { $0.didNavigate(to: route) }
//    }
//}

// 3. Сохранение состояния навигации
//extension NavigationCoordinator {
//    func saveNavigationState() {
//        let encoder = JSONEncoder()
//        if let data = try? encoder.encode(navigationPath.codable) {
//            UserDefaults.standard.set(data, forKey: "navigationState")
//        }
//    }
//
//    func restoreNavigationState() {
//        guard let data = UserDefaults.standard.data(forKey: "navigationState"),
//              let codablePath = try? JSONDecoder().decode(NavigationPath.CodableRepresentation.self, from: data) else {
//            return
//        }
//        navigationPath = NavigationPath(codablePath)
//    }
//}

//
//  CreateEventView.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 02.02.2026.
//

import SwiftUI

struct CreateEventView: View {

    @Environment(NavigationCoordinator.self) private var navigationCoordinator
    @FocusState private var isFocused: Bool
    let viewModel: CreateEventViewModel

    @State private var showTopToast = false

    // Добавляем состояние для отслеживания видимости кнопки
    @State private var isAddButtonInListVisible = true
    // Имя координатного пространства для отслеживания
    private let coordinateSpaceName = "scrollView"

    var body: some View {
        ZStack {
            createForm()
                .background(Color.appColor(.backgroundSecondary))
                .listStyle(.plain)
//                .foregroundStyle(Color.appColor(.backgroundSecondary))
                .contentMargins(.bottom, 90, for: .scrollContent)

            VStack {
                Spacer()
                Button {
                    viewModel.addContributor()
                } label: {
                    AppImages.personBadgePlus.image
                        .resizable()
                        .frame(width: 36, height: 36)
                        .foregroundStyle(Color.appColor(.orangeBrand))
                }
                .buttonStyle(PlainButtonStyle())
                .frame(width: 48, height: 48)
                .padding(.bottom, 60)
                // Показываем кнопку только когда кнопка в листе НЕ видна
                .opacity(isAddButtonInListVisible ? 0 : 1)
                .disabled(isAddButtonInListVisible)
            }
            .ignoresSafeArea(.keyboard)
        }
        .navigationBar(
            model: NavigationBarModel(
                type: .creationEvent(title: "Новое событие"),
                leadingButtonAction: leadingButtonAction,
                trailingButtonAction: trailingButtonAction
            )
        )
        .showToast(
            showToast: $showTopToast,
            content: createToast()
        )
    }
}

private extension CreateEventView {

    var leadingButtonAction: NavigationBarButtonActionType {
        NavigationBarButtonActionType(firstAction: navigationCoordinator.navigateToRoot)
    }

    var trailingButtonAction: NavigationBarButtonActionType {
        NavigationBarButtonActionType(
            firstAction: {
                guard let event = viewModel.createEvent() else {
                    withAnimation {
                        showTopToast = true
                    }
                    return
                }

                navigationCoordinator.navigate(to: .eventDetails(event))
            }
        )
    }

    func createForm() -> some View {
        List {
            Text("Название мероприятия")
                .foregroundStyle(Color.appColor(.textQuaternary))
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)

            CustomTextField(
                placeholder: "Введите название",
                position: .single,
                text: Bindable(viewModel).eventName
            )
            .listRowInsets(EdgeInsets())
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
            .padding(.horizontal)

            Text("Участники")
                .foregroundStyle(Color.appColor(.textQuaternary))
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .padding(.top, 12)

            ForEach(Bindable(viewModel).contributors, id: \.id) { item in
                let index = Bindable(viewModel).contributors.firstIndex(where: { $0.id == item.id }) ?? 0

                CustomTextField(
                    placeholder: "Участник \((index) + 1)",
                    position: definePosition(for: index, in: Bindable(viewModel).contributors.count),
                    text: item.name
                )
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .padding(.horizontal)
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    if viewModel.canDeleteContributor(at: index) {
                        Button {
                            withAnimation {
                                viewModel.deleteContributor(at: index)
                            }
                        } label: {
                            Image(uiImage: "trash", withColor: .red)
                        }
                        .tint(.clear)
                    }
                }
            }

            Button {
                viewModel.addContributor()
            } label: {
                HStack {
                    Spacer()
                    AppImages.personBadgePlus.image
                        .resizable()
                        .frame(width: 36, height: 36)
                        .foregroundStyle(Color.appColor(.orangeBrand))
                    Spacer()
                }
            }
            .padding(.top, 16.0)
            .buttonStyle(PlainButtonStyle())
            .listRowBackground(Color.clear)
            .listRowSeparator(.hidden)
            .visibilityTracker(
                isVisible: $isAddButtonInListVisible,
                coordinateSpace: coordinateSpaceName
            )
            .opacity(isAddButtonInListVisible ? 1 : 0)
            .disabled(!isAddButtonInListVisible)

        }
    }

    private func createToast() -> some View {
        ToastView(
            showToast: $showTopToast,
            toastData: ToastView.ToastData(
                title: "Заполните поля",
                message: "Укажите название мероприятия и хотя бы одного участника"
            )
        )
    }

    func definePosition(for index: Int, in arrayCount: Int) -> FieldPosition {
        switch (index, arrayCount) {
        case (0, 1):
                .single

        case (0, _):
                .top

        case (arrayCount - 1, _):
                .bottom

        default:
                .middle
        }
    }
}

struct VisibilityTrackerModifier: ViewModifier {

    @Binding var isVisible: Bool
    let coordinateSpace: String

    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geometry in
                    Color.clear
                        .onAppear {
                            updateVisibility(with: geometry)
                        }
                        .onChange(of: geometry.frame(in: .named(coordinateSpace)).minY) {
                            updateVisibility(with: geometry)
                        }
                }
            )
    }

    private func updateVisibility(with geometry: GeometryProxy) {
        let frame = geometry.frame(in: .named(coordinateSpace))

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let screenHeight = windowScene.screen.bounds.height
            let isCurrentlyVisible = frame.maxY > 140 && frame.minY < screenHeight - 150
            isVisible = isCurrentlyVisible
        }
    }
}

extension View {
    func visibilityTracker(isVisible: Binding<Bool>, coordinateSpace: String) -> some View {
        modifier(VisibilityTrackerModifier(isVisible: isVisible, coordinateSpace: coordinateSpace))
    }
}


struct ToastView: View {

    struct ToastData {
        var title: String
        var message: String
    }

    @Binding var showToast: Bool
    let toastData: ToastData
    @State private var toastTask: Task<Void, Error>?

    var body: some View {
        VStack {
            HStack {
                Image(systemName: "checkmark")
                VStack(alignment: .leading, spacing: 2) {
                    Text(LocalizedStringKey(toastData.title))
                        .font(.subheadline)
                        .fontWeight(.bold)
                    Text(LocalizedStringKey(toastData.message))
                        .font(.callout)
                        .opacity(0.9)

                }
                Spacer()
            }
            .padding(10)


            .foregroundColor(Color.appColor(.text))
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.appColor(.orangeBrand).opacity(0.9),
                                Color.appColor(.orangeBrand).opacity(0.95)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .blur(radius: 1.0)

            )
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.appColor(.background).opacity(0.3), lineWidth: 0.5)
            )
            .shadow(color: Color.appColor(.background).opacity(0.1), radius: 10, y: 2)

            Spacer()
        }
        .padding()
        .opacity(showToast ? 1.0 : 0)
        .transition(.opacity)
        .onAppear {
            toastTask = Task {
                try await Task.sleep(nanoseconds: 2_500_000_000)
                await MainActor.run {
                    withAnimation {
                        showToast = false
                    }
                }
            }
        }
        .onDisappear {
            toastTask?.cancel()
        }
        .onTapGesture {
            toastTask?.cancel()
            withAnimation {
                showToast = false
            }
        }
    }
}

struct ToastModifier<T: View>: ViewModifier {

    @Binding var showToast: Bool
    // let tostContent: T - это свойство модификатора, в котором хранится ТОСТ
    let tostContent: T

    // content: Content - это параметр метода body, сам view к которому применяется модификатор
    func body(content: Content) -> some View {
        ZStack {
            content //  ← первый content - это ОСНОВНОЙ экран (переданный через модификато)
            ZStack {
                if showToast {
                    tostContent  // ← второй content - это ТОСТ (свойство модификатора)
                } else {
                    EmptyView()
                }
            }
        }
    }
}

extension View {

    func showToast<T: View>(showToast: Binding<Bool>, content: T) -> some View {
        self.modifier(ToastModifier(showToast: showToast, tostContent: content))
    }
}

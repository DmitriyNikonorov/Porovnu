//
//  Localized.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 27.03.2026.
//

import Foundation

enum Localized {

    // MARK: - Common

    enum Common {
        /// Участники / Contributors
        static var contributors: String {
            NSLocalizedString("contributors", comment: "Contributors section title")
        }

        /// Участник / Contributor
        static var contributor: String {
            NSLocalizedString("contributor", comment: "Single contributor label")
        }

        /// Участник %@ / Contributor %@
        static func contributorAmount(amount: Int) -> String {
            let format = NSLocalizedString("contributor", comment: "Single contributor label with amount")
            return String.localizedStringWithFormat(format, amount)
        }

        /// Ошибка! / Error!
        static var errorTitle: String {
            NSLocalizedString("errorTitle", comment: "Error alert title")
        }

        /// Отмена / Cancel
        static var cancel: String {
            NSLocalizedString("cancel", comment: "Cancel button")
        }

        /// Создать / Create
        static var create: String {
            NSLocalizedString("create", comment: "Create button")
        }

        /// Назад / Back
        static var back: String {
            NSLocalizedString("back", comment: "Back button")
        }
    }

    // MARK: - ContributorInfoView

    enum ContributorInfoView {
        /// Добавить трату / Add Spending
        static var addSpending: String {
            NSLocalizedString("addSpending", comment: "Add Spending button")
        }
    }

    // MARK: - SpendingRowView

    enum SpendingRowView {
        /// Удалить трату / Delete Spending
        static var deleteSpending: String {
            NSLocalizedString("deleteSpending", comment: "Delete Spending button")
        }
    }

    // MARK: - EditEventView

    enum EditEventView {
        /// Вы пытаетесь уйти без сохранения! / You are trying to leave without saving!
        static var unsavedChangesTitle: String {
            NSLocalizedString("unsavedChangesTitle", comment: "Unsaved changes alert title")
        }

        /// Сохранить и выйти / Save and Exit
        static var saveAndExit: String {
            NSLocalizedString("saveAndExit", comment: "Save and exit button")
        }

        /// Выйти без сохранения / Exit without Saving
        static var exitWithoutSaving: String {
            NSLocalizedString("exitWithoutSaving", comment: "Exit without saving button")
        }

        /// Остаться / Stay
        static var stay: String {
            NSLocalizedString("stay", comment: "Stay button")
        }

        /// Без сохранения все изменения будут потеряны / All changes will be lost if you don't save.
        static var unsavedChangesMessage: String {
            NSLocalizedString("unsavedChangesMessage", comment: "Unsaved changes alert message")
        }

        /// Редактирование / Editing
        static var editing: String {
            NSLocalizedString("editing", comment: "Editing title")
        }

        /// Информация / Information
        static var info: String {
            NSLocalizedString("info", comment: "Information section title")
        }

        /// Введите название / Enter name
        static var enterNamePlaceholder: String {
            NSLocalizedString("enterNamePlaceholder", comment: "Enter name placeholder")
        }

        /// Пока нет\nни одного участника / No contributors\nyet
        static var noContributorsPlaceholder: String {
            NSLocalizedString("noContributorsPlaceholder", comment: "No contributors placeholder")
        }

        /// Все расходы / All expenses
        static var allExpenses: String {
            NSLocalizedString("allExpenses", comment: "All expenses option")
        }

        /// Собственные средства / Own funds
        static var ownFunds: String {
            NSLocalizedString("ownFunds", comment: "Own funds option")
        }

        /// В долг / In debt
        static var inDebt: String {
            NSLocalizedString("inDebt", comment: "In debt option")
        }

        /// Получит от / Will receive from
        static var willReceiveFrom: String {
            NSLocalizedString("willReceiveFrom", comment: "Will receive from label")
        }

        /// Долг перед / Debt owed
        static var debtOwed: String {
            NSLocalizedString("debtOwed", comment: "Debt owed label")
        }

        /// Сохранено / Saved
        static var saved: String {
            NSLocalizedString("saved", comment: "Saved status")
        }

        /// Внесенные изменения сохранены / Changes saved
        static var changesSaved: String {
            NSLocalizedString("changesSaved", comment: "Changes saved message")
        }

        /// Нельзя удалить участника / Cannot delete contributor
        static var cannotDeleteContributor: String {
            NSLocalizedString("cannotDeleteContributor", comment: "Cannot delete contributor error")
        }

        /// В мероприятии должен быть хотя бы один участник / The event must have at least one contributor
        static var atLeastOneContributorRequired: String {
            NSLocalizedString("atLeastOneContributorRequired", comment: "At least one contributor required error")
        }

        /// Без названия / untitled
        static var untitled: String {
            NSLocalizedString("untitled", comment: "Title without naming")
        }

        /// Данные обновятся после сохранения / Data will update after saving
        static var dataWillUpdateAfterSaving: String {
            NSLocalizedString("dataWillUpdateAfterSaving", comment: "Changes saved message")
        }
    }

    // MARK: - EventCardView

    enum EventCardView {
        /// участников / contributors
        static func contributorsCount(_ count: Int) -> String {
            let format = NSLocalizedString("contributorsCount", comment: "Contributors count")
            return String.localizedStringWithFormat(format, count)
        }
    }

    // MARK: - EventsListView

    enum EventsListView {
        /// Мероприятия / Events
        static var events: String {
            NSLocalizedString("events", comment: "Events list title")
        }

        /// Удалено / Deleted
        static var deleted: String {
            NSLocalizedString("deleted", comment: "Deleted status")
        }

        /// Мероприятие удалено / Event deleted
        static var eventDeleted: String {
            NSLocalizedString("eventDeleted", comment: "Event deleted message")
        }
    }

    // MARK: - ProfileView

    enum ProfileView {
        /// Profile / Profile
        static var profile: String {
            NSLocalizedString("profile", comment: "Profile title")
        }
        
        /// Выйти из профиля / Log out
        static var logout: String {
            NSLocalizedString("logout", comment: "Log out button")
        }
    }

    // MARK: - HolderListView

    enum HolderListView {
        /// Сумма / Total Amount
        static var totalAmount: String {
            NSLocalizedString("totalAmount", comment: "Total amount label")
        }
    }

    // MARK: - SpendingView

    enum SpendingView {
        /// Название траты: / Spending name:
        static var spendingNameLabel: String {
            NSLocalizedString("spendingNameLabel", comment: "Spending name label")
        }

        /// Введите название / Enter name
        static var enterNamePlaceholder: String {
            NSLocalizedString("enterNamePlaceholder", comment: "Enter name placeholder")
        }

        /// Общая суммма траты / Total spending amount
        static var totalAmountLabel: String {
            NSLocalizedString("totalAmountLabel", comment: "Total spending amount label")
        }

        /// Введите общую сумму / Enter total amount
        static var enterTotalAmountPlaceholder: String {
            NSLocalizedString("enterTotalAmountPlaceholder", comment: "Enter total amount placeholder")
        }

        /// Добавить трату / Add Spending
        static var addSpending: String {
            NSLocalizedString("addSpending", comment: "Add Spending button")
        }

        /// Сохранить трату / Save Spending
        static var saveSpending: String {
            NSLocalizedString("saveSpendingButton", comment: "Save Spending button")
        }

        /// Добавление траты / Add Spending
        static var addSpendingTitle: String {
            NSLocalizedString("addSpendingTitle", comment: "Add Spending title")
        }

        /// Редактирование траты / Edit Spending
        static var editSpendingTitle: String {
            NSLocalizedString("editSpendingTitle", comment: "Edit Spending title")
        }

        /// Не вся трата распределена между участниками / Not all spending is distributed among participants
        static var contributorExpensesExceedTotal: String {
            NSLocalizedString("contributorExpensesExceedTotal", comment: "Contributors' expenses exceed total error")
        }

        /// Название траты не должно быть пустым / Spending name cannot be empty
        static var nameCannotBeEmpty: String {
            NSLocalizedString("nameCannotBeEmpty", comment: "Spending name cannot be empty error")
        }

        /// Должники по этой трате / Debtors for this spending
        static var debtorsSection: String {
            NSLocalizedString("debtorsSection", comment: "Debtors section title")
        }

        /// Выбранные / Selected
        static var selectedContributorsSection: String {
            NSLocalizedString("selectedContributorsSection", comment: "Selected contributors section title")
        }

        /// Нет выбранных / No selected
        static var noSelectedContributors: String {
            NSLocalizedString("noSelectedContributors", comment: "No selected contributors placeholder")
        }

        /// Распределите общую сумму этой траты между выбранными участниками / Distribute the total amount of this spending among the selected participants
        static var distributeTotalAmountMessage: String {
            NSLocalizedString("distributeTotalAmountMessage", comment: "Debtors section subtitle")
        }

        /// Нераспределенная сумма %@ / Undistributed amount %@
        static func undistributedAmount(_ summ: String) -> String {
            let format = NSLocalizedString("undistributedAmount", comment: "Undistributed amount")
            return String.localizedStringWithFormat(format, summ)
        }

        /// Превысили общую сумму на %@ / Exceeded total amount by %@
        static func exceededTotalAmount(_ summ: String) -> String {
            let format = NSLocalizedString("exceededTotalAmount", comment: "Exceeded total amount")
            return String.localizedStringWithFormat(format, summ)
        }
    }
}

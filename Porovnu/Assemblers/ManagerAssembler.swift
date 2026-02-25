//
//  ManagerAssembler.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 09.02.2026.
//

protocol ManagerAssembler {
    func resolveDataBaseManager() -> DataBaseManagerProtocol
}

extension ManagerAssembler where Self: DefaultAssembler {
    func resolveDataBaseManager() -> DataBaseManagerProtocol {
        DataBaseManager.shared
    }
}

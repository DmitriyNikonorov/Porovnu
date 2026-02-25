//
//  Assembler.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 08.02.2026.
//

import Foundation

protocol Assembler:
    EventsListAssembler,
    EventAssembler,
    EditEventAssembler,
    SpendingAssembler,
    ManagerAssembler {
}

final class DefaultAssembler: Assembler {
    static let shared = DefaultAssembler()
}

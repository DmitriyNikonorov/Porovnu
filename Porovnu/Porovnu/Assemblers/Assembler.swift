//
//  Assembler.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 08.02.2026.
//

import Foundation

protocol Assembler: HomeAssembler, CreateEventAssembler, EventAssembler {
}

final class DefaultAssembler: Assembler {
}

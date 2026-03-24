//
//  IdentifiableModel.swift
//  Porovnu
//
//  Created by Дмитрий Никоноров on 09.02.2026.
//

import Foundation
import SwiftData

protocol IdentifiableModel: PersistentModel {
    var id: UUID { get }
}

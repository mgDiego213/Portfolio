//
//  Theme.swift
//  SkillUp
//
//  Created by Alumno on 09/10/25.
//

import SwiftUI

enum Theme {
    static let primary = Color(hex: 0x3B82F6) // Azul brillante
    static let accent  = Color(hex: 0x22C55E) // Verde
    static let warn    = Color(hex: 0xF59E0B) // Amarillo
    static let danger  = Color(hex: 0xEF4444) // Rojo
    static let bg      = Color(uiColor: .systemBackground)
}

extension Color {
    init(hex: UInt, alpha: Double = 1.0) {
        self.init(.sRGB,
                  red:   Double((hex >> 16) & 0xff) / 255,
                  green: Double((hex >> 08) & 0xff) / 255,
                  blue:  Double((hex >> 00) & 0xff) / 255,
                  opacity: alpha)
    }
}
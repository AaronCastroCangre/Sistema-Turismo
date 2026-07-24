//
//  ThemeManager.swift
//  PA3
//
//  Created by Alumno on 16/06/26.
//

import SwiftUI
import Combine

class ThemeManager: ObservableObject {

    @Published var isDarkMode = false

    func toggleTheme() {
        isDarkMode.toggle()
    }
}

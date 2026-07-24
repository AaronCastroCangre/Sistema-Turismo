//
//  PA3App.swift
//  PA3
//
//  Created by Alumno on 11/06/26.
//
import SwiftUI
import FirebaseCore

@main
struct PA3App: App {

    @StateObject var sesionUsuario = SesionUsuario()

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {

        WindowGroup {

            ContentView()
                .environmentObject(sesionUsuario)

        }
    }
}

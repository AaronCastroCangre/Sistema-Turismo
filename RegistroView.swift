//
//  RegistroView.swift
//  PA3
//
//  Created by Alumno on 2/07/26.
//
//
//  RegistroView.swift
//  PA3
//
//  Created by Alumno on 2/07/26.
//
//
//  RegistroView.swift
//  PA3
//
//  Created by Alumno on 2/07/26.
//
//
//  RegistroView.swift
//  PA3
//
//  Created by Alumno on 2/07/26.
//
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct RegistroView: View {

    @State private var nombre = ""
    @State private var correo = ""
    @State private var clave = ""

    @State private var navegar = false
    @State private var mensajeError = ""
    @State private var mostrarError = false

    @AppStorage("esInvitado") var esInvitado = true
    @AppStorage("sesionIniciada") var sesionIniciada = false
    @EnvironmentObject var sesionUsuario: SesionUsuario

    func registrar() {

        Auth.auth().createUser(withEmail: correo, password: clave) { result, error in

            if let error = error {

                mensajeError = error.localizedDescription
                mostrarError = true
                return
            }

            guard let uid = result?.user.uid else { return }

            let db = Firestore.firestore()

            db.collection("usuarios").document(uid).setData([

                "nombre": nombre,
                "correo": correo

            ]) { error in

                if let error = error {

                    mensajeError = error.localizedDescription
                    mostrarError = true
                    return
                }


                let changeRequest = result?.user.createProfileChangeRequest()
                changeRequest?.displayName = nombre
                changeRequest?.commitChanges { _ in }

                print("Usuario registrado correctamente")

                sesionUsuario.nombre = nombre
                esInvitado = false
                sesionIniciada = true
                navegar = true
            }
        }
    }

    var body: some View {

        VStack(spacing: 20) {

            StatusBarView()
                .foregroundColor(.white)

            Spacer()

            VStack(spacing: 15) {

                Image(systemName: "person.crop.circle.badge.plus")
                                     .font(.system(size: 90))
                                     .foregroundColor(.white)



                Text("Crear Cuenta")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)

                Text("Regístrate para acceder a todas las funciones")
                    .foregroundColor(.white.opacity(0.9))
            }

            VStack(spacing: 15) {

                TextField("Ingrese nombre", text: $nombre)
                    .padding()
                    .background(Color.white.opacity(0.95))
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .padding(.horizontal, 25)

                TextField("Ingrese correo", text: $correo)
                    .padding()
                    .background(Color.white.opacity(0.95))
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .padding(.horizontal, 25)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)

                SecureField("Ingrese contraseña", text: $clave)
                    .padding()
                    .background(Color.white.opacity(0.95))
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .padding(.horizontal, 25)

                Button {

                    registrar()

                } label: {

                    Text("Registrarme")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.orange)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .padding(.horizontal, 25)
                }
            }

            Spacer()
        }
        .offset(y: -25)
        .background(
            ZStack {
                Image("cruz")
                    .resizable()
                    .scaledToFill()

                LinearGradient(
                    colors: [
                        Color.black.opacity(0.7),
                        Color.black.opacity(0.3),
                        Color.black.opacity(0.7)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .ignoresSafeArea()
        )
        .alert("Error", isPresented: $mostrarError) {

            Button("OK") { }

        } message: {

            Text(mensajeError)
        }

        .navigationDestination(isPresented: $navegar) {

            HomeView()
                .navigationBarBackButtonHidden(true)
        }
        .onAppear {
            nombre = ""
            correo = ""
            clave = ""
        }
    }
}

#Preview {

    NavigationStack {

        RegistroView()
    }
}

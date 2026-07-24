//
//  Perfilview.swift
//  PA3
//
//  Created by Alumno on 17/07/26.
//
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct PerfilView: View {

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var sesionUsuario: SesionUsuario

    @State private var nombre: String = ""
    @State private var correo: String = ""
    @State private var contrasena: String = ""

    @State private var modoEdicion: Bool = false
    @State private var mostrarAlerta: Bool = false
    @State private var mensajeAlerta: String = ""
    @State private var mostrarError: Bool = false
    @State private var mensajeError: String = ""

    var body: some View {
        VStack(spacing: 20) {

            StatusBarView()
                .foregroundColor(.white)

            Spacer()

            VStack(spacing: 15) {

                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 90))
                    .foregroundColor(.white)

                Text("Mi Perfil")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
            }

            VStack(spacing: 15) {

                if modoEdicion {

                    TextField("Nombre", text: $nombre)
                        .padding()
                        .background(Color.white.opacity(0.95))
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .padding(.horizontal, 25)

                    TextField("Correo", text: $correo)
                        .padding()
                        .background(Color.white.opacity(0.95))
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .padding(.horizontal, 25)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)

                    SecureField("Contraseña", text: $contrasena)
                        .padding()
                        .background(Color.white.opacity(0.95))
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .padding(.horizontal, 25)

                    Button {
                        guardarCambios()
                    } label: {
                        Text("Guardar Cambios")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            .padding(.horizontal, 25)
                    }

                } else {

                    TextField("Nombre", text: .constant(nombre))
                        .padding()
                        .background(Color.white.opacity(0.95))
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .padding(.horizontal, 25)
                        .disabled(true)

                    TextField("Correo", text: .constant(correo))
                        .padding()
                        .background(Color.white.opacity(0.95))
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .padding(.horizontal, 25)
                        .disabled(true)

                    SecureField("Contraseña", text: .constant(contrasena))
                        .padding()
                        .background(Color.white.opacity(0.95))
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .padding(.horizontal, 25)
                        .disabled(true)

                    Button {
                        withAnimation {
                            modoEdicion = true
                        }
                    } label: {
                        Text("Editar Perfil")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            .padding(.horizontal, 25)
                    }
                }
            }

            Spacer()
        }
        
        .background(
            ZStack {
                Image("pichu")
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
        .onAppear {
            cargarDatosUsuario()
        }
        .alert("Datos actualizados correctamente.", isPresented: $mostrarAlerta) {
            Button("OK") { }
        }
        .alert("Error", isPresented: $mostrarError) {
            Button("OK") { }
        } message: {
            Text(mensajeError)
        }
    }

    func cargarDatosUsuario() {

        guard let user = Auth.auth().currentUser else { return }

        correo = user.email ?? ""

        let db = Firestore.firestore()
        db.collection("usuarios").document(user.uid).getDocument { document, error in

            if let error = error {
                print(error.localizedDescription)
                return
            }

            if let data = document?.data() {
                nombre = data["nombre"] as? String ?? ""
            }
        }
    }

    func guardarCambios() {

        guard let user = Auth.auth().currentUser else { return }

        let db = Firestore.firestore()

        db.collection("usuarios").document(user.uid).updateData([
            "nombre": nombre
        ]) { error in

            if let error = error {
                mensajeError = error.localizedDescription
                mostrarError = true
                return
            }

            sesionUsuario.nombre = nombre

            
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = nombre
            changeRequest.commitChanges { _ in }

         
            if correo != user.email {
                user.updateEmail(to: correo) { error in
                    if let error = error {
                        mensajeError = error.localizedDescription
                        mostrarError = true
                        return
                    }
                }
            }

          
            if !contrasena.isEmpty {
                user.updatePassword(to: contrasena) { error in
                    if let error = error {
                        mensajeError = error.localizedDescription
                        mostrarError = true
                        return
                    }
                }
            }

            modoEdicion = false
            mostrarAlerta = true
        }
    }
}

#Preview {
    NavigationStack {
        PerfilView()
            .environmentObject(SesionUsuario())
    }
}

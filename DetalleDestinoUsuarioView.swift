//
//  DetalleDestinoUsuarioView.swift
//  PA3
//
//  Created by Alumno on 21/07/26.
//
import SwiftUI
import FirebaseFirestore
import FirebaseAuth
 
struct DetalleDestinoUsuarioView: View {
 
    let destino: DestinoUsuario
 
    @Environment(\.dismiss) var dismiss
 
    @State private var imagenes: [UIImage] = []
    @State private var mostrarImagePicker = false
    @State private var mostrarExito = false
    @State private var mostrarError = false
    @State private var mensajeError: String = ""
    @State private var imagenSeleccionada: UIImage? = nil
 
    @State private var imagenParaZoom: UIImage? = nil
    @State private var mostrarImagenCompleta = false
 

    @State private var mostrarConfirmarEliminar = false
    @State private var eliminandoDestino = false
 
    var esAutor: Bool {
        Auth.auth().currentUser?.email == destino.correo
    }
 
    var body: some View {
 
        ScrollView {
 
            VStack(spacing: 20) {
 
                StatusBarView()
 
                if let primeraImagen = destino.imagenNombres.first,
                   let uiImage = DestinoImageManager.shared.cargarImagen(nombreArchivo: primeraImagen) {
 
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 250)
                        .frame(maxWidth: .infinity)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(radius: 5)
                        .padding(.horizontal)
                        .onTapGesture {
                            imagenParaZoom = uiImage
                            mostrarImagenCompleta = true
                        }
                } else {
 
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 250)
                        .overlay(
                            Image(systemName: "photo")
                                .font(.system(size: 60))
                                .foregroundColor(.gray)
                        )
                        .padding(.horizontal)
                }
 
                Text(destino.titulo)
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.primary)
                    .padding(.horizontal)
 
                HStack(spacing: 6) {
                    Image(systemName: "person.circle.fill")
                        .foregroundColor(.orange)
                    Text("Por \(destino.autor)")
                        .foregroundColor(.orange)
                        .font(.subheadline)
                }
                .padding(.horizontal)
 

                    .font(.body)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal)
 

                if !imagenes.isEmpty {
 
                    VStack(alignment: .leading, spacing: 12) {
 
                        Text("Galería")
                            .font(.title2)
                            .bold()
                            .padding(.horizontal)
 
                        ScrollView(.horizontal, showsIndicators: false) {
 
                            HStack(spacing: 12) {
 
                                ForEach(imagenes.indices, id: \.self) { index in
                                    Image(uiImage: imagenes[index])
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 120, height: 120)
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
                                        .onTapGesture {
                                            imagenParaZoom = imagenes[index]
                                            mostrarImagenCompleta = true
                                        }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
 
                Button {
                    mostrarImagePicker = true
                } label: {
                    Label("Agregar Fotos", systemImage: "photo.badge.plus.fill")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .padding(.horizontal, 25)
                }
                .disabled(imagenes.count >= 6)
                .opacity(imagenes.count >= 6 ? 0.6 : 1)
 
                      if esAutor {
                    Button(role: .destructive) {
                        mostrarConfirmarEliminar = true
                    } label: {
                        Label("Eliminar Destino", systemImage: "trash.fill")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            .padding(.horizontal, 25)
                    }
                    .disabled(eliminandoDestino)
                    .opacity(eliminandoDestino ? 0.6 : 1)
                }
 
                Spacer(minLength: 40)
            }
            .padding(.vertical, 10)
        }
        .navigationTitle("Detalle")
        .sheet(isPresented: $mostrarImagePicker) {
            ImagePicker(
                selectedImage: Binding(
                    get: { nil },
                    set: { nuevaImagen in
                        if let imagen = nuevaImagen {
                            agregarImagen(imagen)
                        }
                    }
                ),
                isPresented: $mostrarImagePicker
            )
        }
        .alert("Fotos agregadas correctamente.", isPresented: $mostrarExito) {
            Button("OK") { }
        }
        .alert("Error", isPresented: $mostrarError) {
            Button("OK") { }
        } message: {
            Text(mensajeError)
        }
        .alert("¿Eliminar este destino?", isPresented: $mostrarConfirmarEliminar) {
            Button("Cancelar", role: .cancel) { }
            Button("Eliminar", role: .destructive) {
                eliminarDestino()
            }
        } message: {
            Text("Esta acción no se puede deshacer.")
        }
        .fullScreenCover(isPresented: $mostrarImagenCompleta) {
            if let imagen = imagenParaZoom {
                FullScreenImageView(image: imagen)
            }
        }
        .onAppear {
            cargarImagenes()
        }
    }
 
    func cargarImagenes() {
        imagenes = []
        for nombre in destino.imagenNombres {
            if let uiImage = DestinoImageManager.shared.cargarImagen(nombreArchivo: nombre) {
                imagenes.append(uiImage)
            }
        }
    }
 
    func eliminarDestino() {
        eliminandoDestino = true
 
        DestinoFirestoreManager.shared.eliminarDestino(id: destino.id) { result in
            switch result {
            case .success:
              
                DestinoImageManager.shared.eliminarImagenes(nombres: destino.imagenNombres)
 
                DispatchQueue.main.async {
                    dismiss()
                }
 
            case .failure(let error):
                DispatchQueue.main.async {
                    eliminandoDestino = false
                    mensajeError = error.localizedDescription
                    mostrarError = true
                }
            }
        }
    }
 
    func agregarImagen(_ nuevaImagen: UIImage) {
        guard imagenes.count < 6 else { return }
 
        // Guardar localmente
        let nombre = DestinoImageManager.shared.guardarImagen(nuevaImagen, destinoID: destino.id, index: destino.imagenNombres.count + imagenes.count)
        imagenes.append(nuevaImagen)
 
        // Actualizar Firestore con el nuevo nombre
        let db = Firestore.firestore()
        let todosLosNombres = destino.imagenNombres + [nombre]
 
        db.collection("destinosUsuarios").document(destino.id).updateData([
            "imagenNombres": todosLosNombres
        ]) { error in
            if let error = error {
                mensajeError = error.localizedDescription
                mostrarError = true
            } else {
                mostrarExito = true
            }
        }
    }
}
 
#Preview {
    NavigationStack {
        DetalleDestinoUsuarioView(
            destino: DestinoUsuario(
                id: "preview",
                titulo: "Playa Hermosa",
                descripcion: "Una playa increíble para visitar en verano.",
                autor: "Cristian",
                correo: "cristian@test.com",
                imagenNombres: [],
                timestamp: Date()
            )
        )
    }
}

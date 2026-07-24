//
//  CrearDestinoView.swift
//  PA3
//
//  Created by Alumno on 21/07/26.
//
import SwiftUI
import FirebaseAuth
 
struct CrearDestinoView: View {
 
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var sesionUsuario: SesionUsuario
 
    @State private var titulo: String = ""
    @State private var descripcion: String = ""
 
    // Imágenes seleccionadas (máximo 3)
    @State private var imagenes: [UIImage] = []
    @State private var mostrarImagePicker = false
    @State private var slotSeleccionado: Int = 0
 
    @State private var mostrarExito = false
    @State private var mostrarError = false
    @State private var mensajeError: String = ""
 
    var body: some View {
 
        ScrollView {
 
            VStack(spacing: 26) {
 
                StatusBarView()
 
                ZStack(alignment: .topTrailing) {
 
                    VStack(alignment: .leading, spacing: 6) {
 
                        Text("")
                            .font(.system(size: 12, weight: .bold))
                            .tracking(2)
                            .foregroundColor(.orange)
 
                        Text("Nuevos Recurdos")
                            .font(.system(size: 32, weight: .heavy, design: .rounded))
                            .foregroundColor(.primary)
 
                        Text("Añade los mejores momentos de tus viajes.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.trailing, 66)
                    .frame(maxWidth: .infinity, alignment: .leading)
                

                ZStack {
                                     RoundedRectangle(cornerRadius: 10)
                                         .strokeBorder(Color.orange, style: StrokeStyle(lineWidth: 2, dash: [4, 3]))
                                         .frame(width: 64, height: 76)
              
                                     VStack(spacing: 3) {
                                         Image(systemName: "mappin.and.ellipse")
                                             .font(.system(size: 20))
                                         Text("PERÚ")
                                             .font(.system(size: 10, weight: .heavy))
                                             .tracking(1)
                                     }
                                     .foregroundColor(.orange)
                                 }
                                 .rotationEffect(.degrees(8))
                             }
                             .padding(.horizontal, 24)
        
            
                VStack(alignment: .leading, spacing: 20) {
 
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Título", systemImage: "")                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.orange)
 
                        TextField("", text: $titulo)
                            .padding(12)
                            .background(Color(uiColor: .tertiarySystemGroupedBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
 
                    VStack(alignment: .leading, spacing: 8) {
                        Label("Descripción", systemImage: "text.alignleft")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.orange)
 
                        ZStack(alignment: .topLeading) {
                            TextEditor(text: $descripcion)
                                .frame(minHeight: 110)
                                .padding(6)
                                .background(Color(uiColor: .tertiarySystemGroupedBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 14))
 
                            if descripcion.isEmpty {
                                Text("")
                                    .foregroundColor(Color(uiColor: .placeholderText))
                                    .padding(.leading, 16)
                                    .padding(.top, 14)
                                    .allowsHitTesting(false)
                            }
                        }
                    }
 
                    VStack(alignment: .leading, spacing: 10) {
                        Label("Fotos", systemImage: "photo.stack")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.orange)
 
                        HStack(spacing: 14) {
                            ForEach(0..<3, id: \.self) { index in
                                Button {
                                    slotSeleccionado = index
                                    mostrarImagePicker = true
                                } label: {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 16)
                                            .strokeBorder(style: StrokeStyle(lineWidth: 1.5, dash: [5, 4]))
                                            .foregroundColor(.orange.opacity(0.5))
                                            .background(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .fill(Color(uiColor: .tertiarySystemGroupedBackground))
                                            )
                                            .frame(width: 92, height: 92)
 
                                        if index < imagenes.count {
                                            Image(uiImage: imagenes[index])
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 92, height: 92)
                                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                        } else {
                                            VStack(spacing: 4) {
                                                Image(systemName: "camera.fill")
                                                    .font(.system(size: 22))
                                                Text("Foto \(index + 1)")
                                                    .font(.caption2)
                                            }
                                            .foregroundColor(.orange.opacity(0.8))
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(Color(uiColor: .secondarySystemGroupedBackground))
                )
                .padding(.horizontal, 24)
 
                Button {
                    guardarDestino()
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "paperplane.fill")
                        Text("Publicar")
                            .fontWeight(.bold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            colors: [Color.orange, Color(red: 0.85, green: 0.25, blue: 0.15)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(color: Color.orange.opacity(0.35), radius: 10, y: 6)
                }
                .padding(.horizontal, 24)
                .disabled(titulo.isEmpty || descripcion.isEmpty)
                .opacity(titulo.isEmpty || descripcion.isEmpty ? 0.6 : 1)
 
                Spacer(minLength: 20)
            }
            .padding(.top, 10)
            .padding(.bottom, 30)
        }
        .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
        .scrollDismissesKeyboard(.interactively)
        .sheet(isPresented: $mostrarImagePicker) {
                ImagePicker(
                    selectedImage: Binding(
                        get: { nil },
                        set: { nuevaImagen in
                            if let imagen = nuevaImagen {
                                // Reemplazar o agregar en el slot seleccionado
                                if slotSeleccionado < imagenes.count {
                                    imagenes[slotSeleccionado] = imagen
                                } else {
                                    imagenes.append(imagen)
                                }
                            }
                        }
                    ),
                    isPresented: $mostrarImagePicker
                )
            }
            .alert("Destino guardado correctamente.", isPresented: $mostrarExito) {
                Button("OK") {
                    dismiss()
                }
            }
            .alert("Error", isPresented: $mostrarError) {
                Button("OK") { }
            } message: {
                Text(mensajeError)
            }
    }
 
    func guardarDestino() {
        guard let user = Auth.auth().currentUser else { return }
 
        let autor = user.displayName ?? "Usuario"
        let correo = user.email ?? ""
 
     
        var nombresImagenes: [String] = []
        let destinoID = UUID().uuidString
 
        for (index, image) in imagenes.enumerated() {
            let nombre = DestinoImageManager.shared.guardarImagen(image, destinoID: destinoID, index: index)
            nombresImagenes.append(nombre)
        }
 
        DestinoFirestoreManager.shared.guardarDestino(
            titulo: titulo,
            descripcion: descripcion,
            autor: autor,
            correo: correo,
            imagenNombres: nombresImagenes
        ) { result in
            switch result {
            case .success:
                mostrarExito = true
            case .failure(let error):
                mensajeError = error.localizedDescription
                mostrarError = true
            }
        }
    }
}
 
#Preview {
    NavigationStack {
        CrearDestinoView()
    }
}

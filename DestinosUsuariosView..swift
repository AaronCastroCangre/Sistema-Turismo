//
//  DestinosUsuariosView..swift
//  PA3
//
//  Created by Alumno on 21/07/26.
//
import SwiftUI
import FirebaseFirestore
 
struct DestinosUsuariosView: View {
 
    @State private var destinos: [DestinoUsuario] = []
    @State private var irCrearDestino = false
    @State private var destinoSeleccionado: DestinoUsuario? = nil
    @State private var mostrarDetalle = false
 
    var body: some View {
 
        ScrollView {
 
                VStack(spacing: 16) {
 
                    StatusBarView()
 
                    if destinos.isEmpty {
 
                        VStack(spacing: 20) {
 
                            Image(systemName: "mappin.and.ellipse")
                                .font(.system(size: 70))
                                .foregroundColor(.gray)
 
                            Text("Aún no hay destinos")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.gray)
 
                            Text("Sé el primero en compartir un lugar turístico")
                                .foregroundColor(.gray.opacity(0.8))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }
                        .padding(.top, 100)
 
                    } else {
 
                        ForEach(destinos) { destino in
 
                            Button {
                                destinoSeleccionado = destino
                                mostrarDetalle = true
                            } label: {
 
                                HStack(alignment: .top, spacing: 15) {
 
                                    // Imagen principal
                                    if let primeraImagen = destino.imagenNombres.first,
                                       let uiImage = DestinoImageManager.shared.cargarImagen(nombreArchivo: primeraImagen) {
 
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipShape(RoundedRectangle(cornerRadius: 16))
                                            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                                    } else {
 
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(width: 100, height: 100)
                                            .overlay(
                                                Image(systemName: "photo")
                                                    .font(.system(size: 30))
                                                    .foregroundColor(.gray)
                                            )
                                    }
 
                                    VStack(alignment: .leading, spacing: 6) {
 
                                        Text(destino.titulo)
                                            .font(.system(size: 18, weight: .bold))
                                            .foregroundColor(.primary)
                                            .lineLimit(1)
 
                                        Text(destino.descripcion)
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                            .lineLimit(3)
                                            .multilineTextAlignment(.leading)
 
                                        HStack(spacing: 4) {
                                            Image(systemName: "person.circle.fill")
                                                .font(.system(size: 12))
                                                .foregroundColor(.orange)
 
                                            Text(destino.autor)
                                                .font(.system(size: 12))
                                                .foregroundColor(.orange)
                                        }
                                        .padding(.top, 4)
                                    }
 
                                    Spacer()
                                }
                                .padding(12)
                                .background(Color(.systemBackground))
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
                                .padding(.horizontal)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
 
                    Button {
                        irCrearDestino = true
                    } label: {
                        Label("Agregar Destino", systemImage: "plus.circle.fill")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            .padding(.horizontal, 25)
                            .padding(.top, 20)
                    }
 
                    Spacer(minLength: 40)
                }
                .padding(.vertical, 10)
            }
            .navigationTitle("Destinos de la Comunidad")
            .navigationDestination(isPresented: $irCrearDestino) {
                CrearDestinoView()
            }
            .navigationDestination(isPresented: $mostrarDetalle) {
                if let destino = destinoSeleccionado {
                    DetalleDestinoUsuarioView(destino: destino)
                }
            }
            .onAppear {
                cargarDestinos()
            }
    }
 
    func cargarDestinos() {
        DestinoFirestoreManager.shared.obtenerDestinos { result in
            switch result {
            case .success(let destinos):
                self.destinos = destinos
            case .failure(let error):
                print("Error cargando destinos: \(error.localizedDescription)")
            }
        }
    }
}
 
#Preview {
    DestinosUsuariosView()
}

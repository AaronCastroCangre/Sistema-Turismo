import SwiftUI

struct AgregarDestinoView: View {
    
    @EnvironmentObject var themeManager: ThemeManager
    
    @State private var mostrarFormulario = false
    @State private var modoEdicion = false

    @State private var departamento = ""
    @State private var region = ""
    @State private var lugar = ""
    @State private var experiencia = ""
    @State private var fecha = Date()

    @State private var destinos: [Destino] = {
        if let data = UserDefaults.standard.data(forKey: "destinos"),
           let decoded = try? JSONDecoder().decode([Destino].self, from: data) {
            return decoded
        }
        return []
    }()

    @State private var indiceEditar: Int?

    var body: some View {

        ScrollView {

            VStack(spacing: 20) {

                StatusBarView()

                Text("¿Cuál será tu próximo destino?")
                    .font(.title2)
                    .bold()

                Button {

                    limpiarFormulario()
                    modoEdicion = false
                    mostrarFormulario = true

                } label: {

                    HStack {

                        Image(systemName: "plus")

                        Text("Agregar Destino")
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .padding(.horizontal)
                }

                ForEach(destinos.indices, id: \.self) { index in

                    let destino = destinos[index]

                    VStack(alignment: .leading, spacing: 10) {

                        Text("Departamento: \(destino.departamento)")
                        Text("Región: \(destino.region)")
                        Text("Lugar turístico: \(destino.lugar)")
                        Text("Experiencia: \(destino.experiencia)")

                        HStack {

                            Button {

                                departamento = destino.departamento
                                region = destino.region
                                lugar = destino.lugar
                                experiencia = destino.experiencia
                                fecha = destino.fecha

                                indiceEditar = index
                                modoEdicion = true
                                mostrarFormulario = true

                            } label: {

                                Label("Editar", systemImage: "pencil")
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }

                            Button {

                                destinos.remove(at: index)
                                guardarDestinos()

                            } label: {

                                Label("Eliminar", systemImage: "trash")
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .frame(maxWidth: .infinity)
                                    .background(Color.red)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.horizontal)
                }
            }
        }
        .navigationTitle("Agregar Destinos")
        
        
        .toolbar {

            ToolbarItem(placement: .topBarLeading) {

                Button {

                    themeManager.toggleTheme()

                } label: {

                    Image(systemName: themeManager.isDarkMode ? "sun.max.fill" : "moon.fill")
                        .foregroundColor(themeManager.isDarkMode ? .yellow : .blue)
                }
            }
        }
        
        .sheet(isPresented: $mostrarFormulario) {

            FormularioDestinoView(
                departamento: $departamento,
                region: $region,
                lugar: $lugar,
                experiencia: $experiencia,
                fecha: $fecha,
                modoEdicion: modoEdicion
            ) {
                if modoEdicion, let idx = indiceEditar {
                    destinos[idx].departamento = departamento
                    destinos[idx].region = region
                    destinos[idx].lugar = lugar
                    destinos[idx].experiencia = experiencia
                    destinos[idx].fecha = fecha
                } else {
                    let nuevo = Destino(
                        departamento: departamento,
                        region: region,
                        lugar: lugar,
                        experiencia: experiencia,
                        fecha: fecha
                    )
                    destinos.append(nuevo)
                }
                guardarDestinos()
                mostrarFormulario = false
            }
        }
    }

    func limpiarFormulario() {
        departamento = ""
        region = ""
        lugar = ""
        experiencia = ""
        fecha = Date()
        indiceEditar = nil
    }

    func guardarDestinos() {
        if let data = try? JSONEncoder().encode(destinos) {
            UserDefaults.standard.set(data, forKey: "destinos")
        }
    }
}

struct FormularioDestinoView: View {

    @Binding var departamento: String
    @Binding var region: String
    @Binding var lugar: String
    @Binding var experiencia: String
    @Binding var fecha: Date

    let modoEdicion: Bool
    let onGuardar: () -> Void

    @Environment(\.dismiss) var dismiss

    var body: some View {

        NavigationStack {

            Form {

                Section("Información del destino") {

                    TextField("Departamento", text: $departamento)
                    TextField("Región", text: $region)
                    TextField("Lugar turístico", text: $lugar)
                    TextField("Experiencia", text: $experiencia)
                    DatePicker("Fecha", selection: $fecha, displayedComponents: .date)
                }
            }
            .navigationTitle(modoEdicion ? "Editar Destino" : "Nuevo Destino")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {

                ToolbarItem(placement: .confirmationAction) {

                    Button("Guardar") {
                        onGuardar()
                    }
                    .disabled(departamento.isEmpty || lugar.isEmpty)
                }

                ToolbarItem(placement: .cancellationAction) {

                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }
        }
    }
}

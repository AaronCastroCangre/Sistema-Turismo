import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct LugaresView: View {

    @EnvironmentObject var themeManager: ThemeManager

    let lugares = [

        Lugar(
            nombre: "Miraflores",
            descripcion: "Distrito moderno con vista al océano Pacífico.",
            imagen: "Miraflores",
            categoria: "Distritos",
            info: "Miraflores es uno de los distritos más modernos y turísticos de Lima.",
            mejoresLugares: [
                "Larcomar",
                "Parque Kennedy",
                "Costa Verde"
            ]
        ),

        Lugar(
            nombre: "Barranco",
            descripcion: "Zona bohemia llena de arte y cultura.",
            imagen: "Barranco",
            categoria: "Distritos",
            info: "Barranco es conocido por su arte urbano y vida nocturna.",
            mejoresLugares: [
                "Puente de los Suspiros",
                "Museo Pedro de Osma",
                "Malecón de Barranco"
            ]
        ),

        Lugar(
            nombre: "Centro de Lima",
            descripcion: "Centro histórico y cultural.",
            imagen: "Centrolima",
            categoria: "Historia",
            info: "El Centro Histórico de Lima es Patrimonio Cultural de la Humanidad.",
            mejoresLugares: [
                "Plaza Mayor",
                "Catedral de Lima",
                "Palacio de Gobierno"
            ]
        ),

        Lugar(
            nombre: "Larcomar",
            descripcion: "Centro comercial con vista al mar.",
            imagen: "Larcomar",
            categoria: "Turismo",
            info: "Larcomar ofrece entretenimiento, restaurantes y vistas panorámicas.",
            mejoresLugares: [
                "Mirador",
                "Restaurantes",
                "Tiendas"
            ]
        ),

        Lugar(
            nombre: "Parque Kennedy",
            descripcion: "Parque turístico de Miraflores.",
            imagen: "ParqueKennedy",
            categoria: "Parques",
            info: "Parque Kennedy es famoso por su ambiente cultural y turístico.",
            mejoresLugares: [
                "Ferias",
                "Cafeterías",
                "Eventos"
            ]
        )
    ]

    var body: some View {

        NavigationStack {

            List {

                ForEach(lugares) { lugar in

                    NavigationLink(destination: DetalleView(lugar: lugar)) {

                        VStack(alignment: .leading, spacing: 10) {

                            Text(lugar.nombre)
                                .font(.headline)

                            Image(lugar.imagen)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 180)
                                .frame(maxWidth: .infinity)
                                .clipped()
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .shadow(radius: 5)

                            Text(lugar.descripcion)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 10)
                    }
                }
            }
            .navigationTitle("Lugares Turísticos")
            .toolbar {

                ToolbarItem(placement: .topBarLeading) {

                    Button {
                        themeManager.toggleTheme()
                    } label: {
                        Image(systemName: themeManager.isDarkMode ? "sun.max.fill" : "moon.fill")
                    }
                }
            }
        }
    }
}



struct DetalleView: View {

    var lugar: Lugar

    @State private var mostrarClima = false
    @State private var mostrarMapa = false

    @AppStorage("esInvitado") var esInvitado = true
    @State private var mostrarAlerta = false

    // Estados para comentarios
    @State private var comentarios: [Comentario] = []
    @State private var textoComentario: String = ""
    @State private var estrellasSeleccionadas: Int = 0
    @State private var mostrarConfirmacionEliminar = false
    @State private var comentarioAEliminar: Comentario? = nil
    @State private var mensajeExito: String = ""
    @State private var mostrarExito = false

    let experiencias = [
        ("Tour Fotográfico", "Captura los mejores paisajes."),
        ("Experiencia Cultural", "Conoce la historia y cultura."),
        ("Ruta Gastronómica", "Prueba la comida típica."),
        ("Tour Histórico", "Descubre lugares emblemáticos."),
        ("Tour Urbano", "Explora calles y monumentos."),
    ]

    let destinosRecomendados = [
        (nombre: "Huaca Pucllana", imagen: "huaca", desc: "Antiguo centro ceremonial de la cultura Lima.", estrellas: 5),
        (nombre: "Catedral de Lima", imagen: "catedral", desc: "Principal templo religioso del Centro Histórico.", estrellas: 4),
        (nombre: "Parque Chino", imagen: "chino", desc: "Hermoso parque con arquitectura oriental y gran vista.", estrellas: 5),
        (nombre: "Circuito Mágico del Agua", imagen: "agua", desc: "Espectáculo de fuentes iluminadas reconocido mundialmente.", estrellas: 5),
        (nombre: "Catacumbas de San Francisco", imagen: "museo", desc: "Museo histórico con las famosas criptas de la época colonial.", estrellas: 4)
    ]

    var body: some View {

        ScrollView {

            VStack(spacing: 20) {

                StatusBarView()

                Text(lugar.nombre)
                    .font(.largeTitle)
                    .bold()

                Image(lugar.imagen)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 180)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 5)
                    .padding(.horizontal)

                Text(lugar.info)
                    .padding(.horizontal)

                VStack(alignment: .leading, spacing: 12) {

                    Text("Destinos Sugeridos")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)

                    VStack(spacing: 12) {
                        ForEach(destinosRecomendados, id: \.nombre) { destino in
                            HStack(alignment: .top, spacing: 15) {

                                Image(destino.imagen)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 85, height: 85)
                                    .clipShape(RoundedRectangle(cornerRadius: 15))
                                    .shadow(color: Color.black.opacity(0.1), radius: 3)

                                VStack(alignment: .leading, spacing: 4) {

                                    Text(destino.nombre)
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.primary)

                                    HStack(spacing: 2) {
                                        ForEach(0..<5, id: \.self) { index in
                                            Image(systemName: index < destino.estrellas ? "star.fill" : "star")
                                                .foregroundColor(.yellow)
                                                .font(.system(size: 11))
                                        }
                                    }
                                    .padding(.bottom, 2)

                                    Text(destino.desc)
                                        .font(.system(size: 12))
                                        .foregroundColor(.gray)
                                        .lineLimit(2)
                                }

                                Spacer()
                            }
                            .padding(10)
                            .background(Color(.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(color: Color.black.opacity(0.06), radius: 4, x: 0, y: 2)
                        }
                    }
                    .padding(.horizontal)
                }

                VStack(alignment: .leading, spacing: 12) {

                    Text("Experiencias")
                        .font(.title2)
                        .bold()

                    ForEach(experiencias, id: \.0) { item in

                        VStack(alignment: .leading, spacing: 6) {

                            Text(item.0)
                                .bold()

                            Text(item.1)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                    }
                }
                .padding()

                VStack(alignment: .leading, spacing: 10) {

                    Text("Mejores Lugares")
                        .font(.title2)
                        .bold()

                    ForEach(lugar.mejoresLugares, id: \.self) { sitio in

                        Text("• \(sitio)")
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.orange.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 20))

                VStack(alignment: .leading, spacing: 10) {

                    Text("Opiniones Internacionales")
                        .font(.title2)
                        .bold()

                    Text("• CNN Travel recomienda visitar Lima.")
                    Text("• National Geographic destaca Miraflores.")
                    Text("• Lonely Planet recomienda Barranco.")
                    Text("• Taste Atlas destaca la gastronomía peruana.")
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 20))

                Button {
                    if esInvitado {
                        mostrarAlerta = true
                    } else {
                        mostrarMapa = true
                    }
                } label: {
                    Label(
                        "Cómo Llegar",
                        systemImage: esInvitado ? "lock.fill" : "map.fill"
                    )
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                .padding(.horizontal)

                VStack(alignment: .leading, spacing: 16) {

                    Text("Comentarios")
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)

                  
                    if comentarios.isEmpty {
                        Text("Aún no hay comentarios.")
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                    } else {
                        ForEach(comentarios) { comentario in
                            VStack(alignment: .leading, spacing: 6) {

                                Text(comentario.nombre)
                                    .font(.headline)

                                HStack(spacing: 2) {
                                    ForEach(0..<5, id: \.self) { index in
                                        Image(systemName: index < Int(comentario.estrellas) ? "star.fill" : "star")
                                            .foregroundColor(.yellow)
                                            .font(.system(size: 14))
                                    }
                                }

                                Text(comentario.comentario)
                                    .font(.body)
                                    .foregroundColor(.primary)

                              
                                if let currentUser = Auth.auth().currentUser,
                                   comentario.userId == currentUser.uid {

                                    Button {
                                        comentarioAEliminar = comentario
                                        mostrarConfirmacionEliminar = true
                                    } label: {
                                        Text("Eliminar")
                                            .font(.caption)
                                            .foregroundColor(.red)
                                    }
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            .padding(.horizontal)
                        }
                    }

            
                    if !esInvitado {

                        VStack(spacing: 12) {

                        
                            ZStack(alignment: .topLeading) {
                                TextEditor(text: $textoComentario)
                                    .frame(minHeight: 80)
                                    .padding(8)
                                    .background(Color.gray.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))

                                if textoComentario.isEmpty {
                                    Text("Escribe un comentario...")
                                        .foregroundColor(.gray)
                                        .padding(.leading, 16)
                                        .padding(.top, 16)
                                        .allowsHitTesting(false)
                                }
                            }

                            HStack(spacing: 8) {
                                ForEach(1...5, id: \.self) { estrella in
                                    Image(systemName: estrella <= estrellasSeleccionadas ? "star.fill" : "star")
                                        .font(.system(size: 28))
                                        .foregroundColor(.yellow)
                                        .onTapGesture {
                                            estrellasSeleccionadas = estrella
                                        }
                                }
                            }

                            Button {
                                publicarComentario()
                            } label: {
                                Text("Publicar Comentario")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.orange)
                                    .clipShape(RoundedRectangle(cornerRadius: 18))
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical, 10)
            }
            .padding()
        }
        .navigationTitle(lugar.nombre)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    if esInvitado {
                        mostrarAlerta = true
                    } else {
                        mostrarClima = true
                    }
                } label: {
                    Image(systemName: esInvitado ? "lock.fill" : "cloud.sun.fill")
                        .foregroundColor(.orange)
                }
            }
        }
        .navigationDestination(isPresented: $mostrarClima) {
            ClimaView(
                ciudad: "Lima",
                lugar: lugar.nombre
            )
        }
        .navigationDestination(isPresented: $mostrarMapa) {
            MapaView(
                lugar: lugar.nombre
            )
        }
        .alert("Registrate", isPresented: $mostrarAlerta) {
            Button("OK") { }
        } message: {
            Text("Inicia sesion para ver el clima papito lendo :D")
        }
        .alert("¿Deseas eliminar este comentario?", isPresented: $mostrarConfirmacionEliminar) {
            Button("Cancelar", role: .cancel) { }
            Button("Eliminar", role: .destructive) {
                if let comentario = comentarioAEliminar {
                    eliminarComentario(comentario)
                }
            }
        }
        .alert(mensajeExito, isPresented: $mostrarExito) {
            Button("OK") { }
        }
        .onAppear {
            cargarComentarios()
        }
    }


    func cargarComentarios() {
        let db = Firestore.firestore()
        db.collection("comentarios")
            .whereField("lugar", isEqualTo: lugar.nombre)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error cargando comentarios: \(error.localizedDescription)")
                    return
                }

                guard let documents = snapshot?.documents else { return }

                self.comentarios = documents.compactMap { doc -> Comentario? in
                    let data = doc.data()
                    return Comentario(
                        id: doc.documentID,
                        nombre: data["nombre"] as? String ?? "",
                        comentario: data["comentario"] as? String ?? "",
                        estrellas: data["estrellas"] as? Double ?? 0.0,
                        lugar: data["lugar"] as? String ?? "",
                        userId: data["userId"] as? String ?? ""
                    )
                }
            }
    }

    func publicarComentario() {
        guard !textoComentario.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        guard estrellasSeleccionadas > 0 else { return }
        guard let user = Auth.auth().currentUser else { return }

        let db = Firestore.firestore()

        db.collection("comentarios").addDocument(data: [
            "nombre": user.displayName ?? "Usuario",
            "comentario": textoComentario,
            "estrellas": Double(estrellasSeleccionadas),
            "lugar": lugar.nombre,
            "userId": user.uid
        ]) { error in
            if let error = error {
                print("Error publicando comentario: \(error.localizedDescription)")
                return
            }

            DispatchQueue.main.async {
                textoComentario = ""
                estrellasSeleccionadas = 0
                mensajeExito = "Comentario publicado correctamente."
                mostrarExito = true
            }
        }
    }

    func eliminarComentario(_ comentario: Comentario) {
        let db = Firestore.firestore()
        db.collection("comentarios").document(comentario.id).delete { error in
            if let error = error {
                print("Error eliminando comentario: \(error.localizedDescription)")
                return
            }

            DispatchQueue.main.async {
                mensajeExito = "Comentario eliminado correctamente."
                mostrarExito = true
            }
        }
    }
}

#Preview {
    LugaresView()
        .environmentObject(ThemeManager())
}

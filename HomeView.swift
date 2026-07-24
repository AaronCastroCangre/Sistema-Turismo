import SwiftUI
import AVKit
import FirebaseAuth

struct HomeView: View {

    @State private var irLugares = false
    @State private var irInfo = false
    @State private var irComida = false
    @State private var irAgregarDestino = false
    @State private var irPerfil = false
    @State private var irDestinosComunidad = false
    @EnvironmentObject var sesionUsuario: SesionUsuario
    @State private var mostrarCerrarSesion = false
    @AppStorage("esInvitado") var esInvitado = true
    @AppStorage("sesionIniciada") var sesionIniciada = false
    @State private var mostrarAlerta = false
    @Environment(\.dismiss) var dismiss

    var body: some View {

        VStack(spacing: 20) {

                StatusBarView()
                    .foregroundColor(.white)

                if !esInvitado {

                    HStack(alignment: .top) {

                        Text("Hola")
                            .bold()
                            .foregroundColor(.white)
                            .font(.system(size: 19))

                        Text(sesionUsuario.nombre)
                            .bold()
                            .foregroundColor(.green)
                            .font(.system(size: 19))

                        Text(",a donde vamos?")
                            .bold()
                            .foregroundColor(.white)
                            .font(.system(size: 19))

                        Spacer()

                        // Botón de perfil: alineado con el texto, más grande, más arriba
                        Button {
                            irPerfil = true
                        } label: {
                            Image(systemName: "person.crop.circle.fill")
                                .font(.system(size: 32))
                                .foregroundColor(.white)
                        }
                        .padding(.top, -8)
                    }
                    .padding(.horizontal)
                    .padding(.top, 5)

                    // Botón de cerrar sesión: debajo del perfil, separado, alineado a la derecha
                    HStack {
                        Spacer()

                        Button {
                            mostrarCerrarSesion = true
                        } label: {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                }

                Image(systemName: "airplane.circle.fill")
                    .font(.system(size: 70))
                    .foregroundColor(.white)

                Text("Sistema Turístico")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)

                Text("Descubre Lima")
                    .foregroundColor(.white)

                Text("Destinos turísticos, cultura y gastronomía de Lima.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.horizontal, 30)

                VStack(spacing: 12) {

                    Button {
                        irLugares = true
                    } label: {
                        Label("Ver Lugares", systemImage: "map")
                            .frame(width: 220)
                            .padding(10)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                    }

                    // NUEVO: Botón Destinos de la Comunidad
                    Button {
                        if esInvitado {
                            mostrarAlerta = true
                        } else {
                            irDestinosComunidad = true
                        }
                    } label: {
                        Label(
                            "Un Recuerdo? :3",
                            systemImage: esInvitado ? "lock.fill" : "person.3.fill"
                        )
                        .frame(width: 220)
                        .padding(10)
                        .background(Color.purple)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                    }

                    Button {
                        irInfo = true
                    } label: {
                        Label("Información", systemImage: "info.circle")
                            .frame(width: 220)
                            .padding(10)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                    }

                    Button {
                        irComida = true
                    } label: {
                        Label("Destinos Culinarios", systemImage: "fork.knife")
                            .frame(width: 220)
                            .padding(10)
                            .background(Color.red)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                    }

                    Button {
                        if esInvitado {
                            mostrarAlerta = true
                        } else {
                            irAgregarDestino = true
                        }
                    } label: {
                        Label(
                            "Agregar Destinos",
                            systemImage: esInvitado ? "lock.fill" : "plus.circle.fill"
                        )
                        .frame(width: 220)
                        .padding(10)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                }

                Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            ZStack {
                Image("lima")
                    .resizable()
                    .scaledToFill()

                Color.black.opacity(0.4)
            }
            .ignoresSafeArea()
        )
        .navigationDestination(isPresented: $irLugares) {
            LugaresView()
        }
        .navigationDestination(isPresented: $irDestinosComunidad) {
            DestinosUsuariosView()
        }
        .navigationDestination(isPresented: $irInfo) {
            InfoView()
        }
        .navigationDestination(isPresented: $irComida) {
            ComidaView()
        }
        .navigationDestination(isPresented: $irAgregarDestino) {
            AgregarDestinoView()
        }
        .navigationDestination(isPresented: $irPerfil) {
            PerfilView()
        }
        .toolbar {
            // Botón para volver al Login cuando es invitado o cerró sesión
            if esInvitado || !sesionIniciada {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: "chevron.left")
                            Text("")
                        }
                        .foregroundColor(.white)
                    }
                }
            }
        }
        .alert("Registrate", isPresented: $mostrarAlerta) {
            Button("OK") { }
        } message: {
            Text("Registrate para tener una mejor experiencia :D")
        }
        .alert("Cerrar sesión", isPresented: $mostrarCerrarSesion) {
            Button("Cancelar", role: .cancel) { }
            Button("Cerrar sesión", role: .destructive) {
                do {
                    try Auth.auth().signOut()
                    sesionIniciada = false
                    esInvitado = true
                    sesionUsuario.nombre = ""
                } catch {
                    print(error.localizedDescription)
                }
            }
        } message: {
            Text("¿Estás seguro que deseas cerrar sesión?")
        }
    }
}

struct InfoView: View {

    var body: some View {

        ScrollView {

            VStack(spacing: 20) {

                StatusBarView()

                Text("Sistema Turístico de Lima")
                    .font(.title)
                    .bold()

                Text("Lima es la capital del Perú y uno de los destinos más importantes de Sudamérica.")

                Text("Puedes visitar lugares como Miraflores, Barranco y el Centro Histórico.")

                Text("Entre sus platos más famosos están el ceviche, lomo saltado y la causa limeña.")

                Text("Mira nuestro video para conocer mas sobre Peru")
                    .font(.title)


                VideoPlayer(
                    player: AVPlayer(
                        url: Bundle.main.url(
                            forResource: "video4",
                            withExtension: "mp4"
                        )!
                    )
                )
                .frame(height: 250)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 5)
            }
            .padding()
        }
        .navigationTitle("Información")
    }
}

struct ComidaView: View {

    var body: some View {

        ScrollView {

            VStack(spacing: 20) {

                StatusBarView()

                Text("Destinos Culinarios")
                    .font(.largeTitle)
                    .bold()

                Text("La gastronomía peruana es considerada una de las mejores del mundo gracias a su variedad, sabor y creatividad culinaria.")
                    .multilineTextAlignment(.center)

                Text("Perú logró posicionarse entre los primeros lugares del ranking mundial de Taste Atlas y posee restaurantes reconocidos internacionalmente.")
                    .multilineTextAlignment(.center)

                VStack(alignment: .leading, spacing: 10) {

                    Text("Logros Internacionales")
                        .font(.title2)
                        .bold()

                    Text("• Perú entre los Top 3 países gastronómicos del mundo")
                    Text("• Lima reconocida como capital gastronómica de América")
                    Text("• Restaurantes peruanos entre los mejores del planeta")
                }
                .padding()
                .background(Color.red.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 20))

                VStack(alignment: .leading, spacing: 10) {

                    Text("Mejores Platos")
                        .font(.title2)
                        .bold()

                    Text("• Ceviche")
                    Text("• Lomo Saltado")
                    Text("• Ají de Gallina")
                    Text("• Causa Limeña")
                    Text("• Anticuchos")
                }
                .padding()
                .background(Color.orange.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 20))

                Image("comida")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)
                    .clipShape(RoundedRectangle(cornerRadius: 30))
                    .shadow(radius: 5)
            }
            .padding()
        }
        .navigationTitle("Gastronomía")
    }
}

#Preview {
    HomeView()
        .environmentObject(SesionUsuario())
}

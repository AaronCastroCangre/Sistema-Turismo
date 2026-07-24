import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct NavBarContentView: View {

    var body: some View {

        NavigationStack {
            LoginView()
        }
    }
}

struct LoginView: View {

    @State private var correo: String = ""
    @State private var clave: String = ""
    @State private var navegar: Bool = false
    @State private var currentIndex = 0
    @State private var irRegistro = false

    @AppStorage("esInvitado") var esInvitado = true
    @AppStorage("sesionIniciada") var sesionIniciada = false
    @EnvironmentObject var sesionUsuario: SesionUsuario

    let videos = ["video1", "video2"]

    func iniciarSesion() {

        Auth.auth().signIn(withEmail: correo, password: clave) { result, error in

            if let error = error {

                print(error.localizedDescription)
                return
            }

            guard let uid = result?.user.uid else { return }

            let db = Firestore.firestore()

            db.collection("usuarios").document(uid).getDocument { document, error in

                if let error = error {

                    print(error.localizedDescription)
                    return
                }

                if let data = document?.data() {

                    sesionUsuario.nombre = data["nombre"] as? String ?? ""

                    
                    if let nombre = data["nombre"] as? String, !nombre.isEmpty {
                        let changeRequest = result?.user.createProfileChangeRequest()
                        changeRequest?.displayName = nombre
                        changeRequest?.commitChanges { _ in }
                    }
                }

                esInvitado = false
                sesionIniciada = true
                navegar = true
            }
        }
    }

    func continuarComoInvitado() {
        esInvitado = true
        sesionIniciada = true
        navegar = true
    }

    var body: some View{
    ZStack {

            VideoFondoView(videoNames: videos, currentIndex: $currentIndex)
                .ignoresSafeArea()

            LinearGradient(
                colors: [
                    Color.black.opacity(0.7),
                    Color.black.opacity(0.3),
                    Color.black.opacity(0.7)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {

                StatusBarView()
                    .foregroundColor(.white)

                Spacer()

                VStack(spacing: 15) {

                    Image(systemName: "airplane.circle.fill")
                        .font(.system(size: 90))
                        .foregroundColor(.white)

                    Text("Sistema Turístico")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)

                    Text("Descubre Lima")
                        .foregroundColor(.white.opacity(0.9))

                    Text("Explora destinos turísticos, gastronomía y experiencias únicas.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.horizontal, 30)
                }

                VStack(spacing: 15) {

                    TextField("Ingrese correo", text: $correo)
                        .padding()
                        .background(Color.white.opacity(0.95))
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .padding(.horizontal, 25)

                    SecureField("Ingrese clave", text: $clave)
                        .padding()
                        .background(Color.white.opacity(0.95))
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .padding(.horizontal, 25)

                    Button {
                        iniciarSesion()
                    } label: {
                        Text("Ingresar")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            .padding(.horizontal, 25)
                    }

                    Button {
                        irRegistro = true
                    } label: {
                        Text("Registrarme")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                            .padding(.horizontal, 25)
                    }

                    Button {
                        continuarComoInvitado()
                    } label: {
                        Text("Continuar como invitado")
                            .frame(width: 220)
                            .padding(10)
                            .background(Color.white)
                            .foregroundColor(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                }

                Spacer()

                HStack(spacing: 8) {

                    ForEach(0..<videos.count, id: \.self) { index in

                        Circle()
                            .fill(currentIndex == index ? Color.white : Color.white.opacity(0.4))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.bottom, 30)
            }
        }
        .navigationDestination(isPresented: $navegar) {
            HomeView()
                .navigationBarBackButtonHidden(true)
        }
        .navigationDestination(isPresented: $irRegistro) {
            RegistroView()
        }
        .onAppear {
            correo = ""
            clave = ""
        }
    }
}

import  SwiftUI

struct ContentView: View {

    @StateObject private var themeManager = ThemeManager()

    var body: some View {

        NavigationStack {

            LoginView()

        }
        .environmentObject(themeManager)
        .preferredColorScheme(themeManager.isDarkMode ? .dark : .light)
    }
}

#Preview {
    ContentView()
        .environmentObject(SesionUsuario())
}

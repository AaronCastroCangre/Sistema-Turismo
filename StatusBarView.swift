import SwiftUI

struct StatusBarView: View {

    var body: some View {

        HStack {

            Text("")
                .font(.system(size: 14, weight: .bold))

            Spacer()

            HStack(spacing: 6) {

                Image(systemName: "")

                Image(systemName: "")
            }
            .font(.system(size: 14))
        }
        .padding(.horizontal)
        .padding(.top, 5)
    }
}

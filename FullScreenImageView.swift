//
//  FullScreenImageView.swift
//  PA3
//
//  Vista genérica para mostrar una foto en pantalla completa,
//  con zoom (pellizcar), doble tap para acercar/alejar,
//  arrastre y botón para cerrar.
//
import SwiftUI

struct FullScreenImageView: View {

    let image: UIImage

    @Environment(\.dismiss) var dismiss

    @State private var scale: CGFloat = 1.0
    @State private var lastScale: CGFloat = 1.0

    @State private var offset: CGSize = .zero
    @State private var lastOffset: CGSize = .zero

    var body: some View {

        ZStack {

            Color.black
                .ignoresSafeArea()

            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .scaleEffect(scale)
                .offset(offset)
                .gesture(
                    MagnificationGesture()
                        .onChanged { valor in
                            scale = lastScale * valor
                        }
                        .onEnded { _ in
                            if scale < 1 {
                                withAnimation {
                                    scale = 1
                                    offset = .zero
                                }
                                lastScale = 1
                                lastOffset = .zero
                            } else {
                                lastScale = scale
                            }
                        }
                )
                .simultaneousGesture(
                    DragGesture()
                        .onChanged { valor in
                            guard scale > 1 else { return }
                            offset = CGSize(
                                width: lastOffset.width + valor.translation.width,
                                height: lastOffset.height + valor.translation.height
                            )
                        }
                        .onEnded { _ in
                            lastOffset = offset
                        }
                )
                .onTapGesture(count: 2) {
                    withAnimation {
                        if scale > 1 {
                            scale = 1
                            lastScale = 1
                            offset = .zero
                            lastOffset = .zero
                        } else {
                            scale = 2.5
                            lastScale = 2.5
                        }
                    }
                }

            VStack {

                HStack {

                    Spacer()

                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 30))
                            .foregroundColor(.white.opacity(0.9))
                            .padding()
                    }
                }

                Spacer()
            }
        }
        .statusBarHidden(true)
    }
}

#Preview {
    FullScreenImageView(image: UIImage(systemName: "photo")!)
}

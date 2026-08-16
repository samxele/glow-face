import SwiftUI

struct GlowFaceView: View {
    @Environment(\.isLuminanceReduced) private var isLuminanceReduced
    @Environment(\.colorScheme) private var colorScheme
    @State private var eyesClosed = false

    private let featureColor = Color(
        red: 52 / 255,
        green: 76 / 255,
        blue: 23 / 255
    )

    var body: some View {
        GeometryReader { geometry in
            let layout = FaceLayout(size: geometry.size)

            ZStack {
                (colorScheme == .dark ? Color.black : Color.white)
                    .brightness(isLuminanceReduced ? -0.14 : 0)

                ZStack {
                    Image("ApprovedFace")
                        .resizable()
                        .scaledToFill()
                        .opacity(eyesClosed ? 0 : 1)

                    Image("ApprovedFaceClosed")
                        .resizable()
                        .scaledToFill()
                        .opacity(eyesClosed ? 1 : 0)
                }
                    .frame(
                        width: layout.headSize.width,
                        height: layout.headSize.height
                    )
                    .clipShape(Ellipse())
                    .position(x: geometry.size.width / 2, y: layout.headY)
                    .saturation(isLuminanceReduced ? 0.72 : 1)
                    .brightness(isLuminanceReduced ? -0.16 : 0)
                    .shadow(
                        color: featureColor.opacity(isLuminanceReduced ? 0.08 : 0.22),
                        radius: 15
                    )
                    .animation(.easeInOut(duration: 0.08), value: eyesClosed)

                TimelineView(
                    .periodic(
                        from: .now,
                        by: isLuminanceReduced ? 60 : 1
                    )
                ) { timeline in
                    Text(timeline.date, format: .dateTime.hour().minute())
                        .font(.system(
                            size: min(geometry.size.width, geometry.size.height) * 0.105,
                            weight: .semibold,
                            design: .rounded
                        ))
                        .monospacedDigit()
                        .foregroundStyle(
                            (colorScheme == .dark ? Color.white : featureColor)
                                .opacity(isLuminanceReduced ? 0.62 : 0.88)
                        )
                        .accessibilityLabel(
                            timeline.date.formatted(date: .omitted, time: .shortened)
                        )
                        .frame(maxHeight: .infinity, alignment: .top)
                        .padding(.top, layout.timeTopPadding)
                }

            }
            .ignoresSafeArea()
            .accessibilityElement(children: .contain)
            .accessibilityLabel("Glow Face")
            .task(id: isLuminanceReduced) {
                eyesClosed = false
                guard !isLuminanceReduced else { return }

                while !Task.isCancelled {
                    let delay = UInt64.random(in: 8_000_000_000...20_000_000_000)
                    try? await Task.sleep(nanoseconds: delay)
                    guard !Task.isCancelled else { return }

                    eyesClosed = true
                    try? await Task.sleep(nanoseconds: 160_000_000)
                    eyesClosed = false
                }
            }
        }
    }
}

struct GlowFaceView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GlowFaceView()
                .frame(width: 198, height: 242)
                .previewDisplayName("45 mm")
                .preferredColorScheme(.dark)

            GlowFaceView()
                .frame(width: 176, height: 215)
                .previewDisplayName("41 mm")
                .preferredColorScheme(.light)
        }
    }
}

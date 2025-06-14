import SwiftUI

extension View {
    func resortsProgressBar(_ value: Double) -> some View {
        modifier(ResortsProgressModifier(progress: value))
    }
}

struct ResortsProgressModifier: ViewModifier {
    let progress: Double

    func body(content: Content) -> some View {
        content
            .overlay(
                ResortsProgressOverlay(progress: progress)
            )
    }
}

struct ResortsProgressOverlay: View {
    let progress: Double

    var body: some View {
        VStack(spacing: 24) {
            Image("title")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 260)
                .shadow(color: .green.opacity(0.5), radius: 16, x: 0, y: 8)
            Text("Raising the Dead...")
                .font(.custom("Chalkduster", size: 28))
                .foregroundColor(Color.green.opacity(0.95))
                .shadow(color: .green, radius: 8, x: 0, y: 2)
            ResortsZombieProgressBar(progress: progress)
                .frame(height: 18)
                .frame(maxWidth: 260)
            Text("\(Int(progress * 100))%")
                .font(.system(size: 22, weight: .bold, design: .rounded))
                .foregroundColor(Color.green.opacity(0.92))
                .shadow(color: .green, radius: 6, x: 0, y: 2)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.07, green: 0.18, blue: 0.07), Color(red: 0.13, green: 0.32, blue: 0.13)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
    }
}

struct ResortsZombieProgressBar: View {
    let progress: Double
    @State private var animateBubbles = false

    var body: some View {
        ZStack(alignment: .leading) {
            Capsule()
                .fill(Color.white.opacity(0.10))
            Capsule()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.green.opacity(0.95), Color.green.opacity(0.7), Color.green.opacity(0.95)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .shadow(color: .green, radius: 12, x: 0, y: 0)
                .frame(width: nil)
                .mask(
                    GeometryReader { geo in
                        Rectangle()
                            .frame(width: max(0, CGFloat(min(max(progress, 0), 1)) * geo.size.width), height: geo.size.height)
                    }
                )
                .animation(.easeOut(duration: 0.3), value: progress)
            // Bubbles строго внутри бара
            GeometryReader { geo in
                ForEach(0..<6) { i in
                    let bubbleSize = CGFloat(10 + i * 4)
                    let barWidth = CGFloat(min(max(progress, 0), 1)) * geo.size.width
                    Circle()
                        .fill(Color.green.opacity(0.22 + Double(i) * 0.08))
                        .frame(width: bubbleSize, height: bubbleSize)
                        .offset(x: min(barWidth - bubbleSize, max(0, barWidth * CGFloat(Double(i + 1) / 7.0))),
                                y: CGFloat.random(in: -4...4))
                        .opacity(animateBubbles ? 1 : 0.7)
                        .animation(
                            Animation.easeInOut(duration: 1.2).repeatForever().delay(Double(i) * 0.18),
                            value: animateBubbles
                        )
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 18)
        .cornerRadius(9)
        .onAppear {
            animateBubbles = true
        }
    }
}

#Preview {
    Color.black.resortsProgressBar(0.42)
}

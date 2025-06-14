import Foundation
import SwiftUI

class ResortsColor: UIColor {
    convenience init(rgb: String) {
        let clean = rgb.trimmingCharacters(in: .alphanumerics.inverted)
        var value: UInt64 = 0
        Scanner(string: clean).scanHexInt64(&value)
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: 1.0
        )
    }
}

struct ResortsWebFactory {
    static func makeEntryView() -> some View {
        ResortsWebEntryPoint()
    }

    static func makeURL() -> URL {
        URL(string: "https://resortworld.run/get")!
    }

    static func makeScreen(url: URL) -> some View {
        ResortsWebScreen(observable: .init(destination: url))
            .background(Color(ResortsColor(rgb: "#000000")))
    }
}

struct ResortsWebEntryPoint: View {
    var body: some View {
        ResortsWebFactory.makeScreen(url: ResortsWebFactory.makeURL())
    }
}

#Preview {
    ResortsWebFactory.makeEntryView()
}

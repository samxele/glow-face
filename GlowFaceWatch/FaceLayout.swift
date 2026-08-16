import CoreGraphics

struct FaceLayout {
    let size: CGSize

    private var shortestSide: CGFloat {
        min(size.width, size.height)
    }

    var headSize: CGSize {
        CGSize(
            width: shortestSide * 0.76,
            height: shortestSide * 0.70
        )
    }

    var headY: CGFloat {
        size.height * 0.48
    }

    var timeTopPadding: CGFloat {
        max(8, size.height * 0.065)
    }
}

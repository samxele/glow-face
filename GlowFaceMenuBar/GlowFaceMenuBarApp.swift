import AppKit
import SwiftUI

@main
struct GlowFaceMenuBarApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

@MainActor
private final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem?
    private var popover: NSPopover?
    private var blinkTask: Task<Void, Never>?

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApplication.shared.setActivationPolicy(.accessory)

        let statusItem = NSStatusBar.system.statusItem(
            withLength: NSStatusItem.squareLength
        )
        guard let button = statusItem.button else {
            fatalError("Unable to create the Glow Face menu-bar button")
        }

        button.image = FaceArtwork.statusImage(
            named: "ApprovedFace",
            extension: "jpg"
        )
        button.imagePosition = .imageOnly
        button.toolTip = "Glow Face"
        button.target = self
        button.action = #selector(togglePopover)
        self.statusItem = statusItem

        let popover = NSPopover()
        popover.behavior = .transient
        popover.contentSize = NSSize(width: 230, height: 265)
        popover.contentViewController = NSHostingController(rootView: GlowFaceMenu())
        self.popover = popover

        startBlinking(button: button)
    }

    func applicationWillTerminate(_ notification: Notification) {
        blinkTask?.cancel()
    }

    @objc
    private func togglePopover() {
        guard
            let button = statusItem?.button,
            let popover
        else {
            return
        }

        if popover.isShown {
            popover.performClose(nil)
        } else {
            popover.show(
                relativeTo: button.bounds,
                of: button,
                preferredEdge: .minY
            )
        }
    }

    private func startBlinking(button: NSStatusBarButton) {
        blinkTask = Task { [weak button] in
            while !Task.isCancelled {
                let delay = UInt64.random(in: 8_000_000_000...20_000_000_000)
                try? await Task.sleep(nanoseconds: delay)
                guard !Task.isCancelled, let button else { return }

                button.image = FaceArtwork.statusImage(
                    named: "ApprovedFaceClosed",
                    extension: "png"
                )
                try? await Task.sleep(nanoseconds: 160_000_000)
                button.image = FaceArtwork.statusImage(
                    named: "ApprovedFace",
                    extension: "jpg"
                )
            }
        }
    }
}

private struct GlowFaceMenu: View {
    var body: some View {
        VStack(spacing: 14) {
            BlinkingFace()
                .frame(width: 172, height: 160)
                .shadow(color: FacePalette.featureColor.opacity(0.22), radius: 15)
                .accessibilityHidden(true)

            Divider()

            Button("Quit Glow Face") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q")
        }
        .padding(18)
        .frame(width: 230)
    }
}

private struct BlinkingFace: View {
    @State private var eyesClosed = false

    var body: some View {
        ZStack {
            FaceArtwork.image(named: "ApprovedFace", extension: "jpg")
                .opacity(eyesClosed ? 0 : 1)

            FaceArtwork.image(named: "ApprovedFaceClosed", extension: "png")
                .opacity(eyesClosed ? 1 : 0)
        }
        .scaledToFill()
        .clipShape(Ellipse())
        .animation(.easeInOut(duration: 0.08), value: eyesClosed)
        .task {
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

private enum FaceArtwork {
    static func statusImage(named name: String, extension fileExtension: String) -> NSImage {
        let source = nsImage(named: name, extension: fileExtension)
        let imageSize = NSSize(width: 20, height: 18)
        let faceRect = NSRect(x: 1, y: 0, width: 18, height: 18)
        let image = NSImage(size: imageSize)
        image.lockFocus()
        NSBezierPath(ovalIn: faceRect).addClip()
        source.draw(
            in: faceRect,
            from: .zero,
            operation: .copy,
            fraction: 1
        )
        image.unlockFocus()
        image.isTemplate = false
        return image
    }

    static func image(named name: String, extension fileExtension: String) -> Image {
        Image(nsImage: nsImage(named: name, extension: fileExtension))
            .resizable()
    }

    private static func nsImage(
        named name: String,
        extension fileExtension: String
    ) -> NSImage {
        guard
            let url = Bundle.module.url(forResource: name, withExtension: fileExtension),
            let image = NSImage(contentsOf: url)
        else {
            fatalError("Missing bundled face artwork: \(name).\(fileExtension)")
        }

        return image
    }
}

private enum FacePalette {
    static let featureColor = Color(
        red: 52 / 255,
        green: 76 / 255,
        blue: 23 / 255
    )
}

//
//  VisualEffectView.swift
//  Fruta macOS
//

import SwiftUI

struct VisualEffectBlur<Content: View>: View {
    var material: NSVisualEffectView.Material
    var content: Content
    
    init(material: NSVisualEffectView.Material = .headerView, allowsVibrancy: Bool = false, @ViewBuilder content: () -> Content) {
        self.material = material
        self.content = content()
    }
    
    var body: some View {
        Representable(material: material, content: ZStack { content })
    }
}

extension VisualEffectBlur {
    
    struct Representable<Content: View>: NSViewRepresentable {
        var material: NSVisualEffectView.Material
        var content: Content
        
        func makeNSView(context: Context) -> NSVisualEffectView {
            context.coordinator.visualEffectView
        }
        
        func updateNSView(_ view: NSVisualEffectView, context: Context) {
            context.coordinator.update(content: content, material: material)
        }
        
        func makeCoordinator() -> Coordinator {
            Coordinator(content: content)
        }
        
        class Coordinator {
            let visualEffectView = NSVisualEffectView()
            let hostingController: NSHostingController<Content>
            
            init(content: Content) {
                hostingController = NSHostingController(rootView: content)
                hostingController.view.autoresizingMask = [.width, .height]
                visualEffectView.blendingMode = .withinWindow
                visualEffectView.addSubview(hostingController.view)
            }
            
            func update(content: Content, material: NSVisualEffectView.Material) {
                hostingController.rootView = content
                visualEffectView.material = material
            }
        }
    }
}

extension VisualEffectBlur where Content == EmptyView {
    init(material: NSVisualEffectView.Material = .headerView) {
        self.init(material: material) {
            EmptyView()
        }
    }
}

struct VisualEffectView_Previews: PreviewProvider {
    static var previews: some View {
        Text("Hello World!")
            .frame(width: 200, height: 100)
            .background(
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [.red, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    
                    VisualEffectBlur()
                }
                .edgesIgnoringSafeArea(.all)
            )
            .previewLayout(.sizeThatFits)
    }
}

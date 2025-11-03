//
//  LegacyPopover.swift
//  EmojiPicker
//
//  Created by yueyuemax on 2025/11/3.
//

#if canImport(UIKit)
import SwiftUI
import UIKit

public struct LegacyPopover<PopoverContent: View>: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    let popoverContent: PopoverContent
    let onDismiss: (() -> Void)?

    public init(
        isPresented: Binding<Bool>,
        popoverContent: PopoverContent,
        onDismiss: (() -> Void)? = nil
    ) {
        self._isPresented = isPresented // 绑定赋值要用 _
        self.popoverContent = popoverContent
        self.onDismiss = onDismiss
    }

    @State var isBeingPresented = false

    public func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self, content: popoverContent)
    }

    public func makeUIViewController(context: Context) -> UIViewController {
        return UIViewController()
    }

    public func updateUIViewController(_ uiViewController: UIViewController,
                                       context: Context)
    {
        let host = context.coordinator.host
        if isPresented {
            host.rootView = popoverContent
            host.preferredContentSize = host.sizeThatFits(in: CGSize(width: Int.max, height: Int.max))

            // 必须加入判断   (!host.isBeingPresented 自身状态有时候不准确)
            // 否则会导致出现 Attempt to present xxx which is already presenting
            // 然后就会导致其他地方的弹窗无法正常工作
            if uiViewController.presentedViewController == nil, !isBeingPresented {
                host.modalPresentationStyle = UIModalPresentationStyle.popover
                host.popoverPresentationController?.delegate = context.coordinator
                host.popoverPresentationController?.sourceView = uiViewController.view
                host.popoverPresentationController?.sourceRect = uiViewController.view.bounds
                uiViewController.present(host, animated: true, completion: nil)
                DispatchQueue.main.async {
                    isBeingPresented = true
                }
            }
        } else {
            if isBeingPresented {
                guard !host.isBeingDismissed else { return }
                host.dismiss(animated: true, completion: nil)
                DispatchQueue.main.async {
                    isBeingPresented = false
                }
            }
        }
    }

    public class Coordinator: NSObject, UIPopoverPresentationControllerDelegate {
        private let parent: LegacyPopover
        var host: UIHostingController<PopoverContent>

        init(parent: LegacyPopover, content: PopoverContent) {
            self.parent = parent
            self.host = UIHostingController(rootView: content)
        }

        public func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
            parent.isPresented = false
            parent.isBeingPresented = false
            if let onDismiss = parent.onDismiss {
                onDismiss()
            }
        }

        public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
            return .none // this is what forces popovers on iPhone
        }
    }
}
#endif

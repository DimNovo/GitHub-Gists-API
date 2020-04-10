//
//  Safari+Service.swift
//  GitHub Gists API
//
//  Created by Dmitry Novosyolov on 09/04/2020.
//  Copyright © 2020 Dmitry Novosyolov. All rights reserved.
//

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    var url: URL
    @Environment(\.presentationMode) var presentationMode
    
    func makeCoordinator() -> Coordinator { Coordinator(url: url, presentationMode: presentationMode)}
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        let controller = SFSafariViewController(url: url)
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
    
    final class Coordinator: NSObject, SFSafariViewControllerDelegate {
        
        var url: URL
        @Binding var presentationMode: PresentationMode
        
        init(url: URL, presentationMode: Binding<PresentationMode>) {
            self.url = url
            _presentationMode = presentationMode
        }
        
        func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
            presentationMode.dismiss()
        }
    }
}

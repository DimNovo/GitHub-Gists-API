//
//  SearchView.swift
//  GitHub Gists API
//
//  Created by Dmitry Novosyolov on 09/04/2020.
//  Copyright © 2020 Dmitry Novosyolov. All rights reserved.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var gistVM: GistViewModel
    var body: some View {
        HStack {
            TextField("search", text: $gistVM.searchText)
                .keyboardType(.default)
            HStack {
                Button(action: { self.gistVM.searchText = "" },
                       label: { Image(systemName: "xmark")
                        .foregroundColor(.primary)
                        .padding(.horizontal, 5)
                })
            }
            .font(.system(size: 25, weight: .thin, design: .default))
            .accentColor(.accentColor)
        }
        .padding(8)
        .overlay(Capsule().stroke(Color.secondary, lineWidth: 1))
        .padding(.horizontal, 7)
        
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView(gistVM: GistViewModel())
    }
}

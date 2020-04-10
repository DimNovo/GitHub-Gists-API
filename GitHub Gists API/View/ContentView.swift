//
//  ContentView.swift
//  GitHub Gists API
//
//  Created by Dmitry Novosyolov on 09/04/2020.
//  Copyright © 2020 Dmitry Novosyolov. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var gistVM = GistViewModel()
    var body: some View {
        NavigationView {
            VStack {
                SearchView(gistVM: gistVM)
                List {
                    ForEach(gistVM.gists) { gist in
                        NavigationLink(destination: SafariView(url: URL(string: gist.htmlURL)!)
                            .navigationBarTitle("")
                            .navigationBarHidden(true)
                            .edgesIgnoringSafeArea(.bottom)) {
                                VStack(alignment: .leading) {
                                    HStack(spacing: 10) {
                                        AvatarView(gistVM: self.gistVM, gist: gist)
                                        GistDescription(gist: gist)
                                    }
                                    Spacer()
                                    FooterView(gist: gist)
                                }
                                .font(.system(size: 12, weight: .light, design: .rounded))
                        }
                    }
                }
            }.navigationBarTitle("Gists: \(gistVM.gists.count == 0 ? "" : "\(gistVM.gists.count)")")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .colorScheme(.dark)
    }
}

struct GistDescription: View {
    var gist: Gist
    var body: some View {
        VStack(alignment: .leading) {
            Text(gist.gistDescription)
                .font(.footnote)
                .italic()
                .foregroundColor(.secondary)
        }.lineLimit(7)
    }
}

struct AvatarView: View {
    @ObservedObject var gistVM: GistViewModel
    var gist: Gist
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                if gistVM.ownerAvatar != nil {
                    Image(uiImage: gistVM.ownerAvatar!)
                        .resizable()
                        .renderingMode(.original)
                } else {
                    Circle()
                        .foregroundColor(.secondary)
                        .opacity(0.35)
                }
            }.frame(width: 72, height: 72)
                .scaledToFill()
                .clipShape(Circle())
                .animation(.default)
            
            Text(gist.owner.login.localizedCapitalized)
                .font(.headline)
        }
        .onAppear {
            self.gistVM.getAvatar(for: self.gist.owner.avatarURL)
        }
    }
}

struct FooterView: View {
    var gist: Gist
    var body: some View {
        VStack {
            HStack {
                Text("Created:")
                Spacer()
                Text(gist.createdAtString)
                    .foregroundColor(.secondary)
            }
            HStack {
                Text("Last updated:")
                Spacer()
                Text(gist.updatedAtString)
                    .foregroundColor(.secondary)
            }
            HStack {
                Text("Link:")
                Spacer()
                Text(gist.htmlURL)
                    .foregroundColor(.accentColor)
                    .lineLimit(1)
            }
        }
    }
}

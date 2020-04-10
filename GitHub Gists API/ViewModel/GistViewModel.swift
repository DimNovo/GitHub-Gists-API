//
//  GistViewModel.swift
//  GitHub Gists API
//
//  Created by Dmitry Novosyolov on 09/04/2020.
//  Copyright © 2020 Dmitry Novosyolov. All rights reserved.
//

import UIKit.UIImage
import Combine

final class GistViewModel: ObservableObject {
    
    @Published var searchText = ""
    @Published var gists: [Gist] = []
    @Published var ownerAvatar: UIImage? = nil
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    init() {
        $searchText
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap { (searchText: String) -> AnyPublisher<[Gist], Never> in
                GistService.shared.fetchGists(for: searchText.localizedLowercase)
        }
        .assign(to: \.gists, on: self)
        .store(in: &cancellableSet)
    }
    
    func getAvatar(for urlString: String) {
        guard let url = Endpoint.ava(urlString).avaURL else { return }
        ImageService.shared.fetchAvatar(for: url)
            .assign(to: \.ownerAvatar, on: self)
            .store(in: &cancellableSet)
    }
    
    deinit {
        cancellableSet.forEach { $0.cancel()}
    }
}

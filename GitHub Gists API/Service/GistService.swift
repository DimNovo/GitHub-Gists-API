//
//  GistService.swift
//  GitHub Gists API
//
//  Created by Dmitry Novosyolov on 09/04/2020.
//  Copyright © 2020 Dmitry Novosyolov. All rights reserved.
//

import Foundation
import Combine

final class GistService {
    static let shared = GistService()
    
    func fetchGists(for owner: String) -> AnyPublisher<[Gist], Never> {
        guard let url = Endpoint.main(owner).gistsURL else {
            return
                Just([])
                    .receive(on: RunLoop.main)
                    .eraseToAnyPublisher()
        }
        return
            URLSession.shared.dataTaskPublisher(for: url)
                .handleEvents(receiveSubscription: { $0.request(.max(1))})
                .map(\.data)
                .decode(type: [Gist].self, decoder: JSONDecoder())
                .catch { _ in Just([])}
                .map { $0.sorted(by: >)}
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
    }
}

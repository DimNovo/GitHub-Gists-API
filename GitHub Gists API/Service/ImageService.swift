//
//  ImageService.swift
//  GitHub Gists API
//
//  Created by Dmitry Novosyolov on 09/04/2020.
//  Copyright © 2020 Dmitry Novosyolov. All rights reserved.
//

import UIKit.UIImage
import Combine

final class ImageService {
    
    static let shared = ImageService()
    private let cache = NSCache<NSString, UIImage>()
    
    func fetchAvatar(for url: URL) -> AnyPublisher<UIImage?, Never> {
        if let image = cache.object(forKey: url.absoluteString as NSString) {
            return
                Just(image)
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
        }
        return
            URLSession.shared.dataTaskPublisher(for: url)
                .handleEvents(receiveSubscription: { $0.request(.max(1))})
                .map(\.data)
                .compactMap(UIImage.init)
                .handleEvents(receiveOutput: { [weak self] in self?.cache.setObject($0!, forKey: url.absoluteString as NSString)})
                .catch { _ in Just(nil)}
                .receive(on: RunLoop.main)
                .eraseToAnyPublisher()
    }
}

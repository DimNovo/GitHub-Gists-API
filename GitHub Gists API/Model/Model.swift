//
//  MOdel.swift
//  GitHub Gists API
//
//  Created by Dmitry Novosyolov on 09/04/2020.
//  Copyright © 2020 Dmitry Novosyolov. All rights reserved.
//

import Foundation

extension DateFormatter {
    convenience init(dateStyle: DateFormatter.Style, timeStyle: DateFormatter.Style) {
        self.init()
        self.dateStyle = dateStyle
        self.timeStyle = timeStyle
    }
}

enum Endpoint {
    
    case main(_: String)
    case ava(_: String)
    
    var baseURL: URL { URL(string: "https://api.github.com")! }
    var avaURL: URL? { URL(string: path())}
    var gistsURL: URL? { baseURL.appendingPathComponent(path())}
    
    func path() -> String {
        switch self {
        case let .main(owner):
            return "/users/\(owner)/gists"
        case let .ava(urlString):
            return "\(urlString)"
        }
    }
}

struct Gist {
    let id = UUID()
    let htmlURL, createdAt, updatedAt, gistDescription: String
    let owner: Owner
}

extension Gist: Codable, Identifiable, Comparable {
    
    var createdAtString: String {
        DateFormatter(dateStyle: .medium, timeStyle: .short).string(from: ISO8601DateFormatter().date(from: createdAt)!)
    }
    var updatedAtString: String {
        DateFormatter(dateStyle: .medium, timeStyle: .short).string(from: ISO8601DateFormatter().date(from: updatedAt)!)
    }
    
    static func <(lhs: Gist, rhs: Gist) -> Bool { lhs.updatedAt < rhs.updatedAt }
    
    enum CodingKeys: String, CodingKey {
        case htmlURL = "html_url"
        case gistDescription = "description"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case owner
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        htmlURL = try container.decode(String.self, forKey: .htmlURL)
        createdAt = try container.decode(String.self, forKey: .createdAt)
        updatedAt = try container.decode(String.self, forKey: .updatedAt)
        owner = try container.decode(Owner.self, forKey: .owner)
        gistDescription = try container.decodeIfPresent(String.self, forKey: .gistDescription) ?? "Description was not provided"
    }
}

struct Owner {
    let id: Int
    let login, avatarURL: String
}

extension Owner: Codable, Identifiable, Hashable {
    enum CodingKeys: String, CodingKey {
        case login, id
        case avatarURL = "avatar_url"
    }
}

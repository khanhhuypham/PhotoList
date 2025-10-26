//
//  Photo.swift
//  PhotoList
//
//  Created by Pham Khanh Huy on 22/10/25.
//



struct Photo: Codable {
    var id: String
    var author: String
    var width: Int
    var height: Int
    var url: String
    var download_url: String

  
    private enum CodingKeys: String, CodingKey {
        case id
        case author
        case width
        case height
        case url
        case download_url
    }
    
    init(id: String, author:String, width: Int, height: Int, url:String, download_url: String) {
        self.id = id
        self.author = author
        self.width = width
        self.height = height
        self.url = url
        self.download_url = download_url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(String.self, forKey: .id) ?? ""
        author = try container.decodeIfPresent(String.self, forKey: .author) ?? ""
        width = try container.decodeIfPresent(Int.self, forKey: .width) ?? 0
        height = try container.decodeIfPresent(Int.self, forKey: .height) ?? 0
        url = try container.decodeIfPresent(String.self, forKey: .url) ?? ""
        download_url = try container.decodeIfPresent(String.self, forKey: .download_url) ?? ""
    }
    
}

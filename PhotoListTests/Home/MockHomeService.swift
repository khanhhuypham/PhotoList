//
//  MockHomeService.swift
//  PhotoList
//
//  Created by Pham Khanh Huy on 22/10/25.
//


import XCTest
@testable import PhotoList

final class MockHomeService: HomeServiceProtocol {
    var result: Result<[Photo], Error>?
//    var page: Int?
    
    func getPhotoList(limit: Int, page: Int) async -> Result<[Photo], Error> {
//        self.page = page
        return result ?? .success([])
    }
}

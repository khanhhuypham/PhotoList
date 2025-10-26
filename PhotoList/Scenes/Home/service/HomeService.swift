//
//  HomeService.swift
//  PhotoList
//
//  Created by Pham Khanh Huy on 22/10/25.
//


protocol HomeServiceProtocol {
    func getPhotoList(limit: Int, page: Int) async -> Result<[Photo], Error>
}

struct HomeService: HomeServiceProtocol {
    func getPhotoList(limit: Int, page: Int) async -> Result<[Photo], Error> {
        await NetworkManager.callAPIAsync(netWorkManger: .getPhotoList(limit: limit, page: page))
    }
}

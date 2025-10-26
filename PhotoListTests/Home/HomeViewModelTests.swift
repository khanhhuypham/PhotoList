//
//  PhotoListViewModelTests.swift
//  PhotoList
//
//  Created by Pham Khanh Huy on 22/10/25.
//
import UIKit
import XCTest
@testable import PhotoList


final class HomeViewModelTests: XCTestCase {
    
    var mockService: MockHomeService!
    var viewModel: HomeViewModel!
    
    override func setUp() {
        super.setUp()
        mockService = MockHomeService()
        viewModel = HomeViewModel(service: mockService)
    }
    
    override func tearDown() {
        mockService = nil
        viewModel = nil
        super.tearDown()
    }
    
    func test_getPhotoList_success_shouldAppendDataAndIncrementPage() async {
        let photos = [Photo(id: "1", author: "John", width: 100, height: 100, url: "", download_url: "")]
        mockService.result = .success(photos)
        
        XCTAssertFalse(viewModel.APIParameter.isAPICalling)
        await viewModel.getPhotoList(page: 1)

        XCTAssertEqual(viewModel.photoList.count, 1)
        XCTAssertEqual(viewModel.APIParameter.page, 1)
        XCTAssertFalse(viewModel.APIParameter.isAPICalling)
        XCTAssertFalse(viewModel.APIParameter.isGetFullData)
    }
    
    func test_getPhotoList_failure_shouldNotAppendData() async {

        mockService.result = .failure(NSError(domain: "", code: -1))
        
        await viewModel.getPhotoList(page: 1)
        
        XCTAssertEqual(viewModel.photoList.count, 0)
        XCTAssertFalse(viewModel.APIParameter.isAPICalling)
    }
    
    func test_loadMoreContent_shouldCallAPIWhenNotFullData() async {
        mockService.result = .success([Photo(id: "1", author: "John", width: 100, height: 100, url: "", download_url: "")])
        viewModel.APIParameter.isGetFullData = false

        await viewModel.getPhotoList(page: 1)
        await viewModel.loadMoreContent()
        await viewModel.loadMoreContent()

        XCTAssertEqual(viewModel.APIParameter.page, 3)
    }
    
    
    
    func test_clearDataAndCallAPI() async {
        // Given: some existing data
        viewModel.photoList = [
            Photo(id: "1", author: "John", width: 100, height: 100, url: "", download_url: "")
        ]
        viewModel.APIParameter.page = 3
        viewModel.APIParameter.isGetFullData = true
        viewModel.APIParameter.isAPICalling = true

        let photos = [Photo(id: "2", author: "Alice", width: 200, height: 200, url: "", download_url: "")]
        mockService.result = .success(photos)

        viewModel.clearDataAndCallAPI()

        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1 second

        XCTAssertEqual(viewModel.photoList.count, 1, "Expected one photo after API call")
        XCTAssertEqual(viewModel.photoList.first?.id, "2", "Expected fetched photo ID to match mock data")
        XCTAssertEqual(viewModel.APIParameter.page, 1, "Page should reset to 1 after clear")
    }
    
}

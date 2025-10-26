//
//  LoginViewModel.swift
//  TechresOrder
//
//  Created by macmini_techres_03 on 12/01/2023.
//

import UIKit


class HomeViewModel : NSObject{
    private let service: HomeServiceProtocol
    private(set) weak var view: HomeViewController?

    var photoList:[Photo] = []

    var APIParameter:(
        key_search:String,
        limit:Int,
        page:Int,
        isAPICalling:Bool,
        isGetFullData:Bool
    ) = (
        key_search:"",
        limit:20,
        page:0,
        isAPICalling:false,
        isGetFullData:false
    )
   
    init(service: HomeServiceProtocol = HomeService()) {
        self.service = service
    }
    
    func bind(view: HomeViewController){
        self.view = view
    }
    
    func loadMoreContent() async{
        guard !APIParameter.isGetFullData, !APIParameter.isAPICalling else { return }
        await getPhotoList(page: APIParameter.page + 1)
    }
    
    
    func clearDataAndCallAPI(){
        photoList.removeAll()
        view?.tableView.reloadData()
        APIParameter.page = 0
        APIParameter.isGetFullData = false
        APIParameter.isAPICalling = false
      
        Task{
            await getPhotoList(page: APIParameter.page + 1)
        }
    }
    
}


extension HomeViewModel{
    
    @MainActor
    func getPhotoList(page:Int) async {
  
        APIParameter.isAPICalling = true

        let result = await service.getPhotoList(limit: APIParameter.limit, page: page)
  
        switch result {
            case .success(let data):
                
                guard data.isEmpty == false else {
                    
                    APIParameter.isAPICalling = false
                    return
                }
                let start = photoList.count
                photoList.append(contentsOf: data)
                APIParameter.page = page
                APIParameter.isGetFullData = photoList.count >= 100
                APIParameter.isAPICalling = false
                
                // Update UI
                if let tableView = view?.tableView {
                    UIView.performWithoutAnimation {
                        tableView.performBatchUpdates({
                            let end = photoList.count - 1
                            let indexPaths = (start...end).map { IndexPath(row: $0, section: 0) }
                            tableView.insertRows(at: indexPaths, with: .none)
                        })
                    }
                }
                
                break
                
            case .failure(let error):
                
                APIParameter.isAPICalling = false
                if let err = error as? NetworkError{
                    dLog("❌ API error: \(err.description)")
                }
                
            
        }
    }


}


//
//  HomeViewController + extension.swift
//  PhotoList
//
//  Created by Pham Khanh Huy on 22/10/25.
//

import Foundation
import UIKit

extension HomeViewController: UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate {

    func registerCell(){
        let cell = UINib(nibName: "HomeTableViewCell", bundle: .main)
        tableView.register(cell, forCellReuseIdentifier: "HomeTableViewCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl) // not required when using UItableViewController
    }

    @objc func refresh(_ sender: AnyObject) {
          // Code to refresh table view
        viewModel.clearDataAndCallAPI()
        refreshControl.endRefreshing()
    }
    
    // MARK: - UITableViewDataSource methods
      
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.photoList.count
    }
      
    func tableView(_ tableView: UITableView,cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as? HomeTableViewCell
        cell?.data = viewModel.photoList[indexPath.row]
        return cell ?? UITableViewCell()
    }
      
    // MARK: - UITableViewDelegate methods (optional)
      
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
        

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView){
   
        let tableViewContentHeight = tableView.contentSize.height
        let tableViewHeight = tableView.frame.size.height
        let scrollOffset = scrollView.contentOffset.y
     
        if scrollOffset + tableViewHeight >= tableViewContentHeight {  // scroll downward
            
            if(!viewModel.APIParameter.isGetFullData && !viewModel.APIParameter.isAPICalling){
                Task {
                    await viewModel.loadMoreContent()
                }
            }
        }else if scrollOffset < -80 { // scroll upward

        }
    }

    
    
}


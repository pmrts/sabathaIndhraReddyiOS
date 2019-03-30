//
//  FeedViewModel.swift
//  Sabitha_Indra_Reddy
//
//  Created by Aditya Bonthu on 29/04/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import Foundation

class FeedViewModel {
    
    private var feedData = [FeedData]()
    
    public func fetchAllFeedData(page: Int, completionCallback: @escaping (Bool,Error?) -> Void) {
        SabithaNetworkAdapter.request(target: .feedData(page: page), success: { (response) in
            do {
                let jsonData = try response["result"].rawData()
                User.sharedInstance.imageBasePath = response["base_url"].stringValue
                let feedlist = try JSONDecoder().decode([FeedData].self, from: jsonData)
                self.feedData.append(contentsOf: feedlist)
                completionCallback(true,nil)
            } catch {
                completionCallback(false,error)
            }
        }, error: { (error) in
            print(error.localizedDescription)
        }) { (error) in
            print(error)
        }
    }
    
    public func numberOfNewsItems() -> Int {
        return feedData.count
    }
    
    public func newsItemAtIndex(index: IndexPath) -> FeedData {
        return feedData[index.row]
    }

    public func removeAll() {
        feedData.removeAll()
    }
    
}

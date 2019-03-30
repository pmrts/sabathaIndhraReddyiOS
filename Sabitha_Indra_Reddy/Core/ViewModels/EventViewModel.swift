//
//  EventViewModel.swift
//  Sabitha_Indra_Reddy
//
//  Created by Aditya Bonthu on 02/05/18.
//  Copyright © 2018 Aditya Bonthu. All rights reserved.
//

import Foundation

class EventViewModel {

    var eventsData = [EventData]()

    public func fetchAlleventData(page: Int, eventtype:Int ,completionCallback: @escaping (Bool,Error?) -> Void, completionStatus: @escaping (_ message: String) -> Void) {
        SabithaNetworkAdapter.request(target: .eventData(page: page, eventType: eventtype), success: { (response) in
            do {
              let jsonData = try response["result"].rawData()
                let eventlist = try JSONDecoder().decode([EventData].self, from: jsonData)
                self.eventsData.append(contentsOf: eventlist)
                completionCallback(true,nil)
            } catch {
                completionCallback(false,error)
            }
        }, error: { (error) in
            print(error.localizedDescription)
            completionStatus("No Data Found")
        }) { (error) in
            print(error)
        }
    }

    public func numberOfEventsItems() -> Int {
        return eventsData.count
    }

    public func eventItemAtIndex(index: IndexPath) -> EventData {
        return eventsData[index.row]
    }

}

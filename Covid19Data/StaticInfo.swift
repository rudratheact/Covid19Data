//
//  StaticInfo.swift
//  Covid19Stats
//
//  Created by Rudra Evolut on 23/02/22.
//

import Foundation
import SystemConfiguration
import UIKit

class StaticInfo{
    // Sigleton
    static let shared = StaticInfo()
    
    var completeData: GetCompleteData?
    var selectedDict: [String:Any]?
    
    let caseTableViewCell = "CaseTableViewCell"
    let detailsTableViewCell = "detailsCell"
    let cellSegue = "browseSegue"
    
    let apiURL = "https://data.covid19india.org/data.json"
    
    // Check internet connectivity
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    // Alert
    func showAlert(vc: UIViewController, message: String){
        let alert = UIAlertController(title: "Error!", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        vc.present(alert, animated: true, completion: nil)
    }
    
    // call API
    func getDataFromAPI(vc: UIViewController, completion: @escaping (_ success: Bool)->Void = { _ in }){
        if isConnectedToNetwork(){
            let task = URLSession.shared.dataTask(with: URL(string: apiURL)!) { data, response, error in
                if error == nil{
                    if let record = data{
                        do{
                            let persedRecord = try JSONDecoder().decode(GetCompleteData.self, from: record)
                            self.completeData = persedRecord
//                            print(self.completeData ?? "")
                            completion(true)
                        }catch{
                            print(error.localizedDescription)
                        }
                    }
                }else{
                    print(error?.localizedDescription ?? "")
                }
            }
            task.resume()
        }
        else{
            self.showAlert(vc: vc, message: "Please check the internet connectivity and try again.")
        }
        
    }
}



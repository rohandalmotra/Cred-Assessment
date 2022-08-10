//
//  Brain.swift
//  CRED Problem statement
//
//  Created by Rohan Dalmotra on 26/07/22.
//

import Foundation
import UIKit

protocol BrainDelegate{
    func didGetSuccess(status: Bool)
    func didFailWithError(error: Error)
}

struct Brain{
    var delegate: BrainDelegate?
    
    
    func success(){
        let successURL = "https://api.mocklets.com/p68348/success_case"
        performRequest(with: successURL)
        
    }
    
    func failure(){
        let failureURL = "https://api.mocklets.com/p68348/failure_case"
        performRequest(with: failureURL)
    }
    
    func performRequest(with urlString: String){
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { data, response, error in
                
                if let safeData = data{
//                    print(safeData)
                    if let dataStatus = parseJSON(safeData){
                        delegate?.didGetSuccess(status: dataStatus)
                    }
                    
                }
            }
            
            task.resume()
            
        }
        
    }
    
    
    func parseJSON(_ data: Data) -> Bool?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(SuccessData.self, from: data)
            let successStatus = decodedData.success
            return successStatus
            
        }
        catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}


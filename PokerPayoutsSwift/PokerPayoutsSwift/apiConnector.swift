// apiConnector.swift
// Poker Payouts Swift
//
// Created by Samuel Ridet on 10/20/23.

import Foundation

struct venmo : Identifiable{
let id : String
let value : String
}
struct ResultDisplay : Identifiable{
let id : String
let amounts : [venmo]

}
class ApiConnector : ObservableObject{
@Published var resultList : [ResultDisplay] = []
@Published var errorMessage = " "
@Published var holderString =
"""

"""
func parseData(standings: [Details]) -> [[String]] {
    var finalArr: [[String]] = []
    
    for s in standings {
        let temporary = [String(s.id), String(s.buy), String(s.winning)]
        finalArr.append(temporary)
    }
    print(finalArr)
    return finalArr
}

enum ServerResponse {
    case error(String)
    case data([[String: Any]])
}

func getResponse(standings: [Details], _ completion: @escaping (() -> Void)) {
    self.errorMessage = " "
    self.resultList = []
    let dataToPost = parseData(standings: standings)
    let parameters: [String: Any] = ["standings": dataToPost]
    let url = URL(string: "https://us-central1-pokeralgo.cloudfunctions.net/greedyAlgo")!
    let session = URLSession.shared
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    
    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
    } catch let error {
        print(error.localizedDescription)
        return
    }
    
    let task = session.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Post Request Error: \(error.localizedDescription)")
            return
        }
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            print("Invalid Response received from the server")
            return
        }
        guard let responseData = data else {
            print("nil Data received from the server")
            return
        }
        
        
        if let responseStr = String(data: responseData, encoding: .utf8) {
            if responseStr.contains("Error"){
                self.errorMessage = responseStr
            }
          
            print("Server Response: \(responseStr)")
    

        }
      
        // Now, attempt to parse as transactions
        do {
            if let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) as? [[Any]] {
                let currentDate = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy"
                let formattedDate = dateFormatter.string(from: currentDate)

                var currentPlayerString = """
                                          Goon House Poker
                                          Date: \(formattedDate)
                                          """
                for playerTransaction in jsonResponse {
                    currentPlayerString.append("\n------------------\n")
                    if let playerName = playerTransaction[0] as? String, let transactions = playerTransaction[1] as? [[Any]] {
                        currentPlayerString.append("\(playerName)\n")
                        var arrayFinal : [venmo] = []
                        for transaction in transactions {
                            let owedTo = transaction[0] as? String ?? ""
                            let amount = transaction[1] as? String ?? ""
                            print("Amount")
                            print(transaction[1])
                            currentPlayerString.append("\t pays \(owedTo) for \(amount)$ \n")
                            let holder = venmo(id: String(owedTo), value: String(amount))
                            arrayFinal.append(holder)
                                
                            
                        }
                        self.resultList.append(ResultDisplay(id: playerName, amounts: arrayFinal))
                    }
                }
                self.holderString = currentPlayerString
                completion()
            } else {
                print("Data is neither an error string nor in the expected transaction format")
            }
        } catch {
            print("Error decoding JSON: \(error)")
        }
        
        
        
    }
    task.resume()
    completion()
}
}

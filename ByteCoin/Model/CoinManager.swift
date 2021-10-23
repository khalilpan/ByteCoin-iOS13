//
//  CoinManager.swift
//  ByteCoin
//
//  Created by khalil.panahi
//

import Foundation

protocol CoinManagerDelegate {
    func didFetchCoinData(cointData: CoinData)
    func didFailWithError(error: Error)
}

struct CoinManager {
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "?apikey=BBB90C26-A88E-4F01-8827-779EC23C6250"

    let currencyArray = ["AUD", "BRL", "CAD", "CNY", "EUR", "GBP", "HKD", "IDR", "ILS", "INR", "JPY", "MXN", "NOK", "NZD", "PLN", "RON", "RUB", "SEK", "SGD", "USD", "ZAR"]

    var delegate : CoinManagerDelegate?
    
    func performRequest(currency: String) {
        let urltemp = "\(baseURL)/\(currency)\(apiKey)"
        if let url = URL(string: urltemp) {
            let session = URLSession(configuration: .default)

            let task = session.dataTask(with: url) { data, _, error in
                if error != nil {
                    delegate?.didFailWithError(error: error as! Error)
                    return
                }
                if let safeData = data {
                    // Format the data we got back as a string to be able to print it.
                    //  let dataAsString = String(data: safeData, encoding: .utf8)
                    //  print(dataAsString)
                    if let coin = parseJSON(coinData: safeData) {
                        delegate?.didFetchCoinData(cointData: coin)
                    }
                }
            }

            task.resume()
        }
    }
    
    
    func parseJSON(coinData: Data) -> CoinData? {
        let decoder = JSONDecoder()

        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
                      
            return decodedData
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    

    func getCoinPrice(for currency: String) {
        performRequest(currency: currency)
    }
}




//
//  ViewController.swift
//  ByteCoin
//
//  Created by khalil.panahi
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var bitcoinLabel: UILabel!
    @IBOutlet var currencyLabel: UILabel!
    @IBOutlet var currencyPicker: UIPickerView!

    var coinManager = CoinManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        
        coinManager.delegate = self
        
        //to fetch the first infos  when app starts
        coinManager.getCoinPrice(for: coinManager.currencyArray[0])
    }
}

//MARK: - UIPickerViewDataSource

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in _: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_: UIPickerView, numberOfRowsInComponent _: Int) -> Int {
        coinManager.currencyArray.count
    }
}


// MARK: - UIPickerViewDelegate


extension ViewController: UIPickerViewDelegate {
    func pickerView(_: UIPickerView, titleForRow row: Int, forComponent _: Int) -> String? {
        return coinManager.currencyArray[row]
    }

    func pickerView(_: UIPickerView, didSelectRow row: Int, inComponent _: Int) {
        let selectedCurrency = coinManager.currencyArray[row]
        coinManager.getCoinPrice(for: selectedCurrency)
    }
}


//MARK: - CoinManagerDelegate

extension ViewController: CoinManagerDelegate{
    func didFetchCoinData(cointData: CoinData) {
        
        DispatchQueue.main.async {
        self.bitcoinLabel.text = String(cointData.rate)
        self.currencyLabel.text = cointData.asset_id_quote
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}

//
//  HandleIAP.swift
//  ArithmeticGame
//
//  Created by 吳建豪 on 2017/3/26.
//  Copyright © 2017年 吳建豪. All rights reserved.
//

import Foundation
import StoreKit

extension HomeViewController {
    
    func checkPro() {
        products = []
        ArithmeticGamePro.share.store.requestProducts{success, products in
            if success  {
                self.products = products!
            }
        }
    }
    
    
    func updatePro(){
        let priceFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.formatterBehavior = .behavior10_4
            formatter.numberStyle = .currency
            return formatter
        }()
        
        guard let product = products.first else { return }
        
        if IAPHelper.canMakePayments() {
            priceFormatter.locale = product.priceLocale
            if let price = priceFormatter.string(from: product.price) {
                
                let alertController = UIAlertController(title: "\(product.localizedTitle)  \(price)", message: "\(product.localizedDescription)", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Buy Pro", style: UIAlertActionStyle.default) { (action) in
                    ArithmeticGamePro.share.store.homeViewController = self
                    ArithmeticGamePro.share.store.buyProduct(product)
                }
                let restoreAction = UIAlertAction(title: "Restore", style: UIAlertActionStyle.default) { (action) in
                    ArithmeticGamePro.share.store.homeViewController = self
                    ArithmeticGamePro.share.store.restorePurchases()
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                alertController.addAction(restoreAction)
                present(alertController, animated: true, completion: nil)
            }
        }
    }
}

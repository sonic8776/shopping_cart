//
//  ViewController.swift
//  Shopping_Cart
//
//  Created by Judy Tsai on 2021/7/2.
//

import UIKit
import FirebaseFirestore

class CheckListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    let database = Firestore.firestore()
    var orderDict = [String: [Int]]() // Used for saving order details to Firestore
    
    var foodCheckList = [FoodItem]()
    var totalPriceList = [Int]() // total price for each item
    var finalTotalPrice = 0 // total price for this order
    
    var storeInfo = [String]() // storeName, storePhone, customerName
    
    let sections = ["訂單總計", "總計"]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Calculate total price for each item.
        for item in foodCheckList {
            let totalPrice = item.serving * item.price
            totalPriceList.append(totalPrice)
        }
        
        // Calculate final total price.
        var total = 0
        for price in totalPriceList {
            total += price
            finalTotalPrice = total
        }
        //totalPriceList.append(finalTotalPrice)
        
        //        let finalFood = FoodItem(name: "總計", price: finalTotalPrice, serving: 0)
        //        foodCheckList.append(finalFood)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
    }
    
    @IBAction func submitBtnPressed(_ sender: UIButton) {
        let confirmMessage = "將會把訂單資料儲存到資料庫"
        displayAlert(title: "確定要送出嗎？", message: confirmMessage)
    }
    
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確認", style: .default, handler: { action in
            for order in self.foodCheckList {
                let foodName = order.name
                //                let foodServingString = "共 \(String(order.serving)) 份"
                //                let foodPriceString = "$\(String(order.price)) / 份"
                let foodServing = order.serving
                let foodPrice = order.price
                self.orderDict[foodName] = [foodServing, foodPrice]
            }
            self.writeData(orderDetail: self.orderDict, totalPrice: self.finalTotalPrice)
        }))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Firebase Firestroe Related Methods.
    
    func writeData(orderDetail: [String: [Int]], totalPrice: Int) {
        
        let timeStamp = FieldValue.serverTimestamp()
        
        database.collection(FStore.collectionName).addDocument(data: [
            FStore.timeStamp: timeStamp,
            FStore.orderDetail: orderDetail,
            FStore.totalPrice: totalPrice]) { error in
            if let e = error {
                print("There was an issue saving data to Firestore: \(e)")
            } else {
                print("Successfully saved data.")
            }
        }
    }
    
    // MARK: - TableView Delegate & DataSource Methods.
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return foodCheckList.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "checkCell", for: indexPath) as! CheckTableViewCell
            cell.nameLabel.text = foodCheckList[indexPath.row].name
            
            let amount = "\(String(foodCheckList[indexPath.row].serving)) 份"
            cell.amountLabel.text = amount
            
            let totalPrice = "$ \(String(totalPriceList[indexPath.row]))"
            cell.totalLabel.text = totalPrice
            
            return cell
        } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath) as! InfoTableViewCell
        cell.finalTotalPriceLabel?.text = "$\(String(finalTotalPrice))"
        cell.finalTotalPriceLabel.textColor = UIColor(red: 225/255, green: 89/255, blue: 66/255, alpha: 1)
        cell.infoLabel.textColor = UIColor(red: 225/255, green: 89/255, blue: 66/255, alpha: 1)
        return cell
        }
    }
}

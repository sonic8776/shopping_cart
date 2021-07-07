//
//  ViewController.swift
//  Shopping_Cart
//
//  Created by Judy Tsai on 2021/7/2.
//

import UIKit

class CheckListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var foodCheckList = [FoodItem]()
    var totalPriceList = [Int]() // total price for each item
    var finalTotalPrice = 0 // total price for this order
    
    var storeInfo = [String]() // storeName, storePhone, customerName
    
    let sections = ["訂單總計", "商家資訊"]
    
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
        totalPriceList.append(finalTotalPrice)
        
        let finalFood = FoodItem(name: "總計", price: finalTotalPrice, serving: 0)
        foodCheckList.append(finalFood)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func submitBtnPressed(_ sender: UIButton) {
        let confirmMessage = "測試"
        displayAlert(title: "確定要送出嗎？", message: confirmMessage)
    }
    
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確認", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
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
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            if indexPath.row != foodCheckList.count - 1 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "checkCell", for: indexPath) as! CheckTableViewCell
                cell.nameLabel.text = foodCheckList[indexPath.row].name
                
                let amount = "\(String(foodCheckList[indexPath.row].serving)) 份"
                cell.amountLabel.text = amount
                
                let totalPrice = "$ \(String(totalPriceList[indexPath.row]))"
                cell.totalLabel.text = totalPrice
                
                return cell
                
            } else {
                
                // Show the last cell to indicate the total price.
                let cell = tableView.dequeueReusableCell(withIdentifier: "checkCell", for: indexPath) as! CheckTableViewCell
                cell.nameLabel.text = foodCheckList[indexPath.row].name
                cell.nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
                cell.nameLabel.textColor = UIColor(red: 225/255, green: 89/255, blue: 66/255, alpha: 1)
                
                cell.amountLabel.text = ""
                
                let totalPrice = "$ \(String(totalPriceList[indexPath.row]))"
                cell.totalLabel.text = totalPrice
                cell.totalLabel.font = UIFont.boldSystemFont(ofSize: 16)
                cell.totalLabel.textColor = UIColor(red: 225/255, green: 89/255, blue: 66/255, alpha: 1)
                
                return cell
             
            }
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoCell", for: indexPath)
            cell.textLabel?.text = ""
            return cell
        }
    }
}
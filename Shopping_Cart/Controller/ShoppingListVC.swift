//
//  ShoppingListTableVC.swift
//  Shopping_Cart
//
//  Created by Judy Tsai on 2021/7/2.
//

import UIKit
import FirebaseFirestore

class ShoppingListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var foodList = [FoodItem]()
    let database = Firestore.firestore()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
        
//        for i in 1...5 {
//            let testItem = FoodItem(name: "便當\(i)", price: Int.random(in: 60...100), serving: Int.random(in: 1...10))
//            self.foodList.append(testItem)
//        }
        loadOrder()
    }
    
    @IBAction func addBtnPressed(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "新增項目", message: "", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "要訂什麼？（如：雞腿便當）"
        }
        
        let saveAction = UIAlertAction(title: "確定", style: UIAlertAction.Style.default, handler: { alert -> Void in
            let nameTextField = alertController.textFields![0] as UITextField
            let priceTextField = alertController.textFields![1] as UITextField
            let servingTextField = alertController.textFields![2] as UITextField
            
            let name = nameTextField.text ?? "新的項目"
            let price = priceTextField.text ?? ""
            let serving = servingTextField.text ?? ""
            
            let newFood = FoodItem(name: name, price: Int(price) ?? 0, serving: Int(serving) ?? 0)
            
            self.foodList.append(newFood)
            self.tableView.reloadData()
            
        })
        
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.default, handler: {
                                            (action : UIAlertAction!) -> Void in })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "每份多少錢？"
            textField.keyboardType = .numberPad
        }
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "想訂幾份？"
            textField.keyboardType = .numberPad
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Firestore method
    
    func loadOrder() {
        
        database.collection(FStore.collectionName).order(by: FStore.timeStamp, descending: true).limit(to: 1).addSnapshotListener
        //database.collection(FStore.collectionName).order(by: FStore.timeStamp).limit(to: 1).getDocuments
        { (snapShot, error) in
            
            print("inside closure")
            
            self.foodList = []
            
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            }
            if let snapShotDocuments = snapShot?.documents,
               let doc = snapShotDocuments.first {
                
                print("Found document.")
                
                let data = doc.data()
                
                print(FStore.orderDetail)
                
                if let orderDetail = data[FStore.orderDetail] as? [String: [Int]] {
                    
                    print("Found order detail.")
                    // Convert to FoodItem and append back to foodList
                    for food in orderDetail {
                        let name = food.key
                        let serving = food.value[0]
                        let price = food.value[1]
                        let newFood = FoodItem(name: name, price: price, serving: serving)
                        self.foodList.append(newFood)
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    print("Successfully loaded data from Firestore.")
                }
            }
            
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return foodList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodCell", for: indexPath) as! FoodTableViewCell
        
        let food = foodList[indexPath.row]
        cell.nameLabel.text = food.name
        cell.priceLabel.text = "$\(String(food.price)) / 每份"
        cell.servingLabel.text = "已選 \(String(food.serving)) 份"
        cell.stepper.value = Double(food.serving)
        cell.stepper.tag = indexPath.row
        
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from data source
            foodList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "check" {
            
            if let checkListVC = segue.destination as? CheckListVC {
                checkListVC.foodCheckList = foodList
            }
        }
    }
}

// MARK: - FoodTableViewCellDelegate Method.

extension ShoppingListVC: FoodTableViewCellDelegate {
    
    func stepper(_ stepper: UIStepper, at index: Int, didChangeValueTo newValue: Double) {
        // Process that change...
        let indexPath = IndexPath(item: index, section: 0)
        guard let cell = tableView.cellForRow(at: indexPath) as? FoodTableViewCell else { return }
        // Send the value back to the cell
        let foodToBeUpdated = foodList[indexPath.row]
        
        // print("foodToBeUpdated.serving: \(foodToBeUpdated.serving)")
        
        foodToBeUpdated.serving = Int(newValue)
        // print("Value changed in VC: \(newValue)")
        
        cell.servingLabel.text = "已選 \(String(format: "%.0f", newValue)) 份"
    }
}

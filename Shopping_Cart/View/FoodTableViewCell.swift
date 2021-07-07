//
//  FoodTableViewCell.swift
//  Shopping_Cart
//
//  Created by Judy Tsai on 2021/7/2.
//

import UIKit

protocol FoodTableViewCellDelegate: AnyObject {
  func stepper(_ stepper: UIStepper, at index: Int, didChangeValueTo newValue: Double)
}

class FoodTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var servingLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    weak var delegate: FoodTableViewCellDelegate?
    
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        
        sender.minimumValue = 1
        
        servingLabel.text = "已選 \(String(format: "%.0f", sender.value)) 份"
        
        // Pass the new value to ShoppingListVC and notify which cell to update using tag.
        print("sender.value: \(sender.value)")
        //print("stepper.value: \(stepper.value)")
        //print("stepper.tag: \(stepper.tag)")
        delegate?.stepper(stepper, at: stepper.tag, didChangeValueTo: sender.value)
        
        //NotificationCenter.default.post(name: .updateToList, object: nil, userInfo: ["servingFromStepper" : sender.value])
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        print(stepper.value)

        NotificationCenter.default.addObserver(self, selector: #selector(changeStepperValue(notification:)), name: .updateToStepper, object: nil)
    }
    
    @objc func changeStepperValue(notification: Notification) {
        
        if let foodServing = notification.userInfo?["servingFromList"] as? Int {
            
            stepper.value = Double(foodServing)
            print("-- stepper.value = \(stepper.value) --")
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

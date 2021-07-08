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
        delegate?.stepper(stepper, at: stepper.tag, didChangeValueTo: sender.value)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

//
//  CosmeTypeTableCell.swift
//  Trousse_App
//
//  Created by 吉田琉夏 on 2020/07/21.
//  Copyright © 2020 吉田琉夏. All rights reserved.
//

import Foundation
import UIKit
import Firebase
class CosmeTypeTableCell: UITableViewCell {
    
    var name:String!
    
    @IBOutlet weak var cosmeTypeView: UIView!
    @IBOutlet weak var cosmeType: UILabel!
    @IBOutlet weak var mySwitch: UISwitch!
    var userId:String = ""
    
    @IBAction func hundleSwitch(sender: UISwitch) {
        if sender.isOn{
            if let cosmeTypeName = name{
                ViewController().append(cosmeTypeName: cosmeTypeName,userId:userId)
            }
        }else{
            if let cosmeTypeName = name{
                ViewController().delete(cosmeTypeName: cosmeTypeName)
            }
        }
    }
}

//
//  cosmeCollectionCell.swift
//  Trousse_App
//
//  Created by 吉田琉夏 on 2020/07/23.
//  Copyright © 2020 吉田琉夏. All rights reserved.
//


import Foundation
import UIKit
class CosmeCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var BrandLabel: UILabel!
    @IBOutlet weak var ColorLabel: UILabel!
    @IBOutlet weak var cosmeItem: UIView!
    @IBOutlet weak var cosmeSwitch: UISwitch!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor(named: "mainColor")?.cgColor
        self.layer.cornerRadius = 8.0
    }
    
    func setupCell(cosmes: Cosmes) {
        NameLabel.text = cosmes.name
        BrandLabel.text = cosmes.brand
        ColorLabel.text = cosmes.color
    }
    
    @IBAction func onCosme(_ sender: UISwitch) {
        if sender.isOn{
           print("jjj")
        }else{
            print("ggg")
        }
        print("tag=", self.tag)
    }
    
}

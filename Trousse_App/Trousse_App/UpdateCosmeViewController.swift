//
//  UpdateCosmeViewController.swift
//  Trousse_App
//
//  Created by 吉田琉夏 on 2020/08/21.
//  Copyright © 2020 吉田琉夏. All rights reserved.
//


import Foundation
import UIKit
import Firebase

class UpdateCosmeViewController : UIViewController{
    var alertController: UIAlertController!
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var brandField: UITextField!
    @IBOutlet weak var colorField: UITextField!
    var cosmeInfo:Cosmes!
    var cosmeType:String = ""
    var userId:String = ""
    var cosmeId:String = ""
    var index:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(cosmeId)
        nameField.text = "\(cosmeInfo.name)"
        brandField.text = "\(cosmeInfo.brand)"
        colorField.text = "\(cosmeInfo.color)"
    }
    
    @IBAction func changeCosmeInfo(_ sender: UIButton) {
        var Name:String
        var Brand:String
        var Color:String
        if let cosmeName = nameField.text{
            Name = "\(cosmeName)"
        }else{
            Name = "name"
        }
        if let cosmeBrand = brandField.text{
            Brand = "\(cosmeBrand)"
        }else{
            Brand = "brand"
        }
        if let cosmeColor = colorField.text{
            Color = "\(cosmeColor)"
        }else{
            Color = "color"
        }
        let info = [
            "name": Name,
            "brand":Brand,
            "color":Color
        ]
        Firestore.firestore()
        .collection("users")
        .document(userId)
        .collection("cosmes")
        .document(cosmeType)
        .collection("data")
        .document(cosmeId)
        .updateData(info) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        let preVC = self.presentingViewController as! EditViewController
        preVC.cosmeArray.remove(at:index)
        preVC.cosmeArray.insert(Cosmes(name:Name,brand:Brand,color:Color),at: index)
        preVC.cosmeCollection.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Alert(_ sender: UIButton) {
        let alert = UIAlertController(title: "確認", message: "本当に削除しますか", preferredStyle: UIAlertController.Style.alert)
        // 表示させたいタイトル1ボタンが押された時の処理をクロージャ実装する
        let yes = UIAlertAction(title: "はい", style: UIAlertAction.Style.default, handler: {
            (action: UIAlertAction!) in
            //実際の処理
            self.deleteCosme()
        })
        //UIAlertActionのスタイルがCancelなので赤く表示される
        let close = UIAlertAction(title: "いいえ", style: UIAlertAction.Style.default, handler: {
            (action: UIAlertAction!) in
            //実際の処理
            print("閉じる")
        })
        alert.addAction(close)
        alert.addAction(yes)
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteCosme(){
        Firestore.firestore()
        .collection("users")
        .document(userId)
        .collection("cosmes")
        .document(cosmeType)
        .collection("data")
        .document(cosmeId)
        .delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        let preVC = self.presentingViewController as! EditViewController
        preVC.cosmeArray.remove(at:index)
        preVC.cosmeCollection.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
}

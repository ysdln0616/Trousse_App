//
//  AddViewController.swift
//  Trousse_App
//
//  Created by 吉田琉夏 on 2020/08/16.
//  Copyright © 2020 吉田琉夏. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class AddViewController : UIViewController, UITextFieldDelegate{
    var alertController: UIAlertController!
    var cosmeType:String = ""
    var userId:String = ""
    var cosmeArray = [Cosmes]()
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var brandField: UITextField!
    @IBOutlet weak var colorField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func canAdd(){
        let alert = UIAlertController(title: "追加できました", message: "", preferredStyle: UIAlertController.Style.alert)
        // 表示させたいタイトル1ボタンが押された時の処理をクロージャ実装する
        //UIAlertActionのスタイルがCancelなので赤く表示される
        let can = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(can)
        self.present(alert, animated: true, completion: nil)
    }
    
    func cannotAdd(){
        let alert = UIAlertController(title: "追加できませんでした", message: "", preferredStyle: UIAlertController.Style.alert)
        // 表示させたいタイトル1ボタンが押された時の処理をクロージャ実装する
        //UIAlertActionのスタイルがCancelなので赤く表示される
        let can = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
            (action: UIAlertAction!) in
        })
        alert.addAction(can)
        self.present(alert, animated: true, completion: nil)
    }
      
    @IBAction func AddCosme(_ sender: UIButton) {
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
        var ref: DocumentReference? = nil
        ref = Firestore.firestore()
        .collection("users")
        .document(userId)
        .collection("cosmes")
        .document(cosmeType)
        .collection("data")
        .addDocument(data:info) { err in
            if let err = err {
                self.cannotAdd()
                print("Error adding document: \(err)")
            } else {
                self.canAdd()
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        let preVC = self.presentingViewController as! EditViewController
        preVC.cosmeArray.append(Cosmes(name: Name, brand: Brand, color: Color))
        preVC.cosmeCollection.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
}

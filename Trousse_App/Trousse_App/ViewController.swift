//
//  ViewController.swift
//  Trousse_App
//
//  Created by 吉田琉夏 on 2020/07/18.
//  Copyright © 2020 吉田琉夏. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import Promises

struct Cosmes {
    var name: String
    var brand: String
    var color: String
}

let cosmeTypes = [
    "makeupbase",
    "foundation",
    "facepowder",
    "eyeshadow",
    "eyeliner",
    "mascara",
    "eyebrow",
    "cheek",
    "lipstick",
    "lipgloss"
]

class ViewController: UIViewController{
    
    var userName:String = ""
    var userId:String = ""
    var cosmeType:String = ""
    var cosmeArray = [Cosmes]()
    var cosmeChoice = [
        "makeupbase": [String](),
        "foundation": [String](),
        "facepowder": [String](),
        "eyeshadow": [String](),
        "eyeliner": [String](),
        "mascara": [String](),
        "eyebrow": [String](),
        "cheek": [String](),
        "lipstick": [String](),
        "lipgloss": [String]()
    ]
    var typeChoice = [String]()
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cosmeTypeTable: UITableView!
    
    let cellReuseIdentifier = "cell"
    let cellSpacingHeight: CGFloat = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = userName
        cosmeTypeTable.dataSource = self
        cosmeTypeTable.delegate = self
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
   
    func GET(cosmeType: String, completion: @escaping ([Cosmes]?, Error?) -> Void){
        var cosmeArray1 = [Cosmes]()
        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "queue", attributes: .concurrent)
        dispatchGroup.enter()
        dispatchQueue.async {
            Firestore.firestore()
            .collection("users")
            .document(self.userId)
            .collection("cosmes")
            .document(cosmeType)
            .collection("data")
            .getDocuments{ (snaps, error) in
                if let error = error {
                    completion(nil,error)
                    fatalError("\(error)")
                }
                guard let snaps = snaps else { return }
                for document in snaps.documents {
                    var Name:String
                    var Brand:String
                    var Color:String
                    if let cosmeName = document.data()["name"]{
                        Name = "\(cosmeName)"
                    }else{
                        Name = "name"
                    }
                    if let cosmeBrand = document.data()["brand"]{
                        Brand = "\(cosmeBrand)"
                    }else{
                        Brand = "brand"
                    }
                    if let cosmeColor = document.data()["color"]{
                        Color = "\(cosmeColor)"
                    }else{
                        Color = "color"
                    }
                    cosmeArray1.append(Cosmes(name: Name, brand: Brand, color: Color))
                }
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            completion(cosmeArray1, nil)
        }
    }
    
    func GetId(cosmeType:String,userId:String,completion: @escaping ([String]?, Error?) -> Void){
        var cosmeArray2 = [String]()
        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "queue", attributes: .concurrent)
        dispatchGroup.enter()
        dispatchQueue.async {
            Firestore.firestore()
            .collection("users")
            .document(userId)
            .collection("cosmes")
            .document(cosmeType)
            .collection("data")
            .getDocuments() { (querySnapshot, error) in
                if let error = error {
                    completion(nil,error)
                    print("Error getting documents: \(error)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        cosmeArray2.append(document.documentID)
                    }
                }
                dispatchGroup.leave()
            }
            dispatchGroup.notify(queue: .main) {
                completion(cosmeArray2, nil)
            }
        }
    }
    
    func append(cosmeTypeName:String,userId:String){
        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "queue", attributes: .concurrent)
        dispatchGroup.enter()
        dispatchQueue.async {
            self.GetId(cosmeType: cosmeTypeName,userId:userId){cosmeArray2, error in
                guard cosmeArray2 != nil else {
                    self.cosmeArray = [Cosmes(name: "Name", brand: "Brand", color: "Color")]
                    return
                }
                self.cosmeChoice["\(cosmeTypeName)"] = cosmeArray2!
                print(self.cosmeChoice)
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            self.typeChoice.append(cosmeTypeName)
            print(self.typeChoice)
        }
    }
    
    func delete(cosmeTypeName:String){
        cosmeChoice["\(cosmeTypeName)"]  = [String]()
        if let arrayInt = self.typeChoice.firstIndex(of: cosmeTypeName){
            self.typeChoice.remove(at: arrayInt)
        }
        print(self.typeChoice)
    }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cosmeTypes.count
    }

    // There is just one row in every section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cosmeTypeTable.dequeueReusableCell(withIdentifier: "cosmeTypeCell") as! CosmeTypeTableCell
        
        
        cell.cosmeType.text = cosmeTypes[indexPath.section]
        cell.name = "\(cosmeTypes[indexPath.section])"
        cell.userId = userId
        cell.tag = indexPath.section //※rowを保存
        return cell
    }
       
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = cosmeTypeTable.dequeueReusableCell(withIdentifier: "cosmeTypeCell") as! CosmeTypeTableCell
        if(cell.mySwitch.isOn){
            let Edit = self.storyboard?.instantiateViewController(withIdentifier: "Edit")as! EditViewController
            cosmeType = "\(cosmeTypes[indexPath.section])"
            Edit.cosmeType = "\(cosmeTypes[indexPath.section])"
            Edit.userId = userId
            let dispatchGroup = DispatchGroup()
            let dispatchQueue = DispatchQueue(label: "queue", attributes: .concurrent)
            dispatchGroup.enter()
            dispatchQueue.async {
                self.GET(cosmeType: self.cosmeType){ cosmeArray1, error in
                    guard cosmeArray1 != nil else {
                        self.cosmeArray = [Cosmes(name: "Name", brand: "Brand", color: "Color")]
                        return
                    }
                    self.cosmeArray = cosmeArray1!
                    dispatchGroup.leave()
                }
                self.GetId(cosmeType: self.cosmeType,userId:self.userId){cosmeArray2, error in
                    guard cosmeArray2 != nil else {
                        self.cosmeArray = [Cosmes(name: "Name", brand: "Brand", color: "Color")]
                        return
                    }
                    self.cosmeChoice["\(self.cosmeType)"] = cosmeArray2!
                    print(self.cosmeChoice)
                    dispatchGroup.leave()
                }
            }
            dispatchGroup.notify(queue: .main) {
                Edit.cosmeArray = self.cosmeArray
                print("choice",self.cosmeChoice)
                self.present(Edit, animated: true, completion: nil)
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let tableHeghit = Int(self.cosmeTypeTable.frame.height)/cosmeTypes.count
//        return CGFloat(tableHeghit)
        return CGFloat(40)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
}



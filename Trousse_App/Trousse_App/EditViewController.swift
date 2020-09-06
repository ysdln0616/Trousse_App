//
//  EditViewController.swift
//  Trousse_App
//
//  Created by 吉田琉夏 on 2020/07/23.
//  Copyright © 2020 吉田琉夏. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class EditViewController: UIViewController{
   
    @IBOutlet weak var cosmeCollection: UICollectionView!
    @IBOutlet weak var cosmeTypeLabel: UILabel!
    
    var cosmeType:String = ""
    var userId:String = ""
    var cosmeArray = [Cosmes]()
    var cellWidth : Int = 0
    var cosmeId:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cosmeTypeLabel.text = cosmeType
        cosmeCollection.dataSource = self
        cosmeCollection.delegate = self
        cellWidth = (Int(self.view.frame.width)-40-48)/2
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        cosmeCollection.collectionViewLayout = layout
    }
    
    func GetId(cosme:Cosmes,cosmeType:String,userId:String,completion: @escaping (String?, Error?) -> Void){
        var EditCosmeId : String = ""
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
                        if(document.data()["name"] as! String == cosme.name &&
                            document.data()["brand"] as! String == cosme.brand &&
                            document.data()["color"] as! String == cosme.color ){
                            print("\(document.documentID)")
                            EditCosmeId = "\(document.documentID)"
                        }
                    }
                }
                dispatchGroup.leave()
            }
            dispatchGroup.notify(queue: .main) {
                completion(EditCosmeId, nil)
            }
        }
    }
    func search(){
        for cell in cosmeCollection.visibleCells as [UICollectionViewCell] {
            // do something
        }
        let cells = CosmeCollectionCell.self as! Array<UICollectionViewCell>

        for cell in cells {
            // look at data
        }
    }
    
    @IBAction func Dismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func moveAddView(_ sender: UIButton) {
        let Add = self.storyboard?.instantiateViewController(withIdentifier: "Add")as!  AddViewController
        Add.cosmeType = self.cosmeType
        Add.userId = self.userId
        self.present(Add, animated: true, completion: nil)
    }
}

extension EditViewController:UICollectionViewDataSource, UICollectionViewDelegate  {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cosmeArray.count
    }
            
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cosmeCollection.dequeueReusableCell(withReuseIdentifier: "cosmes", for: indexPath) as! CosmeCollectionCell
        cell.setupCell(cosmes: cosmeArray[indexPath.row])
        cell.tag = indexPath.row //※rowを保存
        cell.cosmeSwitch.isOn = true
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath){
        let Update = self.storyboard?.instantiateViewController(withIdentifier: "Update")as!  UpdateCosmeViewController
        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "queue", attributes: .concurrent)
        dispatchGroup.enter()
        dispatchQueue.async {
            self.GetId(cosme:self.cosmeArray[indexPath.row],cosmeType: self.cosmeType, userId: self.userId){ cosmeArray1, error in
                guard cosmeArray1 != nil else {
                    print("error")
                    return
                }
                Update.cosmeId = cosmeArray1!
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            Update.index = indexPath.row
            Update.cosmeType = self.cosmeType
            Update.userId = self.userId
            Update.cosmeInfo = self.cosmeArray[indexPath.row]
            self.present(Update, animated: true, completion: nil)
        }
    }
}


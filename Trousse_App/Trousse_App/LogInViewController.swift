//
//  LogInViewController.swift
//  Trousse_App
//
//  Created by 吉田琉夏 on 2020/07/18.
//  Copyright © 2020 吉田琉夏. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController:UIViewController,GIDSignInDelegate{
    @IBOutlet weak var nameLog: UILabel!
    @IBOutlet weak var button: GIDSignInButton!
    
    
    override func viewDidLoad() {        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        nameLog.text = "Googleアカウントでログインしてください"
    }
    
    @IBAction func tap(_ sender: Any) {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    func moveMain(UserId:String){
        let Main = self.storyboard?.instantiateViewController(withIdentifier: "Main") as! ViewController
        Main.userName = self.nameLog.text!
        Main.userId = UserId
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // 0.5秒後に実行したい処理
            self.present(Main, animated: true, completion: nil)
        }
        
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
          if (error as NSError).code == GIDSignInErrorCode.hasNoAuthInKeychain.rawValue {
            print("The user has not signed in before or they have since signed out.")
          } else {
            print("\(error.localizedDescription)")
          }
          return
        }
        // Perform any operations on signed in user here.
        let userId = user.userID                  // For client-side use only!
        let idToken = user.authentication.idToken // Safe to send to the server
        let fullName = user.profile.name
//        let givenName = user.profile.givenName
//        let familyName = user.profile.familyName
        let email = user.profile.email
        // ...
        self.nameLog.text = "こんにちは \(fullName!) さん"
        print(userId!)
        moveMain(UserId:userId!)
    }

    //追記部分(デリゲートメソッド)エラー来た時
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        print(error.localizedDescription)
    }
}

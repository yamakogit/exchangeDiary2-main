//
//  SignupViewController.swift
//  exchangeDiary
//
//  Created by 山田航輝 on 2024/05/29.
//

import UIKit
import Firebase
import FirebaseFirestore

class groupManagerVC: UIViewController, UITextFieldDelegate {
    
//    @IBOutlet var textField2: UITextField!
    
    var groupID: String = ""
    var userName: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

//        textField2.delegate = self
//        textField2.addTarget(self, action: #selector(groupManagerVC.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        // Do any additional setup after loading the view.
    }
    
    
    //該当groupData取得・gUIDの取り出し・
    @IBAction func register() {
        
        if groupID == "" {
            OtherHosts.alertDef(view: self, title: "エラー", message: "groupIDが入力されていません")
        } else {
            
            
            Task {
                do {
                     var groupData = try await FirebaseClient.shared.searchGroup(groupID: self.groupID)
                    
                    if groupData == nil {
                        //該当データなし
                        OtherHosts.alertDef(view: self, title: "エラー", message: "入力されたグループは存在しません")
                    } else {
                        //該当データあり
                        //UserData取得・gUIDの書き込み・userData保存
                        var userData = try await FirebaseClient.shared.getUserData()
                        userData.groupUID = groupData?.id ?? ""
                        try await FirebaseClient.shared.saveNewData(userData: userData)
                        performSegue(withIdentifier: "goNext", sender: self)
                    }
                } catch {
                    print("Error: ")
                }
            }
            
        }
        
    }
    
    
    @IBAction func createNewGroup() {
        
        let groupIDNumber: Int = Int.random(in: 100000...999999)
        
        let groupIDLetterArray = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
        let groupIDLetter1 = groupIDLetterArray [Int.random(in: 0...51)]
        let groupIDLetter2 = groupIDLetterArray [Int.random(in: 0...51)]
        
        let groupID = "\(groupIDLetter1)\(groupIDLetter2)\(groupIDNumber)"
     
        let groupData = FirebaseClient.GroupDataset(groupID: groupID, latestDate: "", latestOpenedUUID: "")
        let userData = FirebaseClient.UserDataSet(name: userName, iconURL: "", groupUID: "", latestDate: "", diary: [[:]])
        
        Task {
            do {
                try await FirebaseClient.shared.saveNewData(userData: userData, groupData: groupData)
                //完了後
                performSegue(withIdentifier: "goNext", sender: self)
            } catch {
                print("Error: ")
            }
        }
        
        
        
    }
    
//    
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField2.resignFirstResponder() //キーボードを閉じる
//        return true
//    }
//    
//    
//    @objc func textFieldDidChange(_ textField: UITextField) {
//        groupID = textField2.text!
//        print("groupID: \(groupID)")
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

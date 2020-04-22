//
//  inputViewController.swift
//  taskapp
//
//  Created by 畑中 彩里 on 2020/04/19.
//  Copyright © 2020 sari.hatanaka. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

class inputViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryTextField: UITextField!
    
    
    
    let realm = try! Realm()
    var task: Task!
    var category: Task!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // 背景をタップしたらdismissKeyboardメソッドを呼ぶように設定する（キーボードを閉じる）
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector (dismissKeyboard))
        //  viewにインスタンスを追加
        self.view.addGestureRecognizer(tapGesture)
        
        titleTextField.text = task.title
        contentsTextView.text = task.contents
        datePicker.date = task.date
        categoryTextField.text = task.category
        // Do any additional setup after loading the view.
    }
    
    
    
    /// 更新して保存
      override func viewWillDisappear(_ animated: Bool) {
        try! realm.write {
            self.task.title = self.titleTextField.text!
            self.task.contents = self.contentsTextView.text
            self.task.date = self.datePicker.date
            self.task.category = self.categoryTextField.text!
            self.realm.add(self.task, update: .modified)
        }
        setNotification(task: task)
        
        super.viewWillDisappear(animated)
    }
    
    
   
        
    
    
    
//    タスクのローカル通知を登録する
    func setNotification(task: Task) {
        let content = UNMutableNotificationContent()
        
        if task.title == "" {
            content.title = "(タイトルなし)"
        } else {
            content.title = task.title
        }
        if task.contents == "" {
            content.body = "(内容なし)"
        }else {
            content.body = task.contents
        }
        content.sound = UNNotificationSound.default
        
//        ローカル通知が発動するtrigger(日付マッチ)を作成
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: task.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
//      identifier,content, triggerからローカル通知を作成
        let request = UNNotificationRequest(identifier: String(task.id), content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            print(error ?? "ローカル通知登録　OK")
//   error が nil ならローカル通知の登録に成功したと表示。errorが存在すればerrorを表示。
        }
        
        center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
            for request in requests {
            print("/---------------")
            print(request)
            print("---------------/")
        
            }
        }
    }
    
    @objc func dismissKeyboard(){
//         キーボードを閉じる
           view.endEditing(true)

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
}

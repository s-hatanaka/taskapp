//
//  ViewController.swift
//  taskapp
//
//  Created by 畑中 彩里 on 2020/04/19.
//  Copyright © 2020 sari.hatanaka. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    
    let realm = try! Realm()

  

    
//　　 DB内のタスクが格納されるリスト
//    日付の近い順でソート：昇順
//    以降内容をアップデートするとリスト内は自動的に更新される
    var taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date",
    ascending: true)
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        tableView.delegate = self
        tableView.dataSource = self
    
    
        searchBar.delegate = self
       
        
    }
    
    
    /// segueで画面遷移する時に呼ばれる
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let inputViewController:inputViewController = segue.destination as! inputViewController
     
        if segue.identifier == "cellSegue" {
            let indexPath = self.tableView.indexPathForSelectedRow
            inputViewController.task = taskArray[indexPath!.row]
        } else {
            let task = Task()
            
            let allTasks = realm.objects(Task.self)
            if allTasks.count != 0 {
                task.id = allTasks.max(ofProperty: "id")! + 1
            }
           
            inputViewController.task = task
        }
    }
  
    
    /// 入力から戻ってきた時にTableViewを更新させる
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    

   
    
    
    
    
    
    /// セルの数を返すメソッド
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return taskArray.count
          
    }
    
    
    /// 各セルの内容を返すメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 再利用可能な cell を得る
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let task = taskArray[indexPath.row]
        cell.textLabel?.text =  task.title
        
        let  formatter = DateFormatter()
        formatter.dateFormat = "yyy-MM-dd HH:mm"
        
        let  dateString:String = formatter.string(from: task.date)
        cell.detailTextLabel?.text = dateString
        
        return cell
    }

    
    /// 各セルを選択した時に実行されるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cellSegue",sender: nil)
        
    }
    
    
    /// セルが削除が可能な事を伝えるメソッド
    func tableView(_ tableView: UITableView, editingStyleForRowAt indxPath: IndexPath)-> UITableViewCell.EditingStyle {
        return .delete
        
    }
    
    
    /// Delete ボタンを押された時に呼ばれるメソッド
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
         
//            削除するタスクを取得する
            let task = self.taskArray[indexPath.row]
            
//            ローカル通知をキャンセルする
            let center = UNUserNotificationCenter.current()
            center.removePendingNotificationRequests(withIdentifiers: [String(task.id)])
            
//            データベースから削除する
            try! realm.write{
                self.realm.delete(self.taskArray[indexPath.row])
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            
//            未通知のローカル通知一覧をログ出力
            center.getPendingNotificationRequests { (requests: [UNNotificationRequest]) in
            for request in requests {
                print("/---------------")
                print(request)
                print("---------------/")
            }
        }
        
        
    }
    
}
    
    /// 検索ボタンがタップされた時
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        print("hoge")
      
        
        guard let inputCategoryField = searchBar.text, !inputCategoryField.isEmpty else {

           self.taskArray = try! Realm().objects(Task.self).sorted(byKeyPath: "date", ascending: true)

           tableView.reloadData()

           return

       }

       let predicate = NSPredicate(format: "category = %@", inputCategoryField)

       self.taskArray = realm.objects(Task.self).filter(predicate).sorted(byKeyPath: "category", ascending: true)

       //print(taskArray)

    
       tableView.reloadData()

        
        self.view.endEditing(true)
    
        
               
        
      
    }
    
   
    
   
}








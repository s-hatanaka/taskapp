//
//  ViewController.swift
//  taskapp
//
//  Created by 畑中 彩里 on 2020/04/19.
//  Copyright © 2020 sari.hatanaka. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dateSource = self
    
    
    }

    
    /// セルの数を返すメソッド
    func tableView(_tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 0
    }
    
    
    /// 各セルの内容を返すメソッド
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 再利用可能な cell を得る
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        return cell
    }

    
    /// 各セルを選択した時に実行されるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "cellSegue", sender: nil)
        
    }
    
    
    /// セルが削除が可能な事を伝えるメソッド
    func tableView(_ tableView: UITableView, editingStyleForRowAt indxPath: IndexPath)-> UITableViewCell.EditingStyle {
        return .delete
        
    }
    
    
    /// Delete ボタンを押された時に呼ばれるメソッド
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
}

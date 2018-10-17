//
//  SecondViewController.swift
//  gitchat-app_im
//
//  Created by xianlong on 2018/10/16.
//  Copyright © 2018 my git chat. All rights reserved.
//

import UIKit

class ContactVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tableView = UITableView()

    var list: [NIMUser]?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.view.addSubview(self.tableView)
        self.tableView.frame = self.view.frame

        self.loadData()
        let btnOpenContact = UIBarButtonItem(title: "添加新朋友", style: .plain, target: self, action: #selector(self.btnAddFriendClick(sender:)))
        self.navigationItem.rightBarButtonItem = btnOpenContact
    }
    
    func loadData(){
        self.list = NIMSDK.shared().userManager.myFriends()
        self.tableView.reloadData()
    }
    
    @objc func btnAddFriendClick(sender: UIBarButtonItem){
       let alertVC = UIAlertController(title: "添加新朋友", message: nil, preferredStyle: .alert)
        alertVC.addTextField { (text) in
            text.placeholder = "请输入要添加的用户id"
        }
        
        
        let confirm = UIAlertAction(title: "确定", style: .default) { (action) in
            guard let userId = alertVC.textFields?.first?.text, userId != "" else{
                self.view.makeToast("请输入用户id")
                return
            }
            
            let request = NIMUserRequest()
            request.userId = userId
            request.operation = NIMUserOperation.add
            request.message = "求通过哟"
            
            NIMSDK.shared().userManager.requestFriend(request, completion: { (error) in
                if error != nil {
                   self.view.makeToast(error?.localizedDescription)
                    return
                }
                
                self.view.makeToast("您已添加\(userId)为好友，现在可以开始和TA聊天啦")
                self.loadData()
            })

        }
        
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        
        alertVC.addAction(confirm)
        alertVC.addAction(cancel)
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellId = "userCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? UserItemCell
        if cell == nil {
            tableView.register(UserItemCell.classForCoder(), forCellReuseIdentifier: cellId)
            cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? UserItemCell
        }
        
        cell?.model = self.list?[indexPath.row]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let userId = self.list?[indexPath.row].userId{
            let session = NIMSession(userId, type: .P2P)
            let sessionVC = NIMSessionViewController(session: session)
            self.navigationController?.pushViewController(sessionVC!, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if let userId = self.list?[indexPath.row].userId{
                NIMSDK.shared().userManager.deleteFriend(userId) { (error) in
                    if error != nil {
                        self.view.makeToast(error?.localizedDescription)
                        return
                    }
                    
                    self.view.makeToast("您已删除与\(userId)的好友关系")
                    self.loadData()
                }
            }
        }
    }
    
}





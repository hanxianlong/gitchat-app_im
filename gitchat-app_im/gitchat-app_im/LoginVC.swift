//
//  FirstViewController.swift
//  gitchat-app_im
//
//  Created by xianlong on 2018/10/16.
//  Copyright © 2018 my git chat. All rights reserved.
//

import UIKit
import Alamofire

class LoginVC: UIViewController {

    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    lazy var subVC = NIMSessionListViewController()
    
    let defaultUserId = "xiaowang"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "IM"
        self.navigationItem.title = "30分钟添加IM功能演示"
    }
    
    @objc func btnOpenContactClick(sender: UIBarButtonItem){
        let contact = ContactVC()
        contact.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(contact, animated: true)
    }

    @IBAction func btnLoginClick(_ sender: Any) {
        guard let userName = txtUserName.text, let password = txtPassword.text, userName != "" && password != "" else{
            return
        }
        
        NIMSDK.shared().loginManager.login(userName, token: password) { (error) in
            if error != nil {
               self.view.makeToast(error?.localizedDescription)
                return
            }
            
            //展示最近会话列表
            self.addChild(self.subVC)
            self.view.addSubview(self.subVC.view)
            self.subVC.view.frame = self.view.frame
            
            //如果和t1不是好友，为演示自动添加为好友
            if !NIMSDK.shared().userManager.isMyFriend(self.defaultUserId){
                if userName != self.defaultUserId{
                    self.addDefaultFriend()
                }
            }

            let btnOpenContact = UIBarButtonItem(title: "通讯录", style: .plain, target: self, action: #selector(self.btnOpenContactClick(sender:)))
            self.navigationItem.rightBarButtonItem = btnOpenContact
            
            let btnLogout = UIBarButtonItem(title: "退出", style: .plain, target: self, action: #selector(self.btnLogoutClick(sender:)))
            self.navigationItem.leftBarButtonItem = btnLogout
        }
    }
    
    @objc func btnLogoutClick(sender: UIBarButtonItem){
        NIMSDK.shared().loginManager.logout { (error) in
            self.subVC.removeFromParent()
            self.subVC.view.removeFromSuperview()
            
            self.navigationItem.leftBarButtonItem = nil
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    func addDefaultFriend(){
        let friendRequest = NIMUserRequest()
        friendRequest.userId = defaultUserId;
        friendRequest.message = "我们俩加好友哦~~"
        friendRequest.operation = NIMUserOperation.add
        NIMSDK.shared().userManager.requestFriend(friendRequest, completion: { (error) in
            if error != nil{
                self.view.makeToast(error?.localizedDescription)
                return
            }
            
            self.view.makeToast("操作成功,系统已自动添加\(self.defaultUserId)为好友, 您可以在通讯录中找到他并和他聊天", duration: 3, position: CSToastPositionCenter)
        })
    }
    
    
    @IBAction func btnRegisterClick(_ sender: Any) {
        //此处应该调用服务端接口，完成IM 用户的注册
        //为了演示，此处在app端直接调用server端的接口
        guard let userName = txtUserName.text, let password = txtPassword.text, userName != "" && password != "" else{
            return
        }

        let params = ["accid": userName, "token":password];
        let _ = NetworkTool.post(Config.apiCreatUser, parameters: params) { (isOK, msg, data) in
            if !isOK {
                self.view.makeToast(msg, duration: 3, position: CSToastPositionCenter)
                return
            }
            else{
                //注册成功后即调用登录
                self.btnLoginClick(sender)
            }
        }
    }
}


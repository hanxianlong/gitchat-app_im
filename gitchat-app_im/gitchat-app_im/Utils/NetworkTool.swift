//
//  NetworkTool.swift
//  gitchat-app_im
//
//  Created by xianlong on 2018/10/17.
//  Copyright © 2018 my git chat. All rights reserved.
//

import UIKit
import Alamofire



class NetworkTool: NSObject {
    typealias NetworkFinished = (_ success: Bool,_ msg: String?,_ result: NSDictionary?) -> ()

    /**
     POST请求
     
     - parameter URLString:  urlString
     - parameter parameters: 参数
     - parameter finished:   完成回调
     */
    class func post(_ url: String, parameters: [String : Any]?, finished: @escaping NetworkFinished) {
        let headers = genHeaders()
        
        let req = request(url, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: headers)
            .responseString(completionHandler: { (response) in
                let result = response.result as Result<String>
                if result.isSuccess{
                    let jsonData:Data? = result.value?.data(using: .utf8)
                    if let dict = try? JSONSerialization.jsonObject(with: jsonData!, options: .mutableContainers) as? NSDictionary{
                        if let code = dict?.value(forKey: "code") as? Int, code == 200{
                            finished(true,nil,dict)
                        }
                        else{
                            finished(false, dict?.value(forKey: "desc") as? String, dict)
                        }

                        return
                    }
                }
                finished(false, "请求失败", nil)
        })
        
        debugPrint(req)
    }

    class func genHeaders() -> [String:String] {
        /**
 AppKey    开发者平台分配的appkey
 Nonce    随机数（最大长度128个字符）
 CurTime    当前UTC时间戳，从1970年1月1日0点0 分0 秒开始到现在的秒数(String)
 CheckSum    SHA1(AppSecret + Nonce + CurTime)，三个参数拼接的字符串，进行SHA1哈希计算，转化成16进制字符(String，小写)
         */
        let appKey = Config.appKey
        let nonce = "\(arc4random())"
        let curtime = "\(Date().timeIntervalSince1970)"
        let appSecret = Config.appSecret
        let checksum = "\(appSecret + nonce + curtime)".sha1().lowercased()
        
        let headers = [
            "AppKey": appKey,
            "CurTime": curtime,
            "Nonce": nonce,
            "CheckSum": checksum,
        ]
        return headers
    }
}

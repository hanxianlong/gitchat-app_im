//
//  String+Extension.swift
//  gitchat-app_im
//
//  Created by xianlong on 2018/10/17.
//  Copyright © 2018 my git chat. All rights reserved.
//

import UIKit

extension String {
    //MARK: - sha1 加密
    func sha1() -> String {
        //UnsafeRawPointer
        let data = self.data(using: String.Encoding.utf8)!
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
        
        let newData = NSData.init(data: data)
        CC_SHA1(newData.bytes, CC_LONG(data.count), &digest)
        let output = NSMutableString(capacity: Int(CC_SHA1_DIGEST_LENGTH))
        for byte in digest {
            output.appendFormat("%02x", byte)
        }
        return output as String
    }
}

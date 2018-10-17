//
//  UserItemCellTableViewCell.swift
//  gitchat-app_im
//
//  Created by xianlong on 2018/10/17.
//  Copyright © 2018 my git chat. All rights reserved.
//

import UIKit

class UserItemCell: UITableViewCell {
    
    var model: NIMUser?{
        didSet{
            self.textLabel?.text = model?.userId
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

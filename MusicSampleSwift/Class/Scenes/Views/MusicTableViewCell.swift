//
//  MusicTableViewCell.swift
//  MusicSampleSwift
//
//  Created by lanou3g on 15/10/17.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

import UIKit

class MusicTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var singleLabel: UILabel!
    
    //根据model进行赋值
    func setValueTOCellWithModel(model:MusicModel) ->Void
    {
        self.imgView.sd_setImageWithURL(NSURL(string: model.picUrl!), placeholderImage:UIImage(named: ""))
        self.nameLabel.text = model.name
        self.singleLabel.text = model.singer
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

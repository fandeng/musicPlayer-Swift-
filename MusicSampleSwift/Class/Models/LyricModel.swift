//
//  LyricModel.swift
//  MusicSampleSwift
//
//  Created by lanou3g on 15/10/17.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

import UIKit

class LyricModel: NSObject {

    var lyricTime:String!
    var lyricStr:String?
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    init(time:String,lyricString:String)
    {
        self.lyricStr = lyricString
        self.lyricTime = time
    }
}

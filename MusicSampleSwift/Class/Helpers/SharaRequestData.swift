//
//  SharaRequestData.swift
//  MusicSampleSwift
//
//  Created by lanou3g on 15/10/17.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

import UIKit

@objc protocol SharaRequestDataDelegate: NSObjectProtocol
{
   func sharaRequestDataUpdataUI()
}

class SharaRequestData: NSObject {

    internal static let singleton:SharaRequestData = SharaRequestData()
    
    var allMusicArray = NSMutableArray()
    
    var delegate:SharaRequestDataDelegate?
    
    //请求数据
    func requestDataWithUrl(musicUrl:String,toView:UIView) {
        MBProgressHUD.showMessage("正在加载", toView: toView)
        
        dispatch_async(dispatch_get_global_queue(0, 0), { () -> Void in
            
            let url = NSURL(string: musicUrl)
           
            let array = NSMutableArray(contentsOfURL: url!)
            
            for item1 in array! {
                let music = MusicModel()
                music.setValuesForKeysWithDictionary(item1 as! [String:AnyObject])
                
                self.allMusicArray.addObject(music)
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.delegate?.sharaRequestDataUpdataUI()
                MBProgressHUD.hideHUDForView(toView, animated: true)
            });
        });
    }
    //通过下标返回model
    func getModelWithIndex (index:NSInteger) ->(MusicModel)
    {
        return self.allMusicArray[index] as! (MusicModel)
    }
}

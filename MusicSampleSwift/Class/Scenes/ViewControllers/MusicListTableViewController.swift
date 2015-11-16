//
//  MusicListTableViewController.swift
//  MusicSampleSwift
//
//  Created by lanou3g on 15/10/17.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

import UIKit

class MusicListTableViewController: UITableViewController, SharaRequestDataDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //注册自定义cell
        self.tableView.registerNib(UINib.init(nibName: "MusicTableViewCell", bundle: nil), forCellReuseIdentifier: "cell_id")
    
        //请求数据
        SharaRequestData.singleton.requestDataWithUrl(kUrls, toView: self.view)
        
        //绑定代理
        SharaRequestData.singleton.delegate = self;
    }
    //没有实现协议方法，引入协议，会报错
    func sharaRequestDataUpdataUI() {
        
       self.tableView.reloadData()
    }
    //设置分区
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    //返回行数
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return SharaRequestData.singleton.allMusicArray.count
    }
    //设置行高
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 100.0
    }
    //设置cell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : MusicTableViewCell = tableView.dequeueReusableCellWithIdentifier("cell_id", forIndexPath: indexPath)as! MusicTableViewCell

        cell.setValueTOCellWithModel(SharaRequestData.singleton.getModelWithIndex(indexPath.row))
        
        return cell
    }
    //点击cell事件
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let playMusicVC = PlayMusicViewController.sharedManager
        
        playMusicVC.indexRow = indexPath.row
        
        self.navigationController?.pushViewController(playMusicVC, animated: true)
    }
    

}

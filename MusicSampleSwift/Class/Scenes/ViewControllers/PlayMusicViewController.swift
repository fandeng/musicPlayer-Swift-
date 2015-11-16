//
//  PlayMusicViewController.swift
//  MusicSampleSwift
//
//  Created by lanou3g on 15/10/17.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

import UIKit

class PlayMusicViewController: UIViewController,PlayManagerDelegate,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var currentLabel: UILabel!//当前时间
    @IBOutlet weak var musicSlider: UISlider!//进度条
    @IBOutlet weak var totalLable: UILabel!//总时间
    @IBOutlet weak var musicImgView: UIImageView!//音乐图片
    @IBOutlet weak var lyricTableView: UITableView!//歌词tableView
    
    var indexRow: Int!//存放上个页面的值
    var tempIndex: Int!//临时存放
    var musicModel:MusicModel!//存放音乐的Model
    
    //单例
    internal static let  sharedManager:PlayMusicViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("playMusic_id")as! PlayMusicViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tempIndex = -1
        PlayManager.singleton.delegate = self
        self.automaticallyAdjustsScrollViewInsets = false
        self.lyricTableView.dataSource = self
        self.lyricTableView.delegate = self;
    }
    
    //页面即将进入的时候
    override func viewWillAppear(animated: Bool) {
        if self.tempIndex == self.indexRow{
            return
        }
        self.playMusic()
    }
    
    //播放音乐
    func playMusic () ->Void{
        self.tempIndex = self.indexRow
        
        //通过下标获取model
        self.musicModel = (SharaRequestData.singleton.getModelWithIndex(self.indexRow))
        //根据URL播放音乐
        PlayManager.singleton.preparePlayMusicWithUrl(musicModel.mp3Url!)
        //显示音乐图片
        self.musicImgView.layoutIfNeeded()
        self.musicImgView.sd_setImageWithURL(NSURL.init(string: musicModel.picUrl!), placeholderImage: UIImage.init(named: "12"))
    }
    
    //上一首
    @IBAction func lastAction(sender: UIButton) {
        
        self.lastMusic()
    }
    
    //播放/暂停按钮
    @IBAction func pauseAction(sender: UIButton) {
        //判断是暂停还是播放
        if sender.selected
        {
            sender.selected = !sender.selected
            sender.setTitle("暂停", forState: UIControlState.Normal)
            PlayManager.singleton.playMusic()
        }else{
            sender.selected = !sender.selected
            sender.setTitle("播放", forState: UIControlState.Normal)
            PlayManager.singleton.pauseMusic()
        }
    }
    //下一首
    @IBAction func nextAction(sender: UIButton) {
        
        self.nextMusic()
    }
   
    //音乐播放结束之后
    func playerManagerMusicPlayToEnd() {
        
        self.nextMusic()
    }
    
    //下一首方法
    func nextMusic() ->Void
    {
        let row = SharaRequestData.singleton.allMusicArray.count - 1
        
        if self.indexRow < row {
            self.indexRow = self.indexRow + 1
        }else {
            self.indexRow = 0
        }
        self.playMusic()
    }
    
    //上一首方法
    func lastMusic() ->Void
    {
        if self.indexRow > 0 {
            self.indexRow = self.indexRow - 1
        } else {
            let row = SharaRequestData.singleton.allMusicArray.count
            
            self.indexRow = row - 1
        }
        self.playMusic()
    }
    
    //监听播放进度代理
    func playerMusicWithCurrentTime(curentTime: String, totaTime: String, progress: Float) {
        
        self.currentLabel.text = curentTime
        self.totalLable.text = totaTime
        self.musicSlider.value = progress
        
        let index = PlayManager.singleton.byCurrentTimeFetchIndex(curentTime)
        if index == -1{
            return;
        }
        self.lyricTableView.selectRowAtIndexPath(NSIndexPath.init(forRow: index, inSection: 0), animated: true, scrollPosition: UITableViewScrollPosition.Middle)
    }
    
    //滑动滑竿事件
    @IBAction func sliderAction(sender: UISlider) {
        
        PlayManager.singleton.bySliderValueChangeProgress(sender.value)
    }
    
    //tableView协议方法
    //区数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    //行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return PlayManager.singleton.byLyricCutTimeAndLyricStr(self.musicModel.lyric!).count;
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("tableView_cell")
        
       let model = PlayManager.singleton.byLyricCutTimeAndLyricStr(self.musicModel.lyric!)[indexPath.row] as? LyricModel
        
        cell?.textLabel?.text = model?.lyricStr!
        
        cell?.textLabel?.textAlignment = NSTextAlignment.Center
        
        cell?.textLabel?.highlightedTextColor = UIColor.orangeColor()
        
        return (cell)!
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

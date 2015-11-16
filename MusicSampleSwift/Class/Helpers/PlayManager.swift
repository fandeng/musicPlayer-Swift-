//
//  PlayManager.swift
//  MusicSampleSwift
//
//  Created by lanou3g on 15/10/17.
//  Copyright © 2015年 lanou3g. All rights reserved.
//

import UIKit
import AVFoundation

extension Int64 {
    func format(f:String) -> String {
        return NSString(format: "%\(f)f", self) as String
    }
}

@objc protocol PlayManagerDelegate:NSObjectProtocol
{
    //音乐播放结束代理
    func playerManagerMusicPlayToEnd() ->Void
    //音乐播放进度,播放总时间等代理
    func playerMusicWithCurrentTime(curentTime:String,totaTime:String,progress:Float) ->Void
}

class PlayManager: NSObject {

    internal static let singleton:PlayManager = PlayManager()
    
    //初始化AvPlayer
    var player: AVPlayer?
    //声明代理
    var delegate:PlayManagerDelegate?
    //定时器
    var timer:NSTimer?
    //存放歌词Model的数组
    var allLyricArray:NSMutableArray = NSMutableArray()
    
    
    //重写父类init方法
    override init() {
        super.init()
        //初始化Avplayer
        self.player = AVPlayer.init()
        //监听播放结束
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "playMusicToEnd", name: AVPlayerItemDidPlayToEndTimeNotification, object: nil)
    }
    
    //根据Url播放音乐
    func preparePlayMusicWithUrl(musicUrl : String) ->Void
    {
        //判断是否有item在播放
        if self.player?.currentItem != nil
        {
            //如果有,先移出原来观察的对象
            self.player?.currentItem?.removeObserver(self, forKeyPath: "status",context:nil)
        }
        //初始化item给一个Url
        let item = AVPlayerItem.init(URL: NSURL(string: musicUrl)!)
        //添加观察者
        item.addObserver(self, forKeyPath: "status", options: NSKeyValueObservingOptions.New, context: nil)
        //替换播放item
        self.player?.replaceCurrentItemWithPlayerItem(item)
    }
    
    //音乐播放结束监听
    func playMusicToEnd() ->Void{
        self.delegate?.playerManagerMusicPlayToEnd()
    }
    
    //播放音乐
    func playMusic() ->Void
    {
        self.player?.play()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.9, target: self, selector: "monitorPlayMusic", userInfo: nil
            , repeats: true)
    }
    
    //暂停音乐
    func pauseMusic() ->Void
    {
        self.player?.pause()
        self.timer?.invalidate()
        self.timer = nil
    }
    
    //观察者:观察播放的属性(未知,可以播放,播放失败)
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        //播放音乐
        self.playMusic()
    }
    
    //一直监听音乐播放
    func monitorPlayMusic() ->Void
    {
        self.delegate?.playerMusicWithCurrentTime(self.secondChangeString(self.fetchCurrentTimeValue()), totaTime: self.secondChangeString(self.fetchTotalTimeValue()), progress: self.fetchProgressValue())
    }
    
    //获取播放音乐当前时间
    func fetchCurrentTimeValue() ->Int64
    {
        let time: CMTime = (self.player?.currentTime())!
        
        if time.timescale == 0 {
            return 0
        }else{
            return Int64(time.value) / Int64(time.timescale)
        }
    }
    
    //获取音乐总时间
    func fetchTotalTimeValue() ->Int64
    {
        let time:CMTime = (self.player?.currentItem?.duration)!
        
        if time.timescale == 0 {
            return 0
        }else{
            return Int64(time.value) / Int64(time.timescale)
        }
    }
    
    //获取进度
    func fetchProgressValue() ->Float
    {
        return Float(self.fetchCurrentTimeValue()) / Float(self.fetchTotalTimeValue())
    }
    
    //把秒数转化为时间格式00:00
    func secondChangeString(time:Int64) ->String{
        let minute = time / 60
        let second = time % 60
        return NSString(format: "%.2ld:%.2ld", minute,second) as String
    }
    
    //根据滑动的进度播放音乐
    func bySliderValueChangeProgress(progress:Float) ->Void
    {
        self.pauseMusic()
        
        let totalTime = self.fetchTotalTimeValue() * 100
        let intProgress = Int64(progress * 100)
        let CurrentTime = (intProgress * totalTime) / 10000
        
        self.player?.seekToTime(CMTimeMake(CurrentTime, 1), completionHandler: { (finshed:Bool) -> Void in
            
            if finshed == true
            {
                self.playMusic()
            }
        })
    }
    
    //返回数组中存放的是歌词的Model
    func byLyricCutTimeAndLyricStr(lyric:String) ->NSMutableArray
    {
        self.allLyricArray.removeAllObjects()
        //组件分离
        let contentArray = lyric.componentsSeparatedByString("\n")
        for contentStr in contentArray
        {
            //存放每段歌词的数组
            let tempArray = contentStr.componentsSeparatedByString("]")
            //安全判断，保证first里面有值
            if tempArray.first!.characters.count < 1 {
                break
            }
            //截取时间_1
            let str1 = (tempArray.first! as NSString).substringFromIndex(1)
            //截取时间_2
            let array = (str1 as NSString).componentsSeparatedByString(".")
            //将截取好的歌词和时间放到歌词model
            let lyric = LyricModel.init(time: array.first!, lyricString: tempArray.last!)
            
            [self.allLyricArray.addObject(lyric)]
        }
        
        return self.allLyricArray
    }
    //很据当前播放时间获取下标
    func byCurrentTimeFetchIndex(time:String) ->Int
    {
        var index = -1
        for var i = 0; i < self.allLyricArray.count-1;i++ {
            
            let lyric = self.allLyricArray[i] as! LyricModel
            if lyric.lyricTime == time {
                    
                index = i
            }
        }
        return index
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

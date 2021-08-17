//
//  Souns.swift
//  QRアプリtest
//
//  Created by 蘭搏 on 2021/07/12.
//

import Foundation
import AVFoundation

//QRスキャンを行う時、Response結果によって、音出すモデルを定義する。
class Sounds {
    
    var soundIdRingOK: SystemSoundID
    var soundIdRingNG: SystemSoundID

    //初期値設定
    init() {
        self.soundIdRingOK = 0
        self.soundIdRingNG = 1
        
        reInit()
    }

    //音を呼び出す
    func stop() {
        //システムサウンドID"0"と”１”を設定する。
        AudioServicesDisposeSystemSoundID(soundIdRingOK)
        AudioServicesDisposeSystemSoundID(soundIdRingNG)
        reInit() //必要
    }
    
    //システムサウンドIDの音を設定する。
    func reInit() {
        //システムIDは"0"の場合、音は"ticket_ok.mp3"
        if let soundUrl:NSURL = NSURL(fileURLWithPath:
                                        Bundle.main.path(forResource: "ticket_ok", ofType:"mp3")!) as NSURL?{
            AudioServicesCreateSystemSoundID(soundUrl, &soundIdRingOK)
            
        }
        //システムIDは"1"の場合、音は"ticket_ng.mp3"
        if let soundUrl:NSURL = NSURL(fileURLWithPath:
                                        Bundle.main.path(forResource: "ticket_ng", ofType:"mp3")!) as NSURL?{
            AudioServicesCreateSystemSoundID(soundUrl, &soundIdRingNG)
            
        }
    }
}

//
//  ViewController.swift
//  PlayClass
//
//  Created by Sanjana Sarkar on 5/30/17.
//  Copyright © 2017 Sanjana Sarkar. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordB: UIButton!
    @IBOutlet weak var playB: UIButton!
    var audioPlayer : AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?
    var isPlaying = false

    @IBOutlet weak var stopB: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let url = URL.init(fileURLWithPath: Bundle.main.path(
//            forResource: "music",
//            ofType: "mp3")!)
//        do {
//            try audioPlayer = AVAudioPlayer(contentsOf: url)
//            audioPlayer?.delegate = self as? AVAudioPlayerDelegate
//            audioPlayer?.prepareToPlay()
//        } catch let error as NSError {
//            print("audioPlayer error \(error.localizedDescription)")
//        }
        
        //playB.isEnabled = false
        
        let fileMgr = FileManager.default
        
        let dirPaths = fileMgr.urls(for: .documentDirectory,
                                    in: .userDomainMask)
        
        let soundFileURL = dirPaths[0].appendingPathComponent("sound.caf")
        
        let recordSettings =
            [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
             AVEncoderBitRateKey: 16,
             AVNumberOfChannelsKey: 2,
             AVSampleRateKey: 44100.0] as [String : Any]
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(
                AVAudioSessionCategoryPlayAndRecord)
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        
        do {
            try audioRecorder = AVAudioRecorder(url: soundFileURL,
                                                settings: recordSettings as [String : AnyObject])
            audioRecorder?.prepareToRecord()
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    @IBAction func playMusic(_ sender: AnyObject) {
//        var path = Bundle.main.path(forResource: "73 - Questions", ofType: "mp3")
//        if path != nil {
//            
//            var audioFileUrl = NSURL.fileURL(withPath: path!)
//            do {
//                try audioPlayer = AVAudioPlayer(contentsOf: audioFileUrl)
//            } catch is NSError {
//                
//            }
//            
//            audioPlayer.play()
//            
//        } else {
//            print("audio file is not found")
//        }
        
//        if let player = audioPlayer {
//            player.play()
//        }
        
        
        if audioRecorder?.isRecording == false {
//            stopB.isEnabled = true
//            recordB.isEnabled = false
            
            do {
                try audioPlayer = AVAudioPlayer(contentsOf:
                    (audioRecorder?.url)!)
                audioPlayer!.delegate = self as AVAudioPlayerDelegate
                audioPlayer!.prepareToPlay()
                audioPlayer!.play()
            } catch let error as NSError {
                print("audioPlayer error: \(error.localizedDescription)")
            }
        }
    }
    
    
    @IBAction func record(_ sender: Any) {
        if audioRecorder?.isRecording == false {
            //playB.isEnabled = false
            //stopB.isEnabled = true
            audioRecorder?.record()
        }
    }
    
    @IBAction func stop(_ sender: Any) {
        if audioRecorder?.isRecording == true {
            audioRecorder?.stop()
            if audioRecorder?.isRecording == false {
                do {
                    try audioPlayer = AVAudioPlayer(contentsOf:
                        (audioRecorder?.url)!)
                    audioPlayer!.delegate = self as AVAudioPlayerDelegate
                    audioPlayer!.prepareToPlay()
                    audioPlayer!.play()
                } catch let error as NSError {
                    print("audioPlayer error: \(error.localizedDescription)")
                }
            }
        } else {
            audioPlayer?.stop()
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Audio Play Decode Error")
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Audio Record Encode Error")
    }
}


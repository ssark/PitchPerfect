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
    @IBOutlet weak var stopB: UIButton!
    
    var audioPlayer : AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?
    var isPlaying = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fileMgr = FileManager.default
        
        let dirPaths = fileMgr.urls(for: .documentDirectory, in: .userDomainMask)
        
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
            try audioRecorder = AVAudioRecorder(url: soundFileURL, settings: recordSettings as [String : AnyObject])
            audioRecorder?.prepareToRecord()
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
    }
    
    
    @IBAction func playMusic(_ sender: AnyObject) {
        
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
    }
     
    @IBAction func record(_ sender: Any) {
        if audioRecorder?.isRecording == false {
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


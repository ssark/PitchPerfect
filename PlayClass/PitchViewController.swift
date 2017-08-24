//
//  PitchViewController.swift
//  PlayClass
//
//  Created by Sanjana Sarkar on 5/30/17.
//  Copyright © 2017 Sanjana Sarkar. All rights reserved.
//

import UIKit
import AVFoundation

class PitchViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {

    @IBOutlet weak var regularButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var darthVaderButton: UIButton!
    @IBOutlet weak var stopB: UIButton!
    
    var audioPlayer : AVAudioPlayer?
    var url: URL?
    var recorder: AVAudioRecorder?
    var engine: AVAudioEngine!
    var audioFile: AVAudioFile!
    var audioPlayerNode: AVAudioPlayerNode!
    
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(
                AVAudioSessionCategoryPlayAndRecord)
        } catch let error as NSError {
            print("audioSession error: \(error.localizedDescription)")
        }
        engine = AVAudioEngine()
    }
    
    @IBAction func regularButton(_ sender: UIButton) {
        do {
            try audioPlayer = AVAudioPlayer(contentsOf:
                (url)!)
            audioPlayer!.delegate = self as AVAudioPlayerDelegate
            audioPlayer!.prepareToPlay()
            audioPlayer!.play()
        } catch let error as NSError {
            print("audioPlayer error: \(error.localizedDescription)")
        }
    }
    
    @IBAction func chipmunkButton(_ sender: UIButton) {
        playSound(value: 1000, rateOrPitch: "pitch")
    }
    
    @IBAction func darthVaderButton(_ sender: UIButton) {
        playSound(value: -1000, rateOrPitch: "pitch")
    }
    
    @IBAction func stop(_ sender: Any) {
        audioPlayerNode?.stop()
    }
    
    func playSound(value: Float, rateOrPitch: String){
        audioPlayerNode = AVAudioPlayerNode()
        let changeAudioUnitTime = AVAudioUnitTimePitch()
        
        engine.attach(audioPlayerNode!)
        engine.attach(changeAudioUnitTime)
        do {
            let audioFile = try AVAudioFile(forReading: url!)

            engine.connect(audioPlayerNode!, to: changeAudioUnitTime, format: nil)
            engine.connect(changeAudioUnitTime, to: engine.mainMixerNode, format: nil)
            
            audioPlayerNode?.scheduleFile(audioFile, at: nil, completionHandler: nil)
            changeAudioUnitTime.pitch = value
            
            try engine.start()
            
            audioPlayerNode?.play()
        } catch let error as NSError {
            print("audioFile error: \(error.localizedDescription)")
        }
    }

    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Audio Play Decode Error")
    }

    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Audio Record Encode Error")
    }
}

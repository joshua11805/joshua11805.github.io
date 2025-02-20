//
//  AudioPlayerViewModel.swift
//  HealthQuest
//
//  Created by JoshuaShin on 12/3/24.
//
//using AVFoundation as my second Apple Framework
//this also follows the singleton design pattern
import AVFoundation


//needs to gather data from healthState enum to determine what track to play
class AudioPlayerViewModel: ObservableObject {
    var audioPlayer: AVAudioPlayer?

    @Published var isPlaying = false
    @Published var healthState: HealthState = .healthy{
        didSet {
            loadAudioForCurrentState()
        }
    }

    

    init() {
        loadAudioForCurrentState()
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to configure AVAudioSession: \(error.localizedDescription)")
        }
    }

    //will play a different audio depending on how healthy the user is
    //currently healthState will only be on .healthy
    func loadAudioForCurrentState() {
        var audioFileName = ""
        
        switch healthState {
        case .healthy:
            audioFileName = "MomentintheGardenV2_WIP"
        case .unhealthy:
            audioFileName = "audioV2"
        case .dying:
            audioFileName = "audioV3"
        }
        //basically searches the project for audioFilename.mp3
        //note: having the audios in a file in the project complicated things
        if let sound = Bundle.main.path(forResource: audioFileName, ofType: "mp3") {
            do {
                self.audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound))
            } catch {
                print("AVAudioPlayer could not be instantiated.")
            }
        } else {
            print("Audio file \(audioFileName).mp3 could not be found.")
        }
    }
    
    //function to play and pause the music
    func playOrPause() {
        guard let player = audioPlayer else { return }

        if player.isPlaying {
            player.pause()
            isPlaying = false
        } else {
            player.play()
            isPlaying = true
        }
    }
}


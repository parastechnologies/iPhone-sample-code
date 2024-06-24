/*
 * Copyright (c) 2013-2014 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import AVFoundation
import Accelerate
/**
 * Audio player that uses AVFoundation to play looping background music and
 * short sound effects. For when using SKActions just isn't good enough.
 */
class ProAudioPlayerHelper : NSObject {
    var isPlaying = false
    var duration = TimeInterval()
    var setUpSlider  : (()->())?
    var updateSlider : ((TimeInterval)->())?
    var updateError  : ((String)->())?
    var isPlayerFinished :((Bool)->())?
    var songURL : String
    private var isSongStarted = false
    private var player = AudioPlayer()
    private var item : AudioItem?
    init(song:String,isShortAudio:Bool) {
        songURL = song
        super.init()
        setUpAudio(song)
    }
    func setupAudioSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback, mode: .default, policy: .default, options: [.allowBluetoothA2DP,.defaultToSpeaker])
            try session.setActive(true)
        } catch {
            print(error.localizedDescription)
        }
    }
    func setUpAudio(_ songStr:String) {
        guard let url = URL(string: songStr.replacingOccurrences(of: " ", with: "%20")) else {
            print("mp3 not found")
            return
        }
        player.delegate = self
        item = AudioItem(mediumQualitySoundURL: url)
        if let it = item {
            player.play(item: it)
        }
    }
    func seekTo(time:TimeInterval) {
        if item == nil {
            setUpAudio(songURL)
        }
        player.seek(to: time)
    }
    func startPlayer() {
        isPlaying = true
        if let it = item {
            player.play(item: it)
        }
        player.playImmediately()
    }
    func stopAudioPlayer() {
        isPlaying = false
        player.stop()
    }
}
extension ProAudioPlayerHelper:AudioPlayerDelegate {
    func audioPlayer(_ audioPlayer: AudioPlayer, willStartPlaying item: AudioItem) {
        self.setUpSlider?()
    }
    func audioPlayer(_ audioPlayer: AudioPlayer, didFindDuration duration: TimeInterval, for item: AudioItem) {
        self.duration = duration
    }
    func audioPlayer(_ audioPlayer: AudioPlayer, didUpdateProgressionTo time: TimeInterval, percentageRead: Float) {
        self.updateSlider?(time)
    }
    func audioPlayer(_ audioPlayer: AudioPlayer, didChangeStateFrom from: AudioPlayerState, to state: AudioPlayerState) {
        if state == .stopped {
            isPlayerFinished?(true)
        }
    }
}

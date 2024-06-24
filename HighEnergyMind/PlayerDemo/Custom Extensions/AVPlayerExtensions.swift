//
//  AVPlayerExtensions.swift
//  WorkUp
//
//  Created by appsdeveloper Developer on 15/03/23.
//

import Foundation
import AVFoundation

extension AVPlayer {
    var isAudioAvailable: Bool? {
       // return self._asset?.tracks.filter({$0.mediaType == AVMediaType.audio}).count != 0
        return self.currentItem?.asset.tracks.filter({$0.mediaType == AVMediaType.audio}).count != 0
    }

    /*
    var isVideoAvailable: Bool? {
        return self._asset?.tracks.filter({$0.mediaType == AVMediaType.video}).count != 0
    }
     */
    
    func addProgressObserver(action:@escaping ((Double) -> Void)) -> Any {
        
        let interval = CMTime(seconds: 0.1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        
//        return self.addPeriodicTimeObserver(forInterval: interval, queue: .main, using: { time in
        return self.addPeriodicTimeObserver(forInterval: interval, queue: .global(), using: { [weak self] time in

            if let duration = self?.currentItem?.duration {
                let duration = CMTimeGetSeconds(duration), time = CMTimeGetSeconds(time)
                let progress = (time/duration)
                action(progress)
            }
        })
    }
}

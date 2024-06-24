import Foundation
import Foundation
import AVFoundation

class AudioSplitter {
    var audioCroped : (()->())?
    func splitAudio(asset: AVAsset, startTime: CMTime,endTime:CMTime) {
        // Create an output exporter (hardcoded to m4a)
        let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetAppleM4A)!
        exporter.outputFileType = AVFileType.m4a
      
        // Only export for within this time range

        exporter.timeRange = CMTimeRangeFromTimeToTime(start: startTime, end: endTime)
        /**
            Output file format:
         
                originalFile-split-1.mp3
                originalFile-split-2.mp3
            Etc...
         */
        do {
            guard let documentsDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                return
            }
            // check if the file already exist at the destination folder if you don't want to download it twice
            if FileManager.default.fileExists(atPath: documentsDirectoryURL.appendingPathComponent("ShortAudio.m4a").path) {
                try FileManager.default.removeItem(atPath: documentsDirectoryURL.appendingPathComponent("ShortAudio.m4a").path)
            }

            exporter.outputURL =  documentsDirectoryURL.appendingPathComponent("ShortAudio.m4a")
            
            // Do the export
            exporter.exportAsynchronously(completionHandler: {
                switch exporter.status {
                    case AVAssetExportSession.Status.failed:
                        print("Export failed.")
                        if let e = exporter.error {
                            print(e)
                        }
                    case AVAssetExportSession.Status.cancelled:
                        print("Export cancelled.")
                    default:
                        self.audioCroped?()
                        print("Export complete.")
                }
            })
        }
        catch {
            print(error.localizedDescription)
        }
        return
    }
    
    public func processAudio(sourceFileURL: URL,startTime:Double,endTime:Double) {
        // Original file as AVAsset
        let asset: AVAsset = AVAsset(url: sourceFileURL)

        // Length of original file
        let duration = CMTimeGetSeconds(asset.duration)
        if duration == 0 {return}
        let start = CMTimeMake(value: Int64(startTime*duration), timescale: 1)
        let end = CMTimeMake(value: Int64(endTime*duration), timescale: 1)
        splitAudio(asset: asset, startTime: start,endTime:end)
        return
    }
}

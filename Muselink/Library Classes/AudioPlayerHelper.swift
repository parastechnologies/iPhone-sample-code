//
//  AudioPlayerHelper.swift
//  Muselink
//
//  Created by iOS TL on 14/09/21.
//  Copyright © 2021 Paras Technologies. All rights reserved.
//

import AVFoundation
import Accelerate

/**
 * Audio player that uses AVFoundation to play looping background music and
 * short sound effects. For when using SKActions just isn't good enough.
 */
let fftLength: Int  =  4096         // The number of audio samples inputted to the FFT operation each frame.
let binCount: Int   = fftLength/2   // The number of frequency bins provided in the FFT output (binCount=2048 for fftLength=4096)
let halfBinCount = binCount / 2     // halfBinCount = 1024 for fftLength = 4096
let quarterBinCount = binCount / 4  // quarterBinCount = 512 for fftLength = 4096

let twelfthRoot2      : Float = pow(2.0, 1.0 / 12.0)     // twelfth root of two = 1.059463094359
let twentyFourthRoot2 : Float = pow(2.0, 1.0 / 24.0)     // twenty-fourth root of two = 1.029302236643
let freqC1            : Float = 55.0 * pow(twelfthRoot2, -9.0)      // C1 = 32.7032 Hz
let leftFreqC1        : Float = freqC1 / twentyFourthRoot2

let pointsPerNote    = 8  // The number of frequency samples within one musical note.
let notesPerOctave   = 12 // An octave contains 12 musical notes.
let totalNoteCount   = 89 // from C1 to E8 is 89 notes  (  0 <= note < 89 ) (E8 is the highest note we can observe at 11,025 sps.)
let pointsPerOctave  = notesPerOctave * pointsPerNote  // 12 * 8 = 96
let totalPointCount  = totalNoteCount * pointsPerNote  // 89 * 8 = 712  // total number of points provided by the interpolator

let sixOctNoteCount  = 72    // the number of notes within six octaves
let sixOctPointCount = sixOctNoteCount * pointsPerNote  // 72 * 8 = 576   // number of points within six octaves
let halfSixOctPointCount = sixOctPointCount / 2         // 36 * 8 = 288   // number of points within three octaves

// Create a circular buffer to store the past 24 blocks of muSpectrum[]. It stores 32 * 72 * 8 = 18,432 points.
var muSpecHistoryCount : Int = 32   // macOS: Keep the 32 most-recent values of muSpectrum[point] in a circular buffer
                                    // iOS: reduce this to muSpecHistoryCount = 16 to reduce the memory load.
var muSpecHistoryIndex : Int = 0    // Index for writing to the muSpecHistory buffer
var muSpecHistory: [Float] = [Float](repeating: 0.0, count: muSpecHistoryCount * sixOctPointCount)

let circBufferLength: Int = 5510   // store the most recent 5510 audio samples in our circular buffer  Must be >= 4096+1102=5198  I chose 5*1102 = 5510

                // Use this index as a write/read pointer into our circBuffer.

class AudioPlayerHelper: NSObject {
    var isPlaying          = false
    var duration           = TimeInterval()
    var playerFinsh        : (()->())?
    var updateSpectrum     : (()->())?
    var songURL            : String

    let sampleRate: Double = 11025.0     // We will process the audio data at 11,025 samples per second.

    var engine: AVAudioEngine!

    var blockSampleCount: Int = 0  // will be set to the number of audio samples actually captured per block
    
    var circBuffer : [Float] = [Float] (repeating: 0.0, count: circBufferLength)  // Store the most recent 5,510 samples in circBuffer.
    
    // Declare an FFT setup object for fftLength values going forward (time domain -> frequency domain):
    let fftSetup = vDSP_DFT_zop_CreateSetup(nil, UInt(fftLength), vDSP_DFT_Direction.FORWARD)
    
    // Setup the FFT output variables:
    var realIn  = [Float](repeating: 0.0, count: fftLength)
    var imagIn  = [Float](repeating: 0.0, count: fftLength)
    var realOut = [Float](repeating: 0.0, count: fftLength)
    var imagOut = [Float](repeating: 0.0, count: fftLength)
    
    // Calculate a Hann window function of length fftLength:
    var hannWindow = [Float](repeating: 0, count: fftLength)

    // Setup the rms amplitude FFT output:
    var amplitudes = [Float](repeating: 0.0, count: binCount)
    
    // Declare a scaling factor to normalize the amplitude[] array:
    var scalingFactor = Float(0.011)     // 1 / sqrt(8192) = 0.011
                  
    // Declare a dispatchSemaphore for syncronizing processing between frames:
    let dispatchSemaphore = DispatchSemaphore(value: 1)
    
    // Declare a reusable array to contain the current window of audio samples as we manipulate it:
    var sampleValues: [Float] = [Float] (repeating: 0.0, count: fftLength)
    // var sampleBuffer        = [Float](repeating: 0.0, count: fftLength) // fftLength = 4_096
    // var sampleBufferHann    = [Float](repeating: 0.0, count: fftLength) // with a Hanning window applied
    
    // Declare an array to contain the binValues of the current window of audio spectral data:
    var binBuffer = [Float](repeating: 0.0, count: binCount)    // binCount = 2_048
    
    // Prepare to enhance the spectrum to the muSpectrum:
    var outputIndices   = [Float] (repeating: 0.0, count: totalPointCount)  // totalPointCount = 89 * 8 = 712
    var pointBuffer     = [Float](repeating: 0.0, count: totalPointCount)   // totalPointCount = 89 * 8 = 712
    
    // Declare arrays of the final values (for this frame) that we will publish to the various visualizations:
    var frequencyUpdate   = [Float](repeating: 0.0, count: totalPointCount) {
        didSet {
            DispatchQueue.main.async {
                self.updateSpectrum?()
            }
        }
    }  // totalPointCount = 89 * 8 = 712
    var bassFrequencyUpdate = [Float](repeating: 0.0, count: binCount/2)
    var isZero = true
    var timer : Timer?
    var loudnessValue    = 0.0
    var index: Int = 0
    private var isEngineReady      = false
    private var needsFileScheduled = true
    private let player             = AVAudioPlayerNode()    // player will read and play our song file
    private let mixer              = AVAudioMixerNode()      // mixer will convert channelCount to mono, and sampleRate to 11,025
    private let mixer2             = AVAudioMixerNode()     // mixer2 sets volume to 0 when using microphone (preventing feedback)
    private let delay              = AVAudioUnitDelay()      // delay will add a 0.1 seconds delay to the audio output
    private var audioFile          : AVAudioFile?
    private var audioSampleRate    : Double = 0
    private var audioLengthSeconds : Double = 0
    private var seekFrame          : AVAudioFramePosition = 0
    private var currentPosition    : AVAudioFramePosition = 0
    private var audioLengthSamples : AVAudioFramePosition = 0
    
    var currentTime: TimeInterval {
        guard
            let lastRenderTime = player.lastRenderTime,
            let playerTime     = player.playerTime(forNodeTime: lastRenderTime)
        else {
            return 0
        }
        return Double(playerTime.sampleTime)/audioSampleRate
    }
    
    init(song:String,isLocal : Bool = false) {
        songURL = song
        super.init()
        isEngineReady = false
        if isLocal {
            setupAudioLocal(song)
        }
        else {
            setUpAudio(song)
        }
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
        NetworkManager.sharedInstance.downloadShortAudio(link: url) { [weak self] result in
            switch result {
            case .success(let data):
                guard let self = self else {return}
                do {
                    let file = try AVAudioFile(forReading: data)
                    let format = file.processingFormat
                    self.audioLengthSamples = file.length
                    self.audioSampleRate = format.sampleRate
                    self.audioLengthSeconds = Double(self.audioLengthSamples) / self.audioSampleRate
                    self.duration = self.audioLengthSeconds
                    self.audioFile = file
                    self.configureAudio()
                } catch {
                    print("Error reading the audio file: \(error.localizedDescription)")
                }
                print(data)
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
        
    }
    func setupAudioLocal(_ songStr:String) {
        guard let url = URL(string: songStr.replacingOccurrences(of: " ", with: "%20")) else {
            print("mp3 not found")
            return
        }
        do {
            let file = try AVAudioFile(forReading: url)
            let format = file.processingFormat
            self.audioLengthSamples = file.length
            self.audioSampleRate = format.sampleRate
            self.audioLengthSeconds = Double(self.audioLengthSamples) / self.audioSampleRate
            self.duration = self.audioLengthSeconds
            self.audioFile = file
            self.configureAudio()
        } catch {
            print("Error reading the audio file: \(error.localizedDescription)")
        }
    }
    // ----------------------------------------------------------------------------------------------------------------
    //  Setup and start our audio engine:
    func configureAudio(){
        frequencyUpdate   = [Float](repeating: 0.0, count: totalPointCount)
        let session = AVAudioSession.sharedInstance()  // Get the singleton instance of an AVAudioSession.
        do {
            // This is required by iOS to prevent output audio from only going to the iPhones's rear speaker.
            try session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: [.defaultToSpeaker])
        } catch { print("Failed to set audioSession category.") }

        // Create our player, mixer, and delay nodes.  (The mainMixerNode is created automatically.)
        engine = AVAudioEngine()            // Initialize our audio engine.
        
        // Before connecting nodes we need to attach them to the engine:
        engine.attach(player)   // player will read and play our song file
        engine.attach(mixer)    // mixer will convert channelCount to mono, and sampleRate to 11,025
        engine.attach(mixer2)   // mixer2 sets volume to 0 when using microphone (preventing audio feedback)
        engine.attach(delay)    // delay will add a 0.1 seconds delay to the audio output

        // This is an inappropriate place to put the following 3 lines, but I couldn't find any better.
        muSpecHistoryCount = 16  // Throttle back the graphics load for iOS devices.
        
    
        // Capture the AVAudioFormat of our player node (It should be that of the music file.)
        let playerOutputFormat = player.outputFormat(forBus: 0)
        // print("playerOutputFormat = \(playerOutputFormat)")
        
        // Define a monophonic (1 ch) and 11025 sps AVAudioFormat for the desired output of our mixer node.
        let mixerOutputFormat =  AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: sampleRate, channels: 1, interleaved: false)
        // print("mixerOutputFormat = \(String(describing: mixerOutputFormat))")
        mixer.installTap(onBus:0, bufferSize: 1102, format: nil) { [weak self](buffer, time) in
            if self?.isPlaying ?? false {
                self?.captureOutput(buffer: buffer)
                // print("actual frameLength: \(buffer.frameLength)")  // 4410 for SR=44100; 2205 for SR=22050; 1102 for SR=11025
            }
            else {
                
            }
        }
        // Connect our nodes in the desired order:
        engine.connect(player,  to: mixer, format: playerOutputFormat)  // Connect player to mixer
        engine.connect(mixer,   to: delay, format: mixerOutputFormat)   // Connect mixer to delay
        engine.connect(delay,   to: engine.mainMixerNode, format:mixerOutputFormat) // Connect delay to mainMixerNode
    
        // Confirm that the format of the delay node output is what we expect.
        let delayOutputFormat = delay.outputFormat(forBus: 0)
        print("delayOutputFormat = \(delayOutputFormat)")
            
        // Install a tap on the mixerNode to get the buffer data to use for rendering visualizations:
        // Even though I request 1024 samples, the app consistently gives me 1102 samples every 0.1 seconds.
    
        engine.prepare()        // Prepare and start our audio engine:
        do {
            try engine.start()
            isEngineReady = true
            scheduleAudioFile()
        } catch { print("Unable to start AVAudioEngine: \(error.localizedDescription)") }
    
        // Set the parameters for our delay node:
        delay.delayTime = 0.2   // The delay is specified in seconds. Default is 1. Valid range of values is 0 to 2 seconds.
        delay.feedback = 0.0    // Percentage of the output signal fed back. Default is 50%. Valid range of values is -100% to 100%.
        delay.lowPassCutoff = 5512  // The default value is 15000 Hz. The valid range of values is 10 Hz through (sampleRate/2).
        delay.wetDryMix = 100     // Blend is specified as a percentage. Default value is 100%. Valid range is 0% (all dry) through 100% (all wet).
        
    }  // end of setupAudio() func
    private func scheduleAudioFile() {
        guard
            let file = audioFile,
            needsFileScheduled
        else {
            return
        }

        needsFileScheduled = false
        seekFrame = 0
        
        player.scheduleFile(file, at: nil) {[weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                self?.needsFileScheduled = true
                self?.playerFinsh?()
            }
        }
        startPlayer()
    }
    func startPlayer() {
        frequencyUpdate   = [Float](repeating: 0.0, count: totalPointCount)
        guard isEngineReady else {return}
        isPlaying = true
        if needsFileScheduled {
            scheduleAudioFile()
        }
        player.play()
        
    }
    func playAgain() {
        stopAudioPlayer()
        scheduleAudioFile()
    }
    func stopAudioPlayer() {
        frequencyUpdate   = [Float](repeating: 0.0, count: totalPointCount)
        guard isEngineReady else {return}
        isPlaying = false
        player.pause()
    }
    // ----------------------------------------------------------------------------------------------------------------
    func captureOutput(buffer: AVAudioPCMBuffer){
        blockSampleCount = Int(buffer.frameLength)        // number of audio samples actually captured per block (typically 1102)
        var blockSampleValues: [Float] = [Float](repeating: 0.0, count: blockSampleCount)  // one block of audio sample values
        
        // Extract the most-recent block of audio samples from the AVAudioPCMBuffer created by the AVAudioEngine
        blockSampleValues  = Array(UnsafeBufferPointer(start: buffer.floatChannelData?[0], count:Int(buffer.frameLength)))
        
        // Write the most-recent block of audio samples into our circBuffer:
        for sample in 0 ..< blockSampleCount {
            // At this time instance, "index" points to the most recent sample written into our circBuffer.
            index += 1  // This is the "index" for the sample that is about to be written into our circBuffer.
            if (index >= circBufferLength) { index = 0 }      // index will always be less than circBufferLength
            circBuffer[index] = blockSampleValues[sample]
        }
        readData()
    }  // end of captureOutput() func



    // ----------------------------------------------------------------------------------------------------------------
    // After the first 5 frames of audio data, the AudioManager has filled the circBuffer with the most-recent
    // 5 * 1102 = 5510 audio samples with "index" pointing to the most-recent sample.
    // Now we can read the data out of this circular buffer into the 4096-element sampleValues array.
    
    func readData() {
    
        // Fill the sampleValues array with the most recent fftLength audio values from the circBuffer:
        // At this time instance, "index" points to the most-recent sample written into the circBuffer.
        let tempIndex1 = (index - fftLength >= 0) ? index - fftLength : index - fftLength + circBufferLength
        
        for sample in 0 ..< fftLength {
            let tempIndex2 = (tempIndex1 + sample) % circBufferLength  // We needed to account for wrap-around at the circBuffer ends
            sampleValues[sample] = self.circBuffer[tempIndex2]
        }
        processData()   // This func is located in the AudioManager extension.
    }  // end of readData() func



    // ----------------------------------------------------------------------------------------------------------------
    // Now we can start processing and rendering this audio data:
    func processData() {
        frequencyUpdate = [Float](repeating: 0.0, count: totalPointCount)
        dispatchSemaphore.wait()  // Wait until receiving a semaphore indicating that the processing of data from the previous frame is complete
        
        vDSP_hann_window(&hannWindow, vDSP_Length(fftLength), Int32(vDSP_HANN_NORM))

        // Fill the real input part (&realIn) with audio data from the AudioManager (multiplied by the Hann window):
        vDSP_vmul(sampleValues, 1, hannWindow, vDSP_Stride(1), &realIn, vDSP_Stride(1), vDSP_Length(fftLength))

        // Execute the FFT.  The results are now inside the realOut[] and imagOut[] arrays:
        vDSP_DFT_Execute(fftSetup!, &realIn, &imagIn, &realOut, &imagOut)
        
        // Package the FFT results inside a complex vector representation used in the vDSP framework:
        var complex = DSPSplitComplex(realp: &realOut, imagp: &imagOut)

        // Calculate the rms amplitude FFT results:
        vDSP_zvabs(&complex, vDSP_Stride(1), &amplitudes, vDSP_Stride(1),  vDSP_Length(binCount))

        // Normalize the rms amplitudes to be within the range 0.0 to 1.0:
        vDSP_vsmul(&amplitudes, 1, &scalingFactor, &binBuffer, 1, vDSP_Length(binCount))

        let binWidth: Float = ( Float(sampleRate) / 2.0 ) / Float(binCount)     //  (11,025/2) / 2,048 = 2.69165 Hz

        // Compute the pointBuffer[] (precursor to the muSpectrum[]):
        // This uses pointsPerNote = 8, so the pointBuffer has size totalPointCount = 89 * 8 = 712
        for point in 0 ..< totalPointCount {
            outputIndices[point] = (leftFreqC1 * pow(2.0, Float(point) / Float(notesPerOctave * pointsPerNote))) / binWidth
        }
        vDSP_vqint(binBuffer, &outputIndices, vDSP_Stride(1), &pointBuffer, vDSP_Stride(1), vDSP_Length(totalPointCount) , vDSP_Length(binCount))
        dispatchSemaphore.signal()  // Transmit a semaphore indicating that the processing of data from this frame is complete
        publishData()
    } // end of processData() func
    // ----------------------------------------------------------------------------------------------------------------
    func publishData() {
       // halfSpectrum = binBuffer            // This is wastefull copying of the binBuffer    to enable publishing it.
       // frequencyUpdate   = pointBuffer.reversed()          // This is wastefull copying of the pointBuffer  to enable publishing it.
        if isZero {
            frequencyUpdate     = binBuffer.reversed()
            bassFrequencyUpdate = pointBuffer
            isZero = false
        }
        else {
            frequencyUpdate = [Float](repeating: 0.0, count: totalPointCount)
            bassFrequencyUpdate = [Float](repeating: 0.0, count: totalPointCount)
            isZero = true
        }
    }
    // end of publishData() func
}  // end of AudioManager class

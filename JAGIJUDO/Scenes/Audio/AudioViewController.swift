import UIKit
import AVFoundation
import Speech

final public class AudioViewController: UIViewController, SFSpeechRecognizerDelegate {
    
    struct Dependency {
        let viewModel: AudioViewModel
    }
    
    private var viewModel: AudioViewModel
    private let audioEngine = AVAudioEngine()
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private let request = SFSpeechAudioBufferRecognitionRequest()
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioImpl = AudioImpl.shared
    private let textField = UITextField()
    private let recordButton = UIButton()
    private let speakButton = UIButton()

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        speechRecognizer?.delegate = self
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.recordButton.isEnabled = true
                default:
                    self.recordButton.isEnabled = false
                }
            }
        }
    }

    private func setupUI() {
        textField.frame = CGRect(x: 20, y: 100, width: 280, height: 40)
        textField.borderStyle = .roundedRect
        textField.placeholder = "Recognized text appears here"
        view.addSubview(textField)
        
        recordButton.frame = CGRect(x: 20, y: 150, width: 130, height: 50)
        recordButton.backgroundColor = .red
        recordButton.setTitle("Record", for: .normal)
        recordButton.addTarget(self, action: #selector(didTapRecordButton), for: .touchUpInside)
        view.addSubview(recordButton)
        
        speakButton.frame = CGRect(x: 170, y: 150, width: 130, height: 50)
        speakButton.backgroundColor = .blue
        speakButton.setTitle("Speak", for: .normal)
        speakButton.addTarget(self, action: #selector(didTapSpeakButton), for: .touchUpInside)
        view.addSubview(speakButton)
    }
    
    @objc func didTapRecordButton() {
        if audioEngine.isRunning {
            audioEngine.stop()
            request.endAudio()
            recordButton.setTitle("Record", for: .normal)
            resetAudioSession()
        } else {
            try? startRecording()
            recordButton.setTitle("Stop", for: .normal)
        }
    }
    
    private func resetAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .default)
            try audioSession.setActive(false, options: .notifyOthersOnDeactivation)
        } catch {
            print("Failed to reset audio session: \(error.localizedDescription)")
        }
    }

    private func startRecording() throws {
        recognitionTask?.cancel()
        self.recognitionTask = nil

        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

        let inputNode = audioEngine.inputNode
        
        inputNode.removeTap(onBus: 0)

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }

        audioEngine.prepare()
        if !audioEngine.isRunning {
            try audioEngine.start()
        }

        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { [weak self] result, error in
            guard let self = self else { return }

            if let result = result {
                self.textField.text = result.bestTranscription.formattedString
                if result.isFinal {
                    self.audioEngine.stop()
                    inputNode.removeTap(onBus: 0)
                    self.recordButton.setTitle("Record", for: .normal)

                    // 자동으로 음성 출력
                    self.audioImpl.speak(text: result.bestTranscription.formattedString)
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        })
    }
    
    init(dependency: Dependency) {
        self.viewModel = dependency.viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @objc func didTapSpeakButton() {
        if let text = textField.text, !text.isEmpty {
            audioImpl.speak(text: text)
            print("출력")
        } else {
            print("Text field is empty.")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

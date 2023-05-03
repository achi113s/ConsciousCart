//
//  ScannerViewController.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 5/1/23.
//

import AVFoundation
import UIKit
import RiveRuntime

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var checkmark_animation: CheckmarkAnimationViewController!
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        navigationController?.navigationBar.tintColor = .white
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            print("Unable to initialize AVCaptureDeviceInput with video capture device.")
            return
        }
        
        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            failed()
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417]
        } else {
            failed()
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        
        let previewView = UIView(frame: view.frame)
        view.addSubview(previewView)
        
        previewView.layer.addSublayer(previewLayer)
        
        // show animation
        checkmark_animation = CheckmarkAnimationViewController()
//        checkmark_animation.view.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
//        checkmark_animation.view.backgroundColor = .red
        view.addSubview(checkmark_animation.view)
        
        
        startRunningCaptureSession()
        
//        Task.detached(priority: .userInitiated) { [weak self] in
//            await self?.captureSession.startRunning()
//        }
    }
    
    func failed() {
        let ac = UIAlertController(title: "Scanning Not Supported", message: "Your device does not support scanning a code from an item. Please use a device with a camera.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    func startRunningCaptureSession() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession.startRunning()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (captureSession?.isRunning == false) {
            startRunningCaptureSession()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession?.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession.stopRunning()
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
        
        timer = Timer.scheduledTimer(timeInterval: 2.2, target: self, selector: #selector(dismissAfterTime), userInfo: nil, repeats: false)
//        dismiss(animated: true)
    }
    
    @objc func dismissAfterTime() {
        timer?.invalidate()
        navigationController?.popViewController(animated: true)
//        dismiss(animated: true)
    }
    
    func found(code: String) {
        checkmark_animation.viewModel.play()
        print(code)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

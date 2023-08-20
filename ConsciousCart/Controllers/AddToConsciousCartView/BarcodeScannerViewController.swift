//
//  ScannerViewController.swift
//  ConsciousCart
//
//  Created by Giorgio Latour on 5/1/23.
//

import AVFoundation
import UIKit

/// This scanner based on Paul Hudson's barcode scanner.
/// https://www.hackingwithswift.com/example-code/media/how-to-scan-a-barcode

class BarcodeScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate, BarcodeAPIManagerDelegate {
    
    private var captureSession: AVCaptureSession!
    private var previewLayer: AVCaptureVideoPreviewLayer!
    private var timer: Timer?
    private var spinner: UIActivityIndicatorView!
    
    private var barcodeAPIManager: BarcodeAPIManager! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        navigationController?.navigationBar.tintColor = .white
        
        barcodeAPIManager = BarcodeAPIManager()
        barcodeAPIManager.delegate = self
        
        loadScannerView()
        configureSpinner()
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
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    //MARK: - Scanner View Setup and Support
    private func loadScannerView() {
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
            metadataOutput.metadataObjectTypes = [.ean8, .ean13]
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
        
        startRunningCaptureSession()
    }
    
    private func failed() {
        let message = """
            Your device does not support scanning a code
            from an item. Please use a device with a camera.
        """
        let ac = UIAlertController(title: "Scanning Not Supported", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        captureSession = nil
    }
    
    private func startRunningCaptureSession() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.captureSession.startRunning()
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
    }
    
    private func found(code: String) {
        spinner.startAnimating()
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            self?.barcodeAPIManager.fetchBarcodeInfo(for: code)
        }
    }
    
    private func configureSpinner() {
        spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.center = view.center
        spinner.color = UIColor(named: "ShyMoment")
        spinner.hidesWhenStopped = true
        
        view.addSubview(spinner)
        
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    //MARK: - Selectors
    @objc func dismissAfterTime() {
        timer?.invalidate()
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - BarcodeAPIManager Delegate Extension
    func didFetchBarcodeInfo(_ barcodeAPIManager: BarcodeAPIManager, barcodeInfo: BarcodeInfo) {
        DispatchQueue.main.async { [weak self] in
            // this is a fragile way of getting the previous VC
            guard let count = self?.navigationController?.viewControllers.count else { return }
            guard let prevView = self?.navigationController?.viewControllers[count-2] as? AddToCCViewController else { return }
            
            let price: String = barcodeInfo.Stores.first?.price ?? "0"
            prevView.itemNameTextField.text = barcodeInfo.itemAttributes.title
            prevView.itemPriceTextField.text = price.asCurrency(locale: Locale.current)
            
            self?.spinner.stopAnimating()
            // Wait a short time before dismissing the scanner view.
            self?.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self!,
                                               selector: #selector(self?.dismissAfterTime), userInfo: nil, repeats: false)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error.localizedDescription)
    }
}

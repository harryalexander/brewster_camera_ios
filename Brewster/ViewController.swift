//
//  ViewController.swift
//  Brewster
//
//  Created by Harry Alexander on 4/25/20.
//  Copyright © 2020 Harry Alexander. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class ViewController: UIViewController {
    
    var captureSession = AVCaptureSession()
    let camDevice = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera,
                                            for: .video, position: .back)
    let photoOutput = AVCapturePhotoOutput()
    let previewView = CameraPreviewView()
    let captureProcessor = RAWCaptureProcessor()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        requestPhotosLibAccess()
        startCaptureSession()
        previewView.frame = view.bounds
        previewView.previewLayer.videoGravity = .resizeAspectFill
        previewView.previewLayer.session = captureSession
        view.addSubview(previewView)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: Implement permissions management
    //    func authorizeCamAccess(onAuth: @escaping (_ didAuth: Bool) -> Void) {
    //        switch AVCaptureDevice.authorizationStatus(for: .video) {
    //        case .denied, .notDetermined, .restricted:
    //            DispatchQueue.main.async {
    //                AVCaptureDevice.requestAccess(for: .video) { (isGranted) in
    //                    onAuth(isGranted)
    //                }
    //            }
    //
    //        default:
    //            return
    //        }
    //    }
    //
    //    func presentSettingsAlert() {
    //    }
    
    // MARK: Implement save to Photos
    //    func saveToPhotosLibrary() {
    //
    //    }
    
    func requestPhotosLibAccess() {
        PHPhotoLibrary.requestAuthorization { (status) in
            DispatchQueue.main.sync {
                // MARK: This is only here for testing. Remove once capture button is implemented
                // and sort out a better permissions management strategy for photos lib and camera access
                self.snapPhoto()
            }
        }
    }
    
    func startCaptureSession() {
        captureSession.beginConfiguration()
        guard let camDevice = camDevice else {
            print("Error getting cam device")
            return
        }
        guard let camDeviceInput = try? AVCaptureDeviceInput(device: camDevice),
            captureSession.canAddInput(camDeviceInput) else {
                print("Capture session cannot add cam device input")
                return
        }
        captureSession.addInput(camDeviceInput)
        guard captureSession.canAddOutput(photoOutput) else {
            print("Capture session cannot add cam device output")
            return
        }
        captureSession.addOutput(photoOutput)
        captureSession.sessionPreset = .photo
        captureSession.commitConfiguration()
        captureSession.startRunning()
    }
    
    @objc func snapPhoto() {
        guard let availableRawFormat = photoOutput.availableRawPhotoPixelFormatTypes.first else {
            print("No available RAW format on this phone")
            return
        }
        let photoSettings = AVCapturePhotoSettings(
            rawPixelFormatType: availableRawFormat,
            processedFormat: [AVVideoCodecKey: AVVideoCodecType.hevc])
        photoOutput.capturePhoto(with: photoSettings, delegate: captureProcessor)
    }
    
    //    func getAvailableDevices() -> [AVCaptureDevice] {
    //        let deviceTypes = [
    //            AVCaptureDevice.DeviceType.builtInDualCamera,
    //            AVCaptureDevice.DeviceType.builtInDualWideCamera,
    //            AVCaptureDevice.DeviceType.builtInMicrophone,
    //            AVCaptureDevice.DeviceType.builtInTelephotoCamera,
    //            AVCaptureDevice.DeviceType.builtInTripleCamera,
    //            AVCaptureDevice.DeviceType.builtInTrueDepthCamera,
    //            AVCaptureDevice.DeviceType.builtInUltraWideCamera,
    //            AVCaptureDevice.DeviceType.builtInWideAngleCamera,
    //        ]
    //        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: deviceTypes, mediaType: .video, position: .unspecified)
    //        return discoverySession.devices
    //    }
}

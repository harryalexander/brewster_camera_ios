//
//  ViewController.swift
//  Brewster
//
//  Created by Harry Alexander on 4/25/20.
//  Copyright © 2020 Harry Alexander. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    var captureSession = AVCaptureSession()
    let previewView = CameraPreviewView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startCaptureSession()
        previewView.frame = view.bounds
        previewView.previewLayer.videoGravity = .resizeAspectFill
        previewView.previewLayer.session = captureSession
        view.addSubview(previewView)
    }
    
    // TODO: Implement permissions management
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
    
    // TODO: Implement save to Photos
//    func saveToPhotosLibrary() {
//
//    }
    
    func startCaptureSession() {
        captureSession.beginConfiguration()
        guard let camDevice = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInTrueDepthCamera,
                                                      for: .video, position: .front) else {
                print("Error getting cam device")
                return
        }
        guard let camDeviceInput = try? AVCaptureDeviceInput(device: camDevice),
            captureSession.canAddInput(camDeviceInput) else {
                print("Capture session cannot add cam device input")
            return
        }
        captureSession.addInput(camDeviceInput)
        
        let photoOutput = AVCapturePhotoOutput()
        guard captureSession.canAddOutput(photoOutput) else {
            print("Capture session cannot add cam device output")
            return
        }
        captureSession.sessionPreset = .photo
        captureSession.addOutput(photoOutput)
        captureSession.commitConfiguration()
        captureSession.startRunning()
    }
    
    func getAvailableDevices() -> [AVCaptureDevice] {
        let deviceTypes = [
            AVCaptureDevice.DeviceType.builtInDualCamera,
            AVCaptureDevice.DeviceType.builtInDualWideCamera,
            AVCaptureDevice.DeviceType.builtInMicrophone,
            AVCaptureDevice.DeviceType.builtInTelephotoCamera,
            AVCaptureDevice.DeviceType.builtInTripleCamera,
            AVCaptureDevice.DeviceType.builtInTrueDepthCamera,
            AVCaptureDevice.DeviceType.builtInUltraWideCamera,
            AVCaptureDevice.DeviceType.builtInWideAngleCamera,
        ]
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: deviceTypes, mediaType: .video, position: .unspecified)
        return discoverySession.devices
    }
}


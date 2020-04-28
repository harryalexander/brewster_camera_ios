//
//  CameraPreviewView.swift
//  Brewster
//
//  Created by Harry Alexander on 4/28/20.
//  Copyright © 2020 Harry Alexander. All rights reserved.
//

import UIKit
import AVFoundation

class CameraPreviewView: UIView {
    
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    var previewLayer: AVCaptureVideoPreviewLayer {
        return layer as! AVCaptureVideoPreviewLayer
    }
}

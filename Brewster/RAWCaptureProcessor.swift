//
//  RAWCaptureProcessor.swift
//  Brewster
//
//  Created by Harry Alexander on 4/28/20.
//  Copyright © 2020 Harry Alexander. All rights reserved.
//

import AVFoundation
import Photos

class RAWCaptureProcessor: NSObject, AVCapturePhotoCaptureDelegate {
    var rawImageURL: URL?
    var processedImageData: Data?
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard error == nil else {
            print("Error processing photo", error)
            return
        }
        if photo.isRawPhoto {
            rawImageURL = genTempFileURL(fileExtension: "dng")
            do {
                try photo.fileDataRepresentation()!.write(to: rawImageURL!)
            } catch {
                print("Failed to write RAW file to temp url")
            }
        } else {
            processedImageData = photo.fileDataRepresentation()!
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
        guard error == nil else {
            print("Error finishing capture", error)
            return
        }
        guard let rawImageURL = rawImageURL, let processedImageData = processedImageData else {
            print("RawURL:\(String(describing: self.rawImageURL))\nprocessed image: \(String(describing: self.processedImageData))")
            return
        }
        PHPhotoLibrary.requestAuthorization { status in
            guard status == .authorized else { return }
            PHPhotoLibrary.shared().performChanges({
                // Add the compressed (HEIF) data as the main resource for the Photos asset.
                let creationRequest = PHAssetCreationRequest.forAsset()
                creationRequest.addResource(with: .photo, data: processedImageData, options: nil)
                
                // Add the RAW (DNG) file as an altenate resource.
                let options = PHAssetResourceCreationOptions()
                options.shouldMoveFile = true
                creationRequest.addResource(with: .alternatePhoto, fileURL: rawImageURL, options: options)
            }, completionHandler: self.handlePhotoLibraryError)
        }
    }
    
    // TODO: Implement this!
    func handlePhotoLibraryError(success: Bool, error: Error?) {
        
    }
    
    func genTempFileURL(fileExtension: String) -> URL {
        let tempDirURL = FileManager.default.temporaryDirectory
        let fileName = ProcessInfo.processInfo.globallyUniqueString
        let url = tempDirURL
            .appendingPathComponent(fileName)
            .appendingPathExtension(fileExtension)
        return url
    }
}

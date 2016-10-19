//
//  AVDSendVC.swift
//  AV
//
//  Created by whj on 16/10/12.
//  Copyright © 2016年 dream. All rights reserved.
//

import UIKit
import AVFoundation

class AVDSendVC: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {

    @IBOutlet weak var imageview: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    
        session.stopRunning();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Action
    
    @IBAction func startAction(_ sender: UIButton) {
    
        setupCaptureSession();
    }
    
    // MARK: - Unit
    
    let session = AVCaptureSession();
    func setupCaptureSession() -> Void {
        
        session.sessionPreset = AVCaptureSessionPresetHigh;
        
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo);
        
        let deviceInput = try! AVCaptureDeviceInput.init(device: device);
        
        session.addInput(deviceInput);
        
        let videoDataOutput = AVCaptureVideoDataOutput();
        session.addOutput(videoDataOutput);
        
        let queue = DispatchQueue(label: "AV");
        videoDataOutput.setSampleBufferDelegate(self, queue: queue);
        videoDataOutput.videoSettings = nil;
        
        session.startRunning();
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: session);
        previewLayer?.frame = self.view.bounds;
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill;

        self.view.layer.addSublayer(previewLayer!);
        
        if !session.isRunning {
        
            session.startRunning();
        }
        
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        
        let formatDescription = CMSampleBufferGetFormatDescription(sampleBuffer);
        let dimensions = CMVideoFormatDescriptionGetDimensions(formatDescription!);
        
        print("====>>>:\(dimensions)");
        
        
        
        
//        let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
//        CVPixelBufferLockBaseAddress(imageBuffer!, CVPixelBufferLockFlags.readOnly);
//        
//        let width = CVPixelBufferGetWidthOfPlane(imageBuffer!, 0)
//        let height = CVPixelBufferGetHeightOfPlane(imageBuffer!, 0)
//        let bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer!, 0)
//        let lumaBuffer = CVPixelBufferGetBaseAddressOfPlane(imageBuffer!, 0)
//        
//        let grayColorSpace = CGColorSpaceCreateDeviceGray();
//        
//        let context = CGContext(data: lumaBuffer, width: width, height: height, bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: grayColorSpace, bitmapInfo: CGBitmapInfo.alphaInfoMask.rawValue)
//        let cgImage = context!.makeImage()
//
//        DispatchQueue.main.sync(execute: {
//            self.imageview.layer.contents = cgImage
//        })

    }
}

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
        
        print("====>>>");
    }
}

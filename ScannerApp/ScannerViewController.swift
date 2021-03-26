//
//  ScannerViewController.swift
//  ScannerApp
//
//  Created by Vinod VIshwakarma on 26/03/2021.
//

import UIKit
import AVFoundation

class ScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    @IBOutlet weak var msgLabel:UILabel!
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    @IBOutlet var  containerFrameView:UIView?
    @IBOutlet weak var heightConstrant:NSLayoutConstraint!
    
//    var scannerType:ScannerType?
    var qrCodeFrameView:UIView?
//    var studentDataObj:JSONObject!
//    var dataObj:JSONObject!
//    var event_model:EventModel?
//    var myClassroomModel:MyClassroomModel?
//    var set_updated = false
//    var pointType:Int? = 0
//    var classroomPoint:Int? = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "scan"
        
        self.initCaptureSession()
        
         
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    //MARK:- Start the camera session
    func initCaptureSession() -> Void {
        
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video
        // as the media type parameter.
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        // Get an instance of the AVCaptureDeviceInput class using the previous device object.
        do{
            let input: AnyObject! = try AVCaptureDeviceInput(device: captureDevice!)
            
            var frontCaptureDevice: AVCaptureDevice! = nil
            if let input = input as? AVCaptureDeviceInput {
                if (input.device.position == .back) {
                    frontCaptureDevice = cameraWithPosition(position: .front)
                } else {
                    frontCaptureDevice = cameraWithPosition(position: .front)
                }
            }
            
            let newInput: AnyObject! = try AVCaptureDeviceInput(device: frontCaptureDevice!)
            
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            // Set the input device on the capture session.
            captureSession?.addInput(newInput as! AVCaptureInput)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            //view.layer.addSublayer(videoPreviewLayer!)
            self.containerFrameView?.layer.addSublayer(videoPreviewLayer!)
            // Start video capture.
            captureSession?.startRunning()
            
            // Move the message label to the top view
            //            self.view.bringSubviewToFront(self.msgLabel)
            
            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()
            qrCodeFrameView?.layer.borderColor = UIColor(named: "red_color")?.cgColor//UIColor.green.cgColor
            qrCodeFrameView?.layer.borderWidth = 3
            
            let size = CGSize(width: self.view.frame.width-100, height: self.view.frame.width-100)
            let rect = CGRect(origin: CGPoint.init(x:0, y: self.msgLabel.frame.height), size:size)
            qrCodeFrameView?.frame = rect
            qrCodeFrameView!.center = CGPoint(x: self.view.frame.width  / 2, y: self.view.frame.height / 2)
            view.bringSubviewToFront(qrCodeFrameView!)
            view.addSubview(qrCodeFrameView!)
            
            
        } catch {
            debugPrint("something went wrong!")
        }
    }
    
    
    // Find a camera with the specified AVCaptureDevicePosition, returning nil if one is not found
    func cameraWithPosition(position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .unspecified)
        for device in discoverySession.devices {
            if device.position == position {
                return device
            }
        }

        return nil
    }
    
    
    //MARK:- Metadata call back
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            //self.msgLabel.text = "No QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObject.ObjectType.qr {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            qrCodeFrameView?.frame = barCodeObject.bounds;
            
            if metadataObj.stringValue != nil {
                qrCodeFrameView?.layer.borderColor = UIColor(named: "green_color")?.cgColor
//                captureSession?.stopRunning()
                
                debugPrint("QR code =\(metadataObj.stringValue!)")
                
                
            }
        }
    }
    
    
    
}

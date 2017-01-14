//
//  BarcodeReaderView.swift
//  GitBook
//
//  Created by Yuta on 2017/01/14.
//  Copyright © 2017年 funhacks-1702. All rights reserved.
//

import UIKit
import AVFoundation

/*
 
 開始:startTracking
 終了:stopTracking
 
 ※Info.plistにCamera Usage Descriptionを追加してください
 カメラの権限チェック:cameraAuthorityCheck
 
 // 使用例
 let camera = BarcodeReader(frame: CGRect(x: 0, y: 20, width: self.view.frame.size.width, height: 300))
 camera.delegate = self
 camera.startTracking()
 self.view.addSubview(camera)
 
 // BarcodeReaderDelegate
 func getISBN(isbn: String) {
 print(isbn)
 }
 
 */


protocol BarcodeReaderDelegate {
    func getISBN(isbn:String)
}

class BarcodeReaderView: UIView, AVCaptureMetadataOutputObjectsDelegate{
    
    let session: AVCaptureSession = AVCaptureSession()
    var prevlayer: AVCaptureVideoPreviewLayer!
    var detectionString : String!
    var delegate : BarcodeReaderDelegate!
    
    override func awakeFromNib() {
        let view = Bundle.main.loadNibNamed("BarcodeReaderView", owner: self, options: nil)?.first as! UIView
        addSubview(view)
    }
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        cameraAuthorityCheck()
        
        let view = Bundle.main.loadNibNamed("BarcodeReaderView", owner: self, options: nil)?.first as! UIView
        view.frame = frame
        addSubview(view)
        
        //準備（サイズ調整、ボーダーカラー、カメラオブジェクト取得）
        self.autoresizingMask =  [.flexibleTopMargin,.flexibleBottomMargin,.flexibleLeftMargin,.flexibleRightMargin]
        self.layer.borderColor = UIColor.green.cgColor
        self.layer.borderWidth = 3
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        //インプット
        let input :AVCaptureDeviceInput?
        do{
            input = try AVCaptureDeviceInput(device: device)
            session.addInput(input)//カメラインプットセット
        } catch {
            print(error)
        }
        
        //アウトプット
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        session.addOutput(output)//プレビューアウトプットセット
        output.metadataObjectTypes = output.availableMetadataObjectTypes
        prevlayer = AVCaptureVideoPreviewLayer(session: session)
        prevlayer.frame = self.bounds
        prevlayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.layer.addSublayer(prevlayer)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startTracking() {
        if session.isRunning == false {
            session.startRunning()
        }
    }
    
    func stopTracking(){
        session.stopRunning()
    }
    
    //バーコードが見つかった時に呼ばれる
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!,
                       from connection: AVCaptureConnection!) {
        
        //var highlightViewRect = CGRectZero
        var highlightViewRect = CGRect.zero
        var barCodeObject : AVMetadataObject!
        
        //対応バーコードタイプ
        let barCodeTypes = [AVMetadataObjectTypeUPCECode,
                            AVMetadataObjectTypeCode39Code,
                            AVMetadataObjectTypeCode39Mod43Code,
                            AVMetadataObjectTypeEAN13Code,
                            AVMetadataObjectTypeEAN8Code,
                            AVMetadataObjectTypeCode93Code,
                            AVMetadataObjectTypeCode128Code,
                            AVMetadataObjectTypePDF417Code,
                            AVMetadataObjectTypeQRCode,
                            AVMetadataObjectTypeAztecCode
        ]
        
        //複数のバーコードの同時取得も可能
        for metadata in metadataObjects {
            for barcodeType in barCodeTypes {
                if (metadata as AnyObject).type == barcodeType {
                    barCodeObject = self.prevlayer.transformedMetadataObject(for: metadata as! AVMetadataMachineReadableCodeObject)
                    highlightViewRect = barCodeObject.bounds
                    detectionString = (metadata as! AVMetadataMachineReadableCodeObject).stringValue
                    self.session.stopRunning()
                    break
                }
            }
        }
        delegate.getISBN(isbn: detectionString)
    }
    
    // カメラの権限チェック
    func cameraAuthorityCheck(){
        let status = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        
        if status == AVAuthorizationStatus.authorized {
            print("カメラ アクセス許可あり")
        } else if status == AVAuthorizationStatus.restricted {
            print("カメラ ユーザがカメラの使用を禁止")
        } else if status == AVAuthorizationStatus.notDetermined {
            print("カメラ　アクセス許可未承認（初回アクセス）")
        } else if status == AVAuthorizationStatus.denied {
            print("カメラ アクセス許可なし")
        }
        
    }
}

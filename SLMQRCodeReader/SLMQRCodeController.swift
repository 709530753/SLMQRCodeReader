//
//  SLMQRCodeController.swift
//  SLMQRCodeReader
//
//  Created by fengxin on 29/01/2018.
//  Copyright © 2018 fengxin. All rights reserved.
//

import UIKit
import AVFoundation

class SLMQRCodeController: UIViewController,UINavigationControllerDelegate,AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate {

  var slmQRContent: ((_ content: String) ->Void)?

  private var device: AVCaptureDevice!
  private var input: AVCaptureInput!
  private var output: AVCaptureMetadataOutput!
  private var session: AVCaptureSession!
  private var preview: AVCaptureVideoPreviewLayer!
  private let ScreenWidth = UIScreen.main.bounds.size.width
  private let ScreenHeight = UIScreen.main.bounds.size.height
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initDevice()
    setupUI()
  }
  
  //创建UI
  func setupUI() -> Void {
    
    let btn = UIButton(type:UIButtonType.custom)
    btn.frame = CGRect.init(x: 10, y: 10, width: 80, height: 40)
    btn.setTitle("cancel", for: UIControlState.normal)
    btn.setTitleColor(UIColor.white, for: UIControlState.normal)
    self.view.addSubview(btn)
    btn.addTarget(self, action: #selector(back), for: UIControlEvents.touchUpInside)
    
    let photoLibrary = UIButton(type:UIButtonType.custom)
    photoLibrary.frame = CGRect.init(x: ScreenWidth - 100, y: 10, width: 80, height: 40)
    photoLibrary.setTitle("library", for: UIControlState.normal)
    photoLibrary.setTitleColor(UIColor.white, for: UIControlState.normal)
    self.view.addSubview(photoLibrary)
    photoLibrary.addTarget(self, action: #selector(openLibrary), for: UIControlEvents.touchUpInside)
    
    
  }
  
  func initDevice(){
    // Device
    self.device = AVCaptureDevice.default(for: AVMediaType.video)
    // Input
    do {
      self.input = try AVCaptureDeviceInput(device: self.device)
    } catch {
      print("Input 初始化失败")
      return
    }
    
    // Output
    self.output = AVCaptureMetadataOutput()
    
    // Session
    self.session = AVCaptureSession()
//    self.session.sessionPreset = AVCaptureSession.Preset.high
    if self.session.canAddInput(self.input){
      self.session.addInput(self.input)
    } else {
      print("Session Add Input 初始化失败")
      return
    }
    
    if self.session.canAddOutput(self.output) {
      self.session.addOutput(self.output)
    } else {
      print("Session Add Output 初始化失败")
      return
    }
    
    // 条码类型 AVMetadataObjectTypeQRCode
    self.output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
    
    self.output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)

    // Preview
    self.preview = AVCaptureVideoPreviewLayer(session: self.session)
    self.preview.videoGravity = AVLayerVideoGravity.resizeAspectFill
    self.preview.frame = self.view.layer.bounds
    self.view.layer.addSublayer(self.preview)
    
    self.output.rectOfInterest = CGRect.init(x: 0.2, y:  0.2, width: 0.8, height: 0.8)//感兴趣的区域，设置为中心，否则全屏可扫
    // Start
    self.session.startRunning()
  }
  
  //MARK: CaptureOutputDelegate
  func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
    let stringValue: String?
    if metadataObjects.count > 0 {
      // 停止扫描
      self.session.stopRunning()
      
      if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
        stringValue = metadataObject.stringValue
        print("stringValue : \(String(describing: stringValue))")
        self.slmQRContent!(stringValue!)
        
        //back
        self.back()
      }
    }
  }
  
  //识别二维码图片
  func readImage(image:UIImage) -> Void {
    let ciImage:CIImage=CIImage(image:image)!
    
    let context = CIContext(options: nil)
    let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: context,
                              options: [CIDetectorAccuracy:CIDetectorAccuracyHigh])
    
    let features = detector?.features(in: ciImage)
    
    print("扫描到二维码个数：\(features?.count ?? 0)")
    //遍历所有的二维码，并框出
    for feature in features as! [CIQRCodeFeature] {
      print("message : \(feature.messageString!)")
    }
    if features?.count != 0 {
      let qrContent = features![0] as! CIQRCodeFeature
      slmQRContent!(qrContent.messageString!)
    }

    self.back()
  }
  
  //选择图片成功后代理
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [String : Any]) {
    //查看info对象
    print(info)
    
    //显示的图片
    let image:UIImage!
      image = info[UIImagePickerControllerOriginalImage] as! UIImage
    print("image : \(image!)")
    self.readImage(image: image!)
    //图片控制器退出
    picker.dismiss(animated: true, completion: {
      () -> Void in
    })
  }

  
  
  @objc func openLibrary() -> Void {
  
    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
      //初始化图片控制器
      let picker = UIImagePickerController()
      //设置代理
      picker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
      //指定图片控制器类型
      picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
      //设置是否允许编辑
//      picker.allowsEditing = editSwitch.isOn
      //弹出控制器，显示界面
      self.present(picker, animated: true, completion: {
        () -> Void in
      })
    }else{
      print("读取相册错误")
    }
    
  }
  
  @objc func back() -> Void {
    dismiss(animated: true, completion: nil)
  }
  
}
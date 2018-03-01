//
//  SLMQRCodeController.swift
//  SLMQRCodeReader
//
//  Created by fengxin on 29/01/2018.
//  Copyright © 2018 fengxin. All rights reserved.
//

import UIKit
import AVFoundation

class SLMQRCodeController: UIViewController,
             UINavigationControllerDelegate,
     AVCaptureMetadataOutputObjectsDelegate,
            UIImagePickerControllerDelegate {

  var slmQRContent: ((_ content: String) ->Void)?
  var timer:Timer?
  var minutes:Int = 1;
  var redView:UIView!
  var activityIndicatorView = UIActivityIndicatorView()
  
  
  
  private var device: AVCaptureDevice!
  private var input: AVCaptureInput!
  private var output: AVCaptureMetadataOutput!
  private var session: AVCaptureSession!
  private var preview: AVCaptureVideoPreviewLayer!
  private let ScreenWidth:CGFloat = UIScreen.main.bounds.size.width
  private let ScreenHeight:CGFloat = UIScreen.main.bounds.size.height
  
  override func viewDidLoad() {
    super.viewDidLoad()
    initDevice()
    setupUI()
    
    timer = Timer.init(timeInterval: 0.01, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
    RunLoop.current.add(timer!, forMode: RunLoopMode.defaultRunLoopMode)
  }
  
  //创建UI
  func setupUI() -> Void {
    
    let factory = SLMFactory()
    _ = factory.createBtn(context: self,
                            frame: CGRect(x: 10, y: 15, width: 80, height: 40),
                            title: NSLocalizedString("Common_Cancel", comment: "Cancel"),
                           action:  #selector(back))
    
    _ = factory.createBtn(context: self,
                            frame: CGRect(x: ScreenWidth - 80, y: 15, width: 80, height: 40),
                            title: NSLocalizedString("Common_Library", comment: "Library"),
                           action: #selector(openLibrary))
    
    let leftSpacing:CGFloat = 80.0;
    let centerViewWith:CGFloat = ScreenWidth - leftSpacing * 2;
    factory.createBezierPath(context: self,
                           movePoint: CGPoint(x: leftSpacing , y: ScreenHeight/2  - (centerViewWith/2 - 50)),
                         centerPoint: CGPoint(x: leftSpacing , y: ScreenHeight/2 - centerViewWith/2),
                            endPoint: CGPoint(x: leftSpacing + 50, y: ScreenHeight/2 - centerViewWith/2))
    
    factory.createBezierPath(context: self,
                           movePoint: CGPoint(x: leftSpacing + centerViewWith - 50, y: ScreenHeight/2 - centerViewWith/2),
                         centerPoint: CGPoint(x: leftSpacing + centerViewWith, y: ScreenHeight/2 - centerViewWith/2),
                            endPoint: CGPoint(x: leftSpacing + centerViewWith , y: ScreenHeight/2 - centerViewWith/2 + 50))
    
    factory.createBezierPath(context: self,
                           movePoint: CGPoint(x: leftSpacing , y: ScreenHeight/2 + (centerViewWith/2 - 50)),
                         centerPoint: CGPoint(x: leftSpacing , y: ScreenHeight/2 + centerViewWith/2),
                            endPoint: CGPoint(x: leftSpacing + 50, y: ScreenHeight/2 + centerViewWith/2))
    
    factory.createBezierPath(context: self,
                           movePoint: CGPoint(x: leftSpacing + centerViewWith - 50, y: ScreenHeight/2 + centerViewWith/2),
                         centerPoint: CGPoint(x: leftSpacing + centerViewWith , y: ScreenHeight/2 + centerViewWith/2),
                            endPoint: CGPoint(x: leftSpacing + centerViewWith , y: ScreenHeight/2 + centerViewWith/2 - 50))
    self.redView = factory.createLineView()
    view.addSubview(self.redView)
    
    self.redView.frame = CGRect.init(x: leftSpacing, y: (ScreenHeight - centerViewWith)/2, width: centerViewWith, height: 2)
    activityIndicatorView.frame = CGRect(x:ScreenWidth/2 - 10,y:ScreenHeight/2 - 10,width:20,height:20)
    view.addSubview(activityIndicatorView)
  }
  
  func initDevice(){
    // Device
    self.device = AVCaptureDevice.default(for: AVMediaType.video)
    // Input
    do {
      let isSim = SLMHelps.Platform.isSimulator
      if isSim {
        
      } else {
        self.input = try AVCaptureDeviceInput(device: self.device)
      }
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
  
  //选择图片成功后代理
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [String : Any]) {
    //查看info对象
    print(info)
    
    //显示的图片
    let image:UIImage!
      image = info[UIImagePickerControllerOriginalImage] as! UIImage
    print("image : \(image!)")
    self.activityIndicatorView.startAnimating()
    DispatchQueue.global().async {
      let qrContent = image.recognizeQRCode()
      let result = qrContent.characters.count > 0 ? qrContent : ""
      DispatchQueue.main.async {
        self.activityIndicatorView.stopAnimating()
        self.slmQRContent!(result)
      }
    }

    self.back()
    //图片控制器退出
    picker.dismiss(animated: true, completion: {
      () -> Void in
    })
    self.back();
  }
  
  //timer run
  @objc func timerFired() -> Void {
    self.minutes += 1
    let redViewY = CGFloat(self.minutes)

    if redViewY == (ScreenHeight - (ScreenWidth - 80 * 2))/2 - 4 {
      self.minutes = 1
    } else {
      self.redView.frame = CGRect.init(x: 80, y: (ScreenHeight - (ScreenWidth - 80 * 2))/2 + redViewY, width:  (ScreenWidth - 80 * 2), height: 2)
    }
  }
  
  @objc func openLibrary() -> Void {
  
    if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
      //初始化图片控制器
      let picker = UIImagePickerController()
      //设置代理
      picker.delegate = self as UIImagePickerControllerDelegate & UINavigationControllerDelegate
      //指定图片控制器类型
      picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
      picker.allowsEditing = true
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
    timer?.invalidate()
    timer = nil
    dismiss(animated: true, completion: nil)
  }
  
  deinit {
    timer?.invalidate()
    timer = nil
  }
  
}

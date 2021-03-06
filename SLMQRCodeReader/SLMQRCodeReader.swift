//
//  SLMQRCodeReaderImpl.swift
//  SLMQRCodeReader
//
//  Created by fengxin on 29/01/2018.
//  Copyright © 2018 fengxin. All rights reserved.
//

import UIKit

public class SLMQRCodeReader: NSObject {
  
  @objc
  public var qrCodeContent:((_ content:String) ->Void)?

  @objc
  public func showQRReader(controller: UIViewController) ->Void {
    print("showQRReader")
    let qrController:SLMQRCodeController = SLMQRCodeController()
    if SLMHelps.Platform.isSimulator {
      print("is simulator please use a device")
    } else {
      controller.present(qrController, animated: true, completion: nil)
    }
    qrController.slmQRContent = { content in
      print("content : \(content)")
      self.qrCodeContent!(content)
      }
  }
}

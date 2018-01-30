//
//  SLMQRCodeReaderImpl.swift
//  SLMQRCodeReader
//
//  Created by fengxin on 29/01/2018.
//  Copyright © 2018 fengxin. All rights reserved.
//

import UIKit

public class SLMQRCodeReader: NSObject {
  
  public var qrCodeContent:((_ content:String) ->Void)?

  public func showQRReader(controller: UIViewController) ->Void {
    print("showQRReader")
    let qrController:SLMQRCodeController = SLMQRCodeController()
    controller.present(qrController, animated: true, completion: nil)
    qrController.slmQRContent = { content in
      print("content : \(content)")
      self.qrCodeContent!(content)
      }
  }
}

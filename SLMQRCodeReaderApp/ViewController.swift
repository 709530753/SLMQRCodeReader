//
//  ViewController.swift
//  SLMQRCodeReaderApp
//
//  Created by fengxin on 29/01/2018.
//  Copyright © 2018 fengxin. All rights reserved.
//

import UIKit
import SLMQRCodeReader

class ViewController: UIViewController {

  @IBOutlet weak var content: UILabel!
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let qrCode = SLMQRCodeReader()
    qrCode.showQRReader(controller: self)
    qrCode.qrCodeContent = { content in
      NSLog("content : %@", content)
      self.content.text = content
    }
    
  }
  
}


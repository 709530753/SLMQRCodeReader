//
//  PlatformHelps.swift
//  SLMQRCodeReader
//
//  Created by fengxin on 07/02/2018.
//  Copyright © 2018 fengxin. All rights reserved.
//

class SLMHelps: NSObject {
  
  struct Platform {
    
    static let isSimulator: Bool = {
      var isSim = false
      #if arch(i386) || arch(x86_64)
        isSim = true
      #endif
      return isSim
    }()
  }
  
}




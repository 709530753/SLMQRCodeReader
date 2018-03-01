//
//  File.swift
//  SLMQRCodeReader
//
//  Created by fengxin on 01/03/2018.
//  Copyright © 2018 fengxin. All rights reserved.
//

import Foundation
import CoreImage

extension UIImage {
  
  /*
   识别图片二维码
   */
  func recognizeQRCode() -> String {
    let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy : CIDetectorAccuracyHigh])
    let features = detector?.features(in: CoreImage.CIImage(cgImage: self.cgImage!))
    guard (features?.count)! > 0 else { return "" }
    let feature = features?.first as? CIQRCodeFeature
    return (feature?.messageString)!
  }
  
}

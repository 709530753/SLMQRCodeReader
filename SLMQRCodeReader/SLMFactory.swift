//
//  SLMFactory.swift
//  SLMQRCodeReader
//
//  Created by fengxin on 29/01/2018.
//  Copyright © 2018 fengxin. All rights reserved.
//

import UIKit

class SLMFactory: NSObject {

  //创建button
   func createBtn(context:UIViewController,frame:CGRect,title:String,action:Selector) -> UIButton {
    let btn = UIButton(type:UIButtonType.custom)
    btn.frame = frame
    btn.setTitle(title, for: UIControlState.normal)
    btn.setTitleColor(UIColor.white, for: UIControlState.normal)
    btn.addTarget(context, action: action, for: UIControlEvents.touchUpInside)
    context.view.addSubview(btn)
    return btn
  }
  
  //createShapeLayer
  func createShapeLayer(context:UIViewController,path:UIBezierPath) -> Void {
    let layer = CAShapeLayer()
    layer.lineWidth = 2
    layer.strokeColor = UIColor.green.cgColor
    layer.path = path.cgPath
    layer.fillColor = nil
    context.view.layer.addSublayer(layer)
  }
  //绘制路线
  func createBezierPath(context:UIViewController,movePoint:CGPoint,centerPoint:CGPoint,endPoint:CGPoint) -> Void {
    let path = UIBezierPath()
    path.move(to: movePoint)
    path.addLine(to: centerPoint)
    path.addLine(to: endPoint)
    self.createShapeLayer(context: context, path: path)
  }
  
  func createLineView() -> UIView {
    let view = UIView()
    view.backgroundColor = UIColor.red
    view.layer.shadowColor = UIColor.red.cgColor
    view.layer.shadowOffset = CGSize(width: 0, height: -10)
    view.layer.shadowOpacity = 1
    view.layer.shadowRadius = 10
    return view
  }
  
}

//
//  Test.swift
//  instanttransmission
//
//  Created by Nishan Bende on 07/05/22.
//



import Foundation
import HotKey

@objc class Test: NSObject {
  let hotKey: HotKey
  override init(){
    print("hello world")
    
    hotKey = HotKey(key: .downArrow, modifiers: [.command, .shift])
    hotKey.keyDownHandler = {
      print("Pressed at \(Date())")
    }
  }
  
}

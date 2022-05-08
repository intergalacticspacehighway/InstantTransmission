import Foundation
import HotKey


@objc(InstantTransmissionModule)
class InstantTransmissionModule: RCTEventEmitter {
  let recordCursorShortcut: HotKey
  let moveCursorShortcut: HotKey
  let RECORD_CURSOR_EVENT = "recordCursor"
  let MOVE_CURSOR_EVENT = "moveCursor"

  
  override func supportedEvents() -> [String]? {
    return [RECORD_CURSOR_EVENT, MOVE_CURSOR_EVENT];
  }
  
  override init() {
    recordCursorShortcut = HotKey(key: .downArrow, modifiers: [.command, .shift])
    moveCursorShortcut = HotKey(key: .rightArrow, modifiers: [.command, .shift])
   
    super.init()
    
    initializeListener();
  }
  
  func initializeListener() {
    moveCursorShortcut.keyDownHandler = {
      self.sendEvent(withName: self.MOVE_CURSOR_EVENT, body: ["name": "moveCursor"]);
    }
    
    recordCursorShortcut.keyDownHandler = {
      self.sendEvent(withName: self.RECORD_CURSOR_EVENT, body: ["name": "recordCursor"]);
    }
    
  }
  
  @objc func getName() { // Assume name comes from the any native API side
//    successCallback(["SWIFT native Module"])
    print("hi");
  }
}

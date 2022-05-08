import Foundation
import HotKey


@objc(InstantTransmissionModule)
class InstantTransmissionModule: RCTEventEmitter {
  let recordCursorShortcut: HotKey
  let moveCursorShortcutFirst: HotKey
  let moveCursorShortcutSecond: HotKey
  let moveCursorShortcutThird: HotKey
  
  let RECORD_CURSOR_EVENT = "recordCursor"
  let MOVE_CURSOR_EVENT = "moveCursor"

  
  override func supportedEvents() -> [String]? {
    return [RECORD_CURSOR_EVENT, MOVE_CURSOR_EVENT];
  }
  
  override init() {
    recordCursorShortcut = HotKey(key: .zero, modifiers: [.command, .shift])
    
    moveCursorShortcutFirst = HotKey(key: .seven, modifiers: [.command, .shift])
    moveCursorShortcutSecond = HotKey(key: .eight, modifiers: [.command, .shift])
    moveCursorShortcutThird = HotKey(key: .nine, modifiers: [.command, .shift])
   
    super.init()
    
    initializeListener();
  }
  
  func initializeListener() {
    moveCursorShortcutFirst.keyDownHandler = {
      self.sendEvent(withName: self.MOVE_CURSOR_EVENT, body: ["name": "moveCursor", "index"
                                                              : 0]);
    }
    
    moveCursorShortcutSecond.keyDownHandler = {
      self.sendEvent(withName: self.MOVE_CURSOR_EVENT, body: ["name": "moveCursor", "index"
                                                              : 1]);
    }
    
    moveCursorShortcutThird.keyDownHandler = {
      self.sendEvent(withName: self.MOVE_CURSOR_EVENT, body: ["name": "moveCursor", "index"
                                                              : 2]);
    }
    
    recordCursorShortcut.keyDownHandler = {
      let mousePosition = CGPoint(x: NSEvent.mouseLocation.x, y: (NSScreen.main?.frame.size.height)! - NSEvent.mouseLocation.y)
      self.sendEvent(withName: self.RECORD_CURSOR_EVENT, body: ["x": mousePosition.x, "y": mousePosition.y]);
    }
    
  }
  

  @objc func moveCursorTo(_ x: Double, y: Double) {
    let position = NSPoint(x: x, y: y);
    CGWarpMouseCursorPosition(position);
  }
}

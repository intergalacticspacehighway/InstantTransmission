import Foundation
import HotKey
import LaunchAtLogin
import SwiftUI


@objc(InstantTransmissionModule)
class InstantTransmissionModule: RCTEventEmitter {
  let recordCursorShortcut: HotKey
  let moveCursorShortcutFirst: HotKey
  let moveCursorShortcutSecond: HotKey
  let moveCursorShortcutThird: HotKey
  
  let RECORD_CURSOR_EVENT = "recordCursor"
  let MOVE_CURSOR_EVENT = "moveCursor"
  let LAUNCH_AT_LOGIN_CHANGE_EVENT = "launchAtLoginChange"
  let storageKey = "_InstantTransmissionModule_"

  
  override func supportedEvents() -> [String]? {
    return [RECORD_CURSOR_EVENT, MOVE_CURSOR_EVENT, LAUNCH_AT_LOGIN_CHANGE_EVENT];
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
      let mousePosition = CGPoint(x: NSEvent.mouseLocation.x, y: NSEvent.mouseLocation.y)
      self.sendEvent(withName: self.RECORD_CURSOR_EVENT, body: ["x": mousePosition.x, "y": mousePosition.y]);
    }
    
  }
  

  @objc func moveCursorTo(_ x: Double, y: Double) {
    let mousePositionFromTopLeftOrigin = CGPoint(x: x, y: (NSScreen.main?.frame.size.height)! - y);
    CGWarpMouseCursorPosition(mousePositionFromTopLeftOrigin);
   
    DispatchQueue.main.async {

      let indicatorHeight = 200.0;
      let indicatorWidth = 200.0;
      
      let contentView = Circle()
                .stroke(lineWidth: 4)
                .foregroundColor(.primary)
                .frame(width: indicatorWidth, height: indicatorHeight)
                .padding(2)
                .shadow(color: .black, radius: 10, x: 10, y: 10)
      
      let window = NSWindow(
                contentRect: NSRect(x: x - indicatorWidth / 2, y: y - indicatorHeight / 2, width: indicatorWidth, height: indicatorHeight),
                styleMask: [.borderless],
                backing: .buffered,
                defer: false
            )
      window.contentView = NSHostingView(rootView: contentView)
      window.backgroundColor = .clear
      window.level = NSWindow.Level.statusBar
      window.makeKeyAndOrderFront(nil)
      
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
         
        window.orderOut(self);
      }
    }



  }
  
  @objc func toggleLaunchAtLogin() {
    LaunchAtLogin.isEnabled = !LaunchAtLogin.isEnabled;
    self.sendEvent(withName: self.LAUNCH_AT_LOGIN_CHANGE_EVENT, body: LaunchAtLogin.isEnabled);
  }
  
  @objc func launchAtLoginEnabled(_ callback: RCTResponseSenderBlock) {
    callback([LaunchAtLogin.isEnabled]);
  }
  
  @objc func persistData(_ data:String) {
    let defaults = UserDefaults.standard;
    defaults.set(data, forKey: storageKey)
  }
  
  @objc func getPersistedData(_ callback:RCTResponseSenderBlock) {
    let defaults = UserDefaults.standard;
    if let data = defaults.string(forKey: storageKey) {
      callback([data]);
    }
  }
}

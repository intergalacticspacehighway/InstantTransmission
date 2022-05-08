#import "AppDelegate.h"

#import <React/RCTBridge.h>
#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>
#import "instanttransmission-Swift.h"

@interface AppDelegate () <RCTBridgeDelegate>

@end

@implementation AppDelegate
NSStatusItem* statusBarItem;
NSPopover* popover;

- (void)awakeFromNib {
  [super awakeFromNib];

  _bridge = [[RCTBridge alloc] initWithDelegate:self launchOptions:nil];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  // Insert code here to initialize your application
  
  RCTRootView *rootView = [[RCTRootView alloc] initWithBridge:_bridge moduleName:@"instanttransmission" initialProperties:nil];
  

  NSViewController* rootViewController = [[NSViewController alloc] init];
  rootViewController.view = rootView;

  popover = [[NSPopover alloc] init];

  popover.contentSize = NSMakeSize(700, 800);
  popover.animates = true;
  popover.behavior = NSPopoverBehaviorTransient;
  popover.contentViewController = rootViewController;

  statusBarItem = [NSStatusBar.systemStatusBar statusItemWithLength:60];
  statusBarItem.button.title = @"hello";
  statusBarItem.button.action = @selector(barItemAction:);
  
  Test* a = [[Test alloc] init];

}

-(void)barItemAction:(id) sender {
  if (popover.isShown) {
    [popover performClose:self];
  } else {
    [popover showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMaxYEdge];

    [popover.contentViewController.view.window becomeKeyWindow];


  }
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
  // Insert code here to tear down your application
}

#pragma mark - RCTBridgeDelegate Methods

- (NSURL *)sourceURLForBridge:(__unused RCTBridge *)bridge {
  return [[RCTBundleURLProvider sharedSettings] jsBundleURLForBundleRoot:@"index" fallbackResource:@"main"]; // .jsbundle;
}

@end

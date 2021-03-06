#import "AppDelegate.h"

#import <React/RCTBridge.h>
#import <React/RCTBundleURLProvider.h>
#import <React/RCTRootView.h>


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

  popover.contentSize = NSMakeSize(200, 250);
  popover.animates = true;
  popover.behavior = NSPopoverBehaviorTransient;
  popover.contentViewController = rootViewController;

  statusBarItem = [NSStatusBar.systemStatusBar statusItemWithLength: 20];

  NSImage* appIcon = [NSApp applicationIconImage];



  statusBarItem.button.image = appIcon;
  statusBarItem.button.image.size = NSMakeSize(20, 20);;
  
  statusBarItem.button.action = @selector(barItemAction:);

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

//
//  RNMPRemoteCommandCenterManager.h
//  RNMPRemoteCommandCenterManager
//
//  Created by Chris LeBlanc on 4/4/16.
//  Copyright © 2016 Clever Lever. All rights reserved.
//

#import <React/RCTBridge.h>
#import <React/RCTBridgeModule.h>

@interface RNMPRemoteCommandCenterManager : NSObject <RCTBridgeModule>

- (void)setNowPlayingInfo: (NSDictionary*)info;
- (void)setElapsedPlaybackTime: (nonnull NSNumber*)elapsedPlaybackTime;

@end

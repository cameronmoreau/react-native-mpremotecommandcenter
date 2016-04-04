//
//  RNMPRemoteCommandCenter.m
//  RNMPRemoteCommandCenter
//
//  Created by Chris LeBlanc on 4/4/16.
//  Copyright © 2016 Clever Lever. All rights reserved.
//

#import "RNMPRemoteCommandCenter.h"

#import "RCTBridgeModule.h"
#import "RCTEventDispatcher.h"
#import "RCTConvert.h"
@import MediaPlayer;

@implementation RNMPRemoteCommandCenter

RCT_EXPORT_MODULE();

@synthesize bridge = _bridge;

// public api

RCT_REMAP_METHOD(
    setNowPlayingInfo:(NSDictionary *)info,
    resolver:(RCTPromiseResolveBlock)resolve,
    rejecter:(RCTPromiseRejectBlock)reject)
{
    NSString *albumTitle = [RCTConvert NSString:info[@"albumTitle"]];
    NSString *artist = [RCTConvert NSString:info[@"albumArtist"]];
    NSString *title = [RCTConvert NSString:info[@"title"]];
    NSString *artworkURL = [RCTConvert NSString:info[@"artworkURL"]];
    NSNumber *duration = [RCTConvert NSNumber:info[@"duration"]];
    
    NSURL *url = [[NSURL alloc]initWithString:artworkURL];
    NSData * data = [NSData dataWithContentsOfURL:url];
    UIImage * image = [UIImage imageWithData:data];
    
    MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc]initWithImage:image];
    NSDictionary *nowPlayingInfo = [NSDictionary dictionaryWithObjectsAndKeys:
        duration, MPMediaItemPropertyPlaybackDuration,
        albumTitle, MPMediaItemPropertyAlbumTitle, 
        albumArtist, MPMediaItemPropertyAlbumArtist, 
        title, MPMediaItemPropertyTitle, 
        artwork, MPMediaItemPropertyArtwork, nil];
    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = nowPlayingInfo;
}

// event handling

- (void)registerRemoteControlEvents
{
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    [commandCenter.playCommand addTarget:self action:@selector(didReceivePlayCommand:)];
    [commandCenter.pauseCommand addTarget:self action:@selector(didReceivePauseCommand:)];
    [commandCenter.nextTrackCommand addTarget:self action:@selector(didReceiveNextTrackCommand:)];
    [commandCenter.previousTrackCommand addTarget:self action:@selector(didReceivePreviousTrackCommand:)];
    commandCenter.stopCommand.enabled = NO;
    
}

- (void)didReceivePlayCommand:(MPRemoteCommand *)event
{
    [self.bridge.eventDispatcher sendDeviceEventWithName:@"RNMPRemoteCommandCenterEvent"
                                                    body:@"play"];
}

- (void)didReceivePauseCommand:(MPRemoteCommand *)event
{
    [self.bridge.eventDispatcher sendDeviceEventWithName:@"RNMPRemoteCommandCenterEvent"
                                                    body:@"pause"];
}

- (void)didReceiveNextTrackCommand:(MPRemoteCommand *)event
{
    [self.bridge.eventDispatcher sendDeviceEventWithName:@"RNMPRemoteCommandCenterEvent"
                                                    body:@"nextTrack"];
}

- (void)didReceivePreviousTrackCommand:(MPRemoteCommand *)event
{
    [self.bridge.eventDispatcher sendDeviceEventWithName:@"RNMPRemoteCommandCenterEvent"
                                                    body:@"prevTrack"];
}

- (void)unregisterRemoteControlEvents
{
    MPRemoteCommandCenter *commandCenter = [MPRemoteCommandCenter sharedCommandCenter];
    [commandCenter.playCommand removeTarget:self];
    [commandCenter.pauseCommand removeTarget:self];
}


@end
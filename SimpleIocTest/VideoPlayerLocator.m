//
//  VideoPlayerLocator.m
//  SimpleIoc
//
//  Created by qvod on 14/10/25.
//  Copyright (c) 2014年 YF. All rights reserved.
//

#import "VideoPlayerLocator.h"
#import "SimpleIoc.h"

@implementation VideoPlayerLocator
+(void)initLocator {
    [[SimpleIoc defaultInstance] registerInstance:NSProtocolFromString(@"IVideoPlayer") tClassName:NSClassFromString(@"VideoPlayer")];
//    [[SimpleIoc defaultInstance] registerInstance:NSProtocolFromString(@"IVideoSkin") tClassName:NSClassFromString(@"CellPlayer") createInstanceImmediately:NO key:@"cellPlayer"];
//    [[SimpleIoc defaultInstance] registerInstance:NSProtocolFromString(@"IVideoSkin") tClassName:NSClassFromString(@"FullScreenPlayer") createInstanceImmediately:NO key:@"fullPlayer"];
    [[SimpleIoc defaultInstance] registerInstance:NSClassFromString(@"CellPlayer")];
    [[SimpleIoc defaultInstance] registerInstance:NSClassFromString(@"FullScreenPlayer")];
    [[SimpleIoc defaultInstance] registerInstance:NSClassFromString(@"VideoEngine")];
}
@end

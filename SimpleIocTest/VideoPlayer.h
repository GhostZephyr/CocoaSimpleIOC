//
//  VideoPlayer.h
//  SimpleIoc
//
//  Created by qvod on 14/10/25.
//  Copyright (c) 2014年 YF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IVideoPlayer.h"
#import "IVideoSkin.h"

@interface VideoPlayer : NSObject<IVideoPlayer>
@property (weak,nonatomic) id<IVideoSkin> playService;
@end

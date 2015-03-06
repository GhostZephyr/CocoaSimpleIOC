//
//  VideoEngine.m
//  SimpleIoc
//
//  Created by qvod on 14/10/25.
//  Copyright (c) 2014年 YF. All rights reserved.
//

#import "VideoEngine.h"

@implementation VideoEngine
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"VideoEngine 构造了");
    }
    return self;
}

-(void)dealloc {
    NSLog(@"VideoEngine 销毁了");
}

-(void)Play {
    NSLog(@"播放引擎正在Play");
}
@end

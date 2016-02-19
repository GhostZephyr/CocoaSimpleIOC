//
//  CellPlayer.m
//  SimpleIoc
//
//  Created by qvod on 14/10/25.
//  Copyright (c) 2014年 YF. All rights reserved.
//

#import "CellPlayer.h"

@implementation CellPlayer
@synthesize myEngine;
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"FullScreenPlayer 被构造了");
    }
    return self;
}


-(ConstructorInfo *)getConstructorInfo {
    ConstructorInfo *ctor = [[ConstructorInfo alloc] init];
    ctor.buildSelectorString = NSStringFromSelector(@selector(build:));
    ctor.parameterTypes = [[NSMutableArray alloc] initWithObjects:[VideoEngine class], nil];
    return ctor;
}

-(void)build:(VideoEngine*)engine {
    self.myEngine = engine;
    self.fullPlayer = [[SimpleIoc defaultInstance] getInstance:[FullScreenPlayer class]];
    if(self.myEngine) {
        NSLog(@"播放引擎注入成功");
    }
    if(self.fullPlayer) {
        NSLog(@"FullPlayer 注入成功");
    }
}

-(void)doSomeThing {
    NSLog(@"CellPlayer 切换成功");
    [self.myEngine Play];
}


@end

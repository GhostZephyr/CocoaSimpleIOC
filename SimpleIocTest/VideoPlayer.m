//
//  VideoPlayer.m
//  SimpleIoc
//
//  Created by qvod on 14/10/25.
//  Copyright (c) 2014年 YF. All rights reserved.
//

#import "VideoPlayer.h"
#import "SimpleIoc.h"
@interface VideoPlayer()
@property NSDictionary *skinClassMap;
@end

@implementation VideoPlayer
@synthesize skinClassMap;
@synthesize playService;

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.skinClassMap = [[NSDictionary alloc] initWithObjectsAndKeys:@"FullScreenPlayer",@"fullPlayer",@"CellPlayer",@"cell", nil];
    }
    return self;
}

-(void)changeSkin:(NSString *)skinKey {
    NSString *classKey = self.skinClassMap[skinKey];
    self.playService  = [[SimpleIoc defaultInstance] getInstance:NSClassFromString(classKey)];
    if(self.playService) {
        [self.playService doSomeThing];
    }
}
@end

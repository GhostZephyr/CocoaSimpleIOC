//
//  MainViewModel.m
//  SimpleIoc
//
//  Created by qvod on 14-9-25.
//  Copyright (c) 2014年 YF. All rights reserved.
//

#import "MainViewModel.h"
#import "ITestServiceA.h"
@interface MainViewModel()
@property id<ITestServiceA> a;
@end
@implementation MainViewModel
-(ConstructorInfo *)getConstructorInfo {
    ConstructorInfo *ctor = [[ConstructorInfo alloc] init];
    ctor.parameterTypes = [[NSMutableArray alloc] initWithObjects:@protocol(ITestServiceA), nil];
    ctor.buildSelectorString = NSStringFromSelector((@selector(build:)));
    ctor.initializerSelectorString = NSStringFromSelector(@selector(init:));
    return ctor;
}

-(instancetype) init:(NSString*) key {
    self = [super init];
    if (self) {
        NSLog(@"recive value:%@",key);
    }
    return self;
}

-(void) build:(id<ITestServiceA>) a {
     NSLog(@"MainViewModel 已经构造 testServiceA已被注入");
    self.a = a;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"已初始化");
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"MainViewModel 已被销毁");
}
@end

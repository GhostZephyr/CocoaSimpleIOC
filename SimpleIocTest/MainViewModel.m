//
//  MainViewModel.m
//  SimpleIoc
//
//  Created by qvod on 14-9-25.
//  Copyright (c) 2014年 YF. All rights reserved.
//

#import "MainViewModel.h"
#import "ITestServiceA.h"
#import "ITestServiceB.h"
#import "SimpleIoc.h"

@interface MainViewModel()
@property id<ITestServiceA> a;
@property NSString* myKey;
@end
@implementation MainViewModel

simpleIoc_ctorInfoWithSelectorCustomInit(@selector(build:testB:), @selector(init:), @protocol(ITestServiceA))

//-(ConstructorInfo *)getConstructorInfo {
//    ConstructorInfo *ctor = [[ConstructorInfo alloc] init];
//    ctor.parameterTypes = [[NSMutableArray alloc] initWithObjects:@protocol(ITestServiceA), nil];
//    ctor.buildSelectorString = NSStringFromSelector(@selector(build:testB:));
//    ctor.initializerSelectorString = NSStringFromSelector(@selector(init:));
//    return ctor;
//}

-(instancetype) init:(NSString*) key {
    self = [super init];
    if (self) {
        NSLog(@"recive value:%@",key);
        self.myKey = key;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[SimpleIoc defaultInstance] simpleIocRequiresInjection:self];
    }
    return self;
}

-(void) build:(id<ITestServiceA>) a testB:(id<ITestServiceB>)b {
     NSLog(@"MainViewModel 已经构造 testServiceA已被注入");
    self.a = a;
}


-(void)isOK {
    NSLog(@"yes i'm ok myKey:%@",self.myKey);
}

- (void)dealloc
{
    NSLog(@"MainViewModel 已被销毁");
}
@end

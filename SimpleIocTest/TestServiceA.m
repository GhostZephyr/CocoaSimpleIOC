//
//  TestServiceA.m
//  SimpleIoc
//
//  Created by qvod on 14-9-25.
//  Copyright (c) 2014年 YF. All rights reserved.
//

#import "TestServiceA.h"
#import "ITestServiceB.h"
@interface TestServiceA()
@property id<ITestServiceB> b;
@end

@implementation TestServiceA

-(ConstructorInfo *)getConstructorInfo {
    ConstructorInfo *ctor = [[ConstructorInfo alloc] init];
    ctor.parameterTypes = [[NSMutableArray alloc] initWithObjects:@protocol(ITestServiceB), nil];
    return ctor;
}

-(void) build:(id<ITestServiceB>)b {
     NSLog(@"TestServiceA 已经构造 testServiceB已被注入");
    self.b = b;
}

@end

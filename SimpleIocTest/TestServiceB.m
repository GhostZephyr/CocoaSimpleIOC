//
//  TestServiceB.m
//  SimpleIoc
//
//  Created by qvod on 14-9-25.
//  Copyright (c) 2014年 YF. All rights reserved.
//

#import "TestServiceB.h"

@interface TestServiceB()
@property id<ITestServiceC> c;
@end

@implementation TestServiceB
-(ConstructorInfo *)getConstructorInfo {
    ConstructorInfo *ctor = [[ConstructorInfo alloc] init];
    ctor.parameterTypes = [[NSMutableArray alloc] initWithObjects:@protocol(ITestServiceC), nil];
    return ctor;
}

-(void) build:(id<ITestServiceC>)c {
    NSLog(@"TestServiceB 已经构造 testServiceC已被注入");
    self.c = c;
}

@end

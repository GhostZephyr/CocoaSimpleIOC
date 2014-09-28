//
//  TestServiceC.m
//  SimpleIoc
//
//  Created by qvod on 14-9-25.
//  Copyright (c) 2014年 YF. All rights reserved.
//

#import "TestServiceC.h"

@implementation TestServiceC
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"TestServiceC被构造了");
    }
    return self;
}
@end

//
//  ConstructorInfo.m
//  YFIOCLibrary
//
//  Created by qvod on 14-9-20.
//  Copyright (c) 2014年 YF. All rights reserved.
//

#import "ConstructorInfo.h"
#import "SimpleIocConst.h"
@implementation ConstructorInfo
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.buildSelectorString = BuildMethodName;
        self.initializerSelectorString = InitMethodName;
    }
    return self;
}
@end

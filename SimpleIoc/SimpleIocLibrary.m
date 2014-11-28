//
//  SimpleIocLibrary.m
//  SimpleIoc
//
//  Created by qvod on 14/11/17.
//  Copyright (c) 2014年 YF. All rights reserved.
//

#import "SimpleIocLibrary.h"

//const NSString *libSimpleIocLibraryCurrentVersion = @"2.1.0";

@implementation SimpleIocLibrary

+(instancetype)defaultInstance {
    static dispatch_once_t pred;
    __strong static SimpleIocLibrary *_default = nil;
    dispatch_once(&pred, ^{
        _default = [[self alloc]init];
    });
    return _default;
}

//version and log Begin
+ (NSString *)libVersion
{
    return @"2.1.0";
}

+ (void)openLog:(BOOL)openLog
{
    [[SimpleIocLibrary defaultInstance] setOpenLog:openLog];
}

- (NSString *)libVersion
{
    return [SimpleIocLibrary libVersion];
}


- (void)openLog:(BOOL)openLog
{
    [[SimpleIocLibrary defaultInstance] setOpenLog:openLog];
}

//version and log End



@end

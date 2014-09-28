//
//  ViewModelLocator.m
//  SimpleIoc
//
//  Created by qvod on 14-9-25.
//  Copyright (c) 2014年 YF. All rights reserved.
//

#import "ViewModelLocator.h"

@implementation ViewModelLocator
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [[SimpleIoc defaultInstance] registerInstance:[SampleUIViewControl class]];
        [[SimpleIoc defaultInstance] registerInstance:[MainViewModel class]];
        [[SimpleIoc defaultInstance] registerInstance:[MainViewModel class] createInstanceImmediately:NO key:@"OtherMainView"];
        [[SimpleIoc defaultInstance] registerInstance:@protocol(ITestServiceA) tClassName:[TestServiceA class]];
        [[SimpleIoc defaultInstance] registerInstance:@protocol(ITestServiceB) tClassName:[TestServiceB class]];
        [[SimpleIoc defaultInstance] registerInstance:@protocol(ITestServiceC) tClassName:[TestServiceC class]];
    }
    return self;
}
@end

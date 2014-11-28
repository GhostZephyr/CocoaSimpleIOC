//
//  SimpleIoc.h
//  YFIOCLibrary
//  IOCContainers from mvvmLight toolkit
//  从C# 移植
//  Created by ghostZephyr on 14-9-19.
//  Copyright (c) 2014年 YF. All rights reserved.
//

#import "ISimpleIoc.h"
#import "IConstructorProvider.h"
#import "ConstructorInfo.h"
#import "SimpleIocLibrary.h"

#define simpleIoc_register(value)       \
        if (![[SimpleIoc defaultInstance] isRegistered:value]) { \
            Class cls = NSClassFromString(value);   \
            if([[cls description] isEqualToString:value]) { \
                [[SimpleIoc defaultInstance] registerInstance:cls]; \
            } \
        } \

#define simpleIoc_required()   \
    [[SimpleIoc defaultInstance] simpleIocRequiresInjection:self]; \

#define simpleIoc_getInstanceClass(value) do { \
    if (![[SimpleIoc defaultInstance] isRegistered:NSStringFromClass(value)]) { \
        return [[SimpleIoc defaultInstance] getInstance:value];  \
    } else {    \
        return nil; \
}}while(0)


@interface SimpleIoc : NSObject <ISimpleIoc>
/**
 *  工厂单例
 *
 *  @return 工厂
 */
+(instancetype)defaultInstance;

-(id) getInstances;
@end


//
//  SimpleIoc.h
//  YFIOCLibrary
//  IOCContainers from mvvmLight toolkit
//  从C# 移植
//  Created by ghostZephyr on 14-9-19.
//  Copyright (c) 2014年 YF. All rights reserved.
//

#import "ISimpleIoc.h"
#import "SimpleIocConst.h"
#import "IConstructorProvider.h"

@interface SimpleIoc : NSObject <ISimpleIoc>
/**
 *  工厂单例
 *
 *  @return 工厂
 */
+(instancetype)defaultInstance;
@end

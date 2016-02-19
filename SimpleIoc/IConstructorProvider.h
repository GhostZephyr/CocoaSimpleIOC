//
//  IConstructorProvider.h
//  YFIOCLibrary
//
//  Created by qvod on 14-9-20.
//  Copyright (c) 2014年 YF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConstructorInfo.h"

@protocol IConstructorProvider <NSObject>

/**
 *  获取构造信息
 *
 *  @return 构造信息对象
 */
- (ConstructorInfo *)getConstructorInfo;

@end

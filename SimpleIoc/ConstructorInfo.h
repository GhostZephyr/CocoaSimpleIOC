//
//  ConstructorInfo.h
//  YFIOCLibrary
//
//  Created by qvod on 14-9-20.
//  Copyright (c) 2014年 YF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConstructorInfo : NSObject
/**
 *  储存Protocol
 */
@property(nonatomic,copy) NSMutableArray *parameterTypes;

/**
 *  储存自定义注入Selector
 */
@property(nonatomic,copy) NSString* buildSelectorString;

/**
 *  储存自定义构造Selector
 */
@property(nonatomic,copy) NSString* initializerSelectorString;

/**
 *  储存自定义构造参数
 */
@property(nonatomic,copy) NSMutableArray *arguments;
@end

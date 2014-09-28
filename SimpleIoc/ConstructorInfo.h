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
 *  buildMethod Selector String
 */
@property(nonatomic,copy) NSString* buildSelectorString;
@end

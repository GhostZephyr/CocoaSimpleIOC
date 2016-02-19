//
//  SimpleIocLibrary.h
//  SimpleIoc
//
//  Created by qvod on 14/11/17.
//  Copyright (c) 2014年 YF. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface SimpleIocLibrary : NSObject
/**
 *  工厂单例
 *
 *  @return 工厂
 */
+ (instancetype)defaultInstance;

@property (nonatomic, assign) BOOL openLog;


/**
 *  版本号
 *
 *  @return <#return value description#>
 */
+ (NSString *)libVersion;

/**
 *  是否打开log 信息
 *  默认不打开
 *  @param open <#open description#>
 */
+ (void)openLog:(BOOL)openLog;


- (NSString *)libVersion;

- (void)openLog:(BOOL)openLog;

@end

//
//  IServiceLocator.h
//  YFIOCLibrary
//
//  Created by qvod on 14-9-19.
//  Copyright (c) 2014年 YF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IServiceProvider.h"

@protocol IServiceLocator <IServiceProvider>

/*
 *  根据类型获取对象
 *  @param className  服务类型的名字
 *  @return 对象
 */
-(id) getInstance:(Class) className;

/*
 *  根据类型与值获取对象
 *  @param className  服务类型的名字
 *  @param classKey 类的唯一标识
 *  @return 对象
 */
-(id) getInstance:(Class) className key:(NSString*)classKey;

/*
 *  根据类型获取所有对象
 *  @param className  服务类型的名字
 *  @return 所有注入的对象
 */
-(NSArray*) getAllInstance:(Class) className;

@end

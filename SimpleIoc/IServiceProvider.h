//
//  IServiceProvider.h
//  YFIOCLibrary
//
//  Created by qvod on 14-9-19.
//  Copyright (c) 2014年 YF. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IServiceProvider  <NSObject>

/*
 *  获取制定类型的服务对象
 *  @param className  服务类型的名字
 *  @return 对象
 */
-(id) getSerivce:(NSString*) className;
@end

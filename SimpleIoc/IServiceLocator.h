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
- (id)getInstance:(Class) className;

/*
 *  根据类型与值获取对象
 *  @param className  服务类型的名字
 *  @param classKey 类的唯一标识
 *  @return 对象
 */
- (id)getInstance:(Class) className key:(NSString*)classKey;

/**
 *  根据类型获取自定义构造函数对象
 *
 *  @param className 对象类型
 *  @param args      构造函数参数
 *
 *  @return 对象
 */
- (id)getInstanceWithArguments:(Class)className arguments:(NSArray*)args;

/**
 *  根据类型获取自定义构造函数对象
 *
 *  @param className 对象类型
 *  @param args      构造函数参数
 *  @param classKey  键值
 *
 *  @return 对象
 */
- (id)getInstanceWithArguments:(Class)className arguments:(NSArray*)args key:(NSString *)classKey;


/**
 *  根据协议类型获取对象
 *
 *  @param protocol 协议名
 *
 *  @return 对象
 */
- (id)getInstanceByProtocol:(Protocol*) protocol;

/**
 *  根据协议类型获取对象
 *
 *  @param protocol 协议名
 *  @param key      类的唯一标识
 *
 *  @return 对象
 */
- (id)getInstanceByProtocol:(Protocol*) protocol protocolKey:(NSString*)key;

/**
 *  根据协议类型获取自定义构造对象
 *
 *  @param protocol 协议类型
 *  @param args     构造函数参数
 *
 *  @return 对象
 */
- (id)getInstanceByProtocolWithArguments:(Protocol *)protocol arguments:(NSArray*)args;

/**
 *  根据协议类型获取自定义构造对象
 *
 *  @param protocol 协议类型
 *  @param args     构造函数参数
 *  @param key      键值
 *
 *  @return 对象
 */
- (id)getInstanceByProtocolWithArguments:(Protocol *)protocol arguments:(NSArray*)args protocolKey:(NSString *)key;


/*
 *  根据类型获取所有对象
 *  @param className  服务类型的名字
 *  @return 所有注入的对象
 */
-(NSArray*) getAllInstance:(Class) className;

@end

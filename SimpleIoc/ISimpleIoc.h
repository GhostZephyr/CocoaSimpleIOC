//
//  ISimpleIoc.h
//  YFIOCLibrary
//
//  Created by qvod on 14-9-19.
//  Copyright (c) 2014年 YF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IServiceLocator.h"

@protocol ISimpleIoc <IServiceLocator>

/*
 *  检测该类型是否注入
 *  @param className  服务类型的名字
 *  @return 是否注入
 */
-(BOOL) containCreated:(NSString*) className;

/*
 *  检测该对象是否已经创建
 *  @param className  服务类型的名字
 *  @param classKey   类型的值
 *  @return 是否注入
 */
-(BOOL) containCreated:(NSString*) className key:(NSString*)classKey;

/**
 *  检测该类型是否已经注入
 *
 *  @param className 类型名
 *
 *  @return 结果
 */
-(BOOL) isRegistered:(NSString*) className;

/**
 *  检测该类型该键值是否已经注入
 *
 *  @param className 类型名
 *  @param classKey  键值
 *
 *  @return 结果
 */
-(BOOL) isRegistered:(NSString*) className key:(NSString*)classKey;

/**
 *  注册接口的实现类
 *
 *  @param interfaceName 接口类型
 *  @param className     实现类类型
 */
-(void) registerInstance:(Protocol*) interfaceName tClassName:(Class) className;

/**
 *  注册接口的实现类
 *
 *  @param interfaceName             接口
 *  @param className                 类
 *  @param createInstanceImmediately 是否立即生成
 */
-(void) registerInstance:(Protocol*) interfaceName tClassName:(Class) className createInstanceImmediately:(BOOL)createInstanceImmediately;

/**
 *  注册接口的实现类 使用key区分
 *
 *  @param interfaceName             接口类型
 *  @param className                 实现类类型
 *  @param createInstanceImmediately 是否立即生成
 *  @param classKey                  唯一键值
 */
-(void) registerInstance:(Protocol*) interfaceName tClassName:(Class) className createInstanceImmediately:(BOOL)createInstanceImmediately key:(NSString*)classKey;

/**
 *  注册对象
 *
 *  @param className 对象类型
 */
-(void) registerInstance:(Class) className;

/**
 *  注册对象
 *
 *  @param className                 对象类型
 *  @param createInstanceImmediately 是否立即生成
 */
-(void) registerInstance:(Class) className createInstanceImmediately:(BOOL)createInstanceImmediately;

/**
 *  注册对象
 *
 *  @param className                 对象类型
 *  @param createInstanceImmediately 是否立即生成
 *  @param classKey                  键值
 */
-(void) registerInstance:(Class) className createInstanceImmediately:(BOOL)createInstanceImmediately key:(NSString*)classKey;

/**
 *  注册对象 自定义工厂
 *
 *  @param className 对象类型
 *  @param factory   工厂闭包
 */
-(void) registerInstance:(Class) className factory:(id(^)(NSString *className, NSArray *args))factory;

/**
 *  注册对象 自定义工厂
 *
 *  @param className                 对象类型
 *  @param factory                   工厂闭包
 *  @param createInstanceImmediately 是否立即创建
 */
-(void) registerInstance:(Class) className factory:(id(^)(NSString *className, NSArray *args))factory createInstanceImmediately:(BOOL)createInstanceImmediately;
/**
 *  注册对象 自定义工厂
 *
 *  @param className 对象类型
 *  @param factory   工厂闭包
 *  @param classKey  键值
 */
-(void) registerInstance:(Class) className factory:(id(^)(NSString *className, NSArray *args))factory
                     key:(NSString*)classKey;
/**
 *  注册对象 自定义工厂
 *
 *  @param className                 对象类型
 *  @param factory                   工厂闭包
 *  @param classKey                  键值
 *  @param createInstanceImmediately 是否立即创建
 */
-(void) registerInstance:(Class) className factory:(id(^)(NSString *className, NSArray *args))factory
                     key:(NSString*)classKey createInstanceImmediately:(BOOL)createInstanceImmediately;
/**
 *  重置
 */
-(void) reset;

/**
 *  注销对象
 *
 *  @param className 对象类型
 */
-(void) unRegisterInstance:(NSString*) className;

/**
 *  注销对象
 *
 *  @param className 对象类型
 *  @param instance  对象实例
 */
-(void) unRegisterInstance:(NSString*) className instance:(id)instance;

/**
 *  注销对象
 *
 *  @param className 对象类型
 *  @param classKey  键值
 */
-(void) unRegisterInstance:(NSString*) className key:(NSString*)classKey;

/**
 *  获取注入信息(可以在非工厂注册的实例中使用 并获取需要注入的信息)
 *
 *  @param instance 非工厂构造的实例
 */
-(void) simpleIocRequiresInjection:(id)instance;
@end

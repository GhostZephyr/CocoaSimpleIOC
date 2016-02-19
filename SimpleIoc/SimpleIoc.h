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

#define simpleIoc_WEAK_SELF __typeof(&*self) __weak weakSelf = self
#define simpleIoc_STRONG_SELF __typeof(&*self) __strong strongSelf = weakSelf

#define simpleIoc_register(value)       \
if (![[SimpleIoc defaultInstance] isRegistered:value]) { \
Class cls = NSClassFromString(value);   \
if([[cls description] isEqualToString:value]) { \
[[SimpleIoc defaultInstance] registerInstance:cls]; \
} \
}

#define simpleIoc_registerCreate(value)       \
if (![[SimpleIoc defaultInstance] isRegistered:value]) { \
Class cls = NSClassFromString(value);   \
if([[cls description] isEqualToString:value]) { \
[[SimpleIoc defaultInstance] registerInstance:cls createInstanceImmediately:YES]; \
} \
}


#define simpleIoc_registerInterface(interface,implementation) \
if (![[SimpleIoc defaultInstance] isRegistered:interface]) { \
Class cls = NSClassFromString(implementation);   \
if([[cls description] isEqualToString:implementation]) { \
[[SimpleIoc defaultInstance] registerInstance:NSProtocolFromString(interface) tClassName:NSClassFromString(implementation)]; \
} \
}

#define simpleIoc_registerInterfaceCreate(interface,implementation) \
if (![[SimpleIoc defaultInstance] isRegistered:interface]) { \
Class cls = NSClassFromString(implementation);   \
if([[cls description] isEqualToString:implementation]) { \
[[SimpleIoc defaultInstance] registerInstance:NSProtocolFromString(interface) tClassName:NSClassFromString(implementation) createInstanceImmediately:YES]; \
} \
}


#define simpleIoc_required()   \
[[SimpleIoc defaultInstance] simpleIocRequiresInjection:self];

#define simpleIoc_getInstanceClass(value) do { \
if (![[SimpleIoc defaultInstance] isRegistered:NSStringFromClass(value)]) { \
return [[SimpleIoc defaultInstance] getInstance:value];  \
} else {    \
return nil; \
}}while(0)

//第一个参数为需要构造的selector 一般指定到增加了零件对应参数的init方法上  第二个参数 是需要构造的零件 的协议 或者是Class 该零件与init的参数一一对应
#define simpleIoc_ctorInfoWithSelector(buildSelector, args...) \
-(ConstructorInfo *)getConstructorInfo { \
ConstructorInfo *ctor = [[ConstructorInfo alloc] init]; \
ctor.buildSelectorString = NSStringFromSelector(buildSelector); \
id objs[] = {args}; \
ctor.parameterTypes = [NSMutableArray arrayWithObjects: objs count:sizeof(objs)/sizeof(id)]; \
return ctor; \
}

//第一个参数为需要构造的selector 一般指定到非init方法上  第二个selector 指定到 自定义构造函数上  第三个参数 是需要构造的零件 的协议 或者是Class
#define simpleIoc_ctorInfoWithSelectorCustomInit(buildSelector,initSelector, args...) \
-(ConstructorInfo *)getConstructorInfo { \
ConstructorInfo *ctor = [[ConstructorInfo alloc] init]; \
ctor.buildSelectorString = NSStringFromSelector(buildSelector); \
ctor.initializerSelectorString = NSStringFromSelector(initSelector); \
id objs[] = {args}; \
ctor.parameterTypes = [NSMutableArray arrayWithObjects: objs count:sizeof(objs)/sizeof(id)]; \
return ctor; \
}



@interface SimpleIoc : NSObject <ISimpleIoc>
/**
 *  工厂单例
 *
 *  @return 工厂
 */
+ (instancetype)defaultInstance;

@end


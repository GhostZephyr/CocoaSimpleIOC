//
//  SimpleIoc.m
//  YFIOCLibrary
//
//  Created by qvod on 14-9-19.
//  Copyright (c) 2014年 YF. All rights reserved.
//

#import "SimpleIoc.h"
#import "SimpleIocConst.h"
#import <Foundation/Foundation.h>
#import "ConstructorInfo.h"
#import <objc/runtime.h>
#import <libkern/OSAtomic.h>


typedef id (^makeInstance)(NSString* className, NSArray *args);
@interface SimpleIoc()
@property(nonatomic) NSMutableDictionary* constructorInfos;
@property(nonatomic,copy) NSString* defaultKey;
@property(nonatomic) NSArray* emptyArguments; //object[]
@property(nonatomic) NSMutableDictionary* factories;// Dictionary<Type,Dictionary<string,Delegate>>
@property(nonatomic) NSMutableDictionary* instancesRegistry; //Dictionary<Type,Dictionary<string,object>>
@property(nonatomic) NSMutableDictionary* interfaceToClassMap; //Dictionary<Type,Type>
@property(nonatomic) NSObject* syncLock;
-(NSObject*) makeInstance:(NSString*)tClass arguments:(NSArray*)args;
-(void) doRegister:(NSString*)className classType:(NSString*)type factory:(makeInstance)factory classKey:(NSString*)key;
-(id) doGetService:(NSString*)serviceType key:(NSString*)key arguments:(NSArray*)args;
@end
@implementation SimpleIoc {
      OSSpinLock _lock;
}
- (instancetype) init
{
    self = [super init];
    if (self) {
        self.syncLock = [[NSObject alloc] init];
        self.defaultKey = @"8FA73D45-8233-8B67-CEB5-AC727634AD29";
        self.constructorInfos = [[NSMutableDictionary alloc] init];
        self.emptyArguments = [[NSArray alloc] init];
        self.factories = [[NSMutableDictionary alloc] init];
        self.interfaceToClassMap = [[NSMutableDictionary alloc] init];
        self.instancesRegistry = [[NSMutableDictionary alloc] init];

    }
    return self;
}

+(instancetype)defaultInstance {
    static dispatch_once_t pred;
    __strong static SimpleIoc *_default = nil;
    dispatch_once(&pred, ^{
        _default = [[self alloc]init];
    });
    return _default;
}

//////////////////// 实现ISimpleIoc ////////////////////
//begin
-(BOOL) containCreated:(NSString*) className {
    return [self containCreated:className key:nil];
}

-(BOOL) containCreated:(NSString*) className key:(Class)classKey {
    if([self.instancesRegistry objectForKey:className] == nil) {
        return NO;
    }
    NSMutableDictionary *instances = [self.instancesRegistry objectForKey:className];
    if(classKey == nil) {
        instances = [self.instancesRegistry objectForKey:className];
        return instances > 0;
    }
    if([instances objectForKey:classKey] == nil) {
        return NO;
    }
    return YES;
}

-(BOOL) isRegistered:(NSString*) className {
    return [self isRegistered:className key:self.defaultKey];
}

-(BOOL) isRegistered:(NSString*) className key:(Class)classKey {
    NSString *name = className;
    if([self.interfaceToClassMap objectForKey:name] == nil || [self.factories objectForKey:name] == nil) {
        return NO;
    }
    NSMutableDictionary *factoryInstances = [self.factories objectForKey:name];
    if([factoryInstances objectForKey:classKey] == nil) {
        return NO;
    }
    return YES;
}

-(void) registerInstance:(Protocol*) interfaceName tClassName:(Class) className {
    [self registerInstance:interfaceName tClassName:className createInstanceImmediately:NO];
}

-(void) registerInstance:(Protocol*) interfaceName tClassName:(Class) className createInstanceImmediately:(BOOL)createInstanceImmediately {
    [self registerInstance:interfaceName tClassName:className createInstanceImmediately:createInstanceImmediately key:self.defaultKey];
}

-(void)registerInstance:(Protocol *)interfaceName tClassName:(Class)className createInstanceImmediately:(BOOL)createInstanceImmediately key:(NSString *)classKey {
    OSSpinLockLock(&_lock);
    NSString *classType = NSStringFromClass(className);
    NSString *interfaceType = NSStringFromProtocol(interfaceName)   ;
    if([self.interfaceToClassMap objectForKey:interfaceType]) {
        
        if([self.interfaceToClassMap objectForKey:interfaceType]) {
            OSSpinLockUnlock(&_lock);
            [NSException raise:@"InvalidOperation" format:@"Class %@ is already registered",classType];
        }
    } else {
        self.interfaceToClassMap[interfaceType] = classType;
        self.constructorInfos[classType] = @"";
    }
    makeInstance factory = ^(NSString *name,NSArray *args) {
        OSSpinLockUnlock(&_lock);
        return [self makeInstance:name arguments:args];
    };
    [self doRegister:nil classType:interfaceType factory:factory classKey:classKey];
    if(createInstanceImmediately) {
        [self getInstanceByProtocol:interfaceName];
    }
    OSSpinLockUnlock(&_lock);
}

-(void) registerInstance:(Class) className {
    [self registerInstance:className createInstanceImmediately:NO];
}

-(void) registerInstance:(Class) className createInstanceImmediately:(BOOL)createInstanceImmediately {
    NSString *classType = NSStringFromClass(className);
    OSSpinLockLock(&_lock);
    if([self.factories objectForKey:classType] && [self.factories[classType] objectForKey:self.defaultKey]) {
        OSSpinLockUnlock(&_lock);
        [NSException raise:@"InvalidOperation" format:@"Class %@ is already registered",classType];
        return;
    }
    
    if([self.interfaceToClassMap objectForKey:classType] == nil) {
        self.interfaceToClassMap[classType] = @"";
    }
    
    makeInstance factory = ^(NSString *name, NSArray *args) {
        return [self makeInstance:name arguments:args];
    };
    
    [self doRegister:classType classType:classType factory:factory classKey:self.defaultKey];
    
    if (createInstanceImmediately) {
        [self getInstance:className];
    }

    OSSpinLockUnlock(&_lock);
}

-(void)registerInstance:(Class)className createInstanceImmediately:(BOOL)createInstanceImmediately key:(NSString *)classKey {
    NSString *classType = NSStringFromClass(className);
    OSSpinLockLock(&_lock);
    if([self.factories objectForKey:classType] && [self.factories[classType] objectForKey:classKey]) {
        if([self.constructorInfos objectForKey:classType] == nil) {
            OSSpinLockUnlock(&_lock);
            [NSException raise:@"InvalidOperation" format:@"Class %@ is already registered.",classType];
        }
        OSSpinLockUnlock(&_lock);
        return;
    }
    
    if([self.interfaceToClassMap objectForKey:classType] == nil) {
        self.interfaceToClassMap[classType] = @"";
    }
    
    if([self.constructorInfos objectForKey:classType] == nil) {
        self.constructorInfos[classType] = @"";
    }
    
    makeInstance factory = ^(NSString *name, NSArray *args) {
        OSSpinLockUnlock(&_lock);
        return [self makeInstance:name arguments:args];
    };
    
    
    [self doRegister:classType classType:classType factory:factory classKey:classKey];
    
    if(createInstanceImmediately) {
        [self getInstance:className key:classKey];
    }
    OSSpinLockUnlock(&_lock);
}

-(void) registerInstance:(Class) className factory:(id(^)(NSString *className, NSArray *args))factory {
    [self registerInstance:nil factory:factory createInstanceImmediately:NO];
}

-(void) registerInstance:(Class) className factory:(id(^)(NSString *className, NSArray *args))factory createInstanceImmediately:(BOOL)createInstanceImmediately {
    NSString *classType = NSStringFromClass(className);
    if(!factory) {
        OSSpinLockUnlock(&_lock);
        [NSException raise:@"InvalidOperation" format:@"There is already a facotry register for %@",classType];
    }
    
    if(![self.interfaceToClassMap objectForKey:classType]) {
        self.interfaceToClassMap[classType] = @"";
    }
    
    [self doRegister:nil classType:classType factory:factory classKey:self.defaultKey];
    
    if(createInstanceImmediately) {
        [self getInstance:className];
    }
}

-(void) registerInstance:(Class) className factory:(id(^)(NSString *className, NSArray *args))factory
                     key:(NSString*)classKey {
    [self registerInstance:className factory:factory key:classKey createInstanceImmediately:NO];
}

-(void) registerInstance:(Class) className factory:(id(^)(NSString *className, NSArray *args))factory
                     key:(NSString*)classKey createInstanceImmediately:(BOOL)createInstanceImmediately {
    OSSpinLockLock(&_lock);
    NSString *classType = NSStringFromClass(className);
    if([self.factories objectForKey:classType] && [self.factories[classType] objectForKey:classKey]) {
        OSSpinLockUnlock(&_lock);
        [NSException raise:@"InvalidOperation" format:@"There is already a facotry register for %@",classType];
    }
    
    if(![self.interfaceToClassMap objectForKey:classType]) {
        self.interfaceToClassMap[classType] = @"";
    }
    
    [self doRegister:classType classType:classType factory:factory classKey:classKey];
    
    if(createInstanceImmediately) {
        [self getInstance:className];
    }
    OSSpinLockUnlock(&_lock);
}

-(void) reset {
    [self.interfaceToClassMap removeAllObjects];
    [self.instancesRegistry removeAllObjects];
    [self.constructorInfos removeAllObjects];
    [self.factories removeAllObjects];
}


-(void) unRegisterInstance:(NSString*) className {
    OSSpinLockLock(&_lock);
    NSString *serviceType = className;
    NSString *resolveTo;
    if([self.interfaceToClassMap objectForKey:serviceType]) {
        resolveTo = self.interfaceToClassMap[serviceType];
    } else {
        resolveTo = serviceType;
    }
    
    if([self.instancesRegistry objectForKey:serviceType]) {
        [self.instancesRegistry removeObjectForKey:serviceType];
    }
    
    if([self.interfaceToClassMap objectForKey:serviceType]) {
        [self.interfaceToClassMap removeObjectForKey:serviceType];
    }
    
    if([self.factories objectForKey:serviceType]) {
        [self.factories removeObjectForKey:serviceType];
    }
    
    if([self.constructorInfos objectForKey:resolveTo]) {
        [self.constructorInfos removeObjectForKey:resolveTo];
    }
    OSSpinLockUnlock(&_lock);
}

-(void) unRegisterInstance:(NSString*) className instance:(id)instance {
    OSSpinLockLock(&_lock);
    NSString *classType = className;
    if([self.instancesRegistry objectForKey:classType]) {
        NSMutableDictionary *list = self.instancesRegistry[classType];
        NSArray *keyEnumerator = list.allKeys;
        for (NSInteger i = 0; i<keyEnumerator.count; i++) {
            NSObject *value;
            NSString *key;
            key = keyEnumerator[i];
            value = list[key];
            if([value isEqual:instance]) {
                [list removeObjectForKey:key];
            }
            if([self.factories objectForKey:classType]) {
                if([self.factories[classType] objectForKey:key]) {
                    NSObject *releaseInstance = self.factories[classType][key];
                    [self.factories[classType] removeObjectForKey:key];
                    releaseInstance = nil;
                }
            }
            
        }
        if([self.factories objectForKey:classType]) {
            [self.factories removeObjectForKey:classType];
        }
    }
    instance = nil;
    OSSpinLockUnlock(&_lock);
}

-(void) unRegisterInstance:(NSString*) className key:(NSString*)classKey {
    OSSpinLockLock(&_lock);
    NSString *classType = className;
    if([self.instancesRegistry objectForKey:classType]) {
        NSMutableDictionary *list = self.instancesRegistry[classType];
        NSArray *keyEnumerator = list.allKeys;
        for (NSInteger i = 0; i<keyEnumerator.count; i++) {
            NSString *key;
            NSObject *value;
            key = keyEnumerator[i];
            value = list[key];
            if([key isEqual:classKey]) {
                [list removeObjectForKey:key];
                value = nil;
            }
        }
        if([self.factories objectForKey:classType]) {
            if([self.factories[classType] objectForKey:classKey]) {
                [self.factories[classType] removeObjectForKey:classKey];
            }
            [self.factories removeObjectForKey:classType];
        }
        
    }
    OSSpinLockUnlock(&_lock);
}

-(id)doGetService:(NSString*)serviceType key:(NSString *)key arguments:(NSArray *)args{
    if(key == nil || [key isEqualToString:@""]) {
        key = self.defaultKey;
    }
    
    NSMutableDictionary *instances;
    if([self.instancesRegistry objectForKey:serviceType] == nil) {
        if([self.interfaceToClassMap objectForKey:serviceType] == nil) {
            OSSpinLockUnlock(&_lock);
            [NSException raise:@"ActivationException" format:@"Type not found in cache: %@",serviceType];
        }
        instances = [[NSMutableDictionary alloc] init];
        [self.instancesRegistry setObject:instances forKey:serviceType];
    } else {
        instances = [self.instancesRegistry objectForKey:serviceType];
    }
    
    if([instances objectForKey:key]) {
        return instances[key];
    }
    
    NSObject *instance = nil;
    
    if([self.factories objectForKey:serviceType]) {
        if([self.factories[serviceType] objectForKey:key]) {
            makeInstance factory = self.factories[serviceType][key];
            if([self.interfaceToClassMap objectForKey:serviceType] && ![self.interfaceToClassMap[serviceType] isEqualToString:@""]) {
                NSString *implementationType = self.interfaceToClassMap[serviceType];
                instance = factory(implementationType, args);
                
            } else {
                instance = factory(serviceType, args);
            }
        } else {
            if([self.factories[serviceType] objectForKey:self.defaultKey]) {
                makeInstance factory = self.factories[serviceType][key];
                instance = factory(serviceType, args);
            } else {
                OSSpinLockUnlock(&_lock);
                [NSException raise:@"ActivationException" format:@"Type not found in cache without a key: %@",serviceType];
            }
        }
    }
    [instances setObject:instance forKey:key];
    return instance;

}

-(void)doRegister:(NSString *)className classType:(NSString *)type factory:(makeInstance)factory classKey:(NSString *)key {
    if([self.factories objectForKey:type]) {
        if([[self.factories objectForKey:type] objectForKey:key]) {
            return;
        }
        NSMutableDictionary *factoryDict = [self.factories objectForKey:type];
        if(factoryDict)
            factoryDict[key] = factory;
    } else {
        NSMutableDictionary *list = [NSMutableDictionary dictionaryWithObjectsAndKeys:factory,key, nil];
        self.factories[type] = list;
    }
}

-(NSObject*) makeInstance:(NSString*)tClass arguments:(NSArray*)args {
    Class t = NSClassFromString(tClass);
    id instance = [t alloc];
    SEL getConstructInfoMethod = @selector(getConstructorInfo);
    if(![t conformsToProtocol:@protocol(IConstructorProvider)] && ![instance respondsToSelector:getConstructInfoMethod])
    {
        return [instance init];
    }
    id<IConstructorProvider> ctorInstance = instance;
    ConstructorInfo *ctorInfo = nil;
    if([self.constructorInfos objectForKey:tClass]) {
        ctorInfo = self.constructorInfos[tClass];
    }
    
    if([ctorInfo isEqual:@""] || ctorInfo == nil) {
        ctorInfo = [ctorInstance getConstructorInfo];
        self.constructorInfos[tClass] = ctorInfo;
    }
    SEL buildSelector = NSSelectorFromString(ctorInfo.buildSelectorString);
    if(!args) args = ctorInfo.arguments;
    if(args) {
        SEL initializerSelector = NSSelectorFromString(ctorInfo.initializerSelectorString);
        NSMethodSignature *signature = [t methodSignatureForSelector:initializerSelector];
        BOOL isClassMethod = signature != nil && initializerSelector != @selector(init);
    
        if(!isClassMethod) {
            signature = [t instanceMethodSignatureForSelector:initializerSelector];
        }
    
        if(signature) {
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
            [invocation setTarget:isClassMethod ? t : instance];
            for (int i = 0; i < args.count; i++) {
                __unsafe_unretained id arg = [args objectAtIndex:i];
                [invocation setArgument:&arg atIndex:i + 2];
            }
            [invocation setSelector:initializerSelector];
            [invocation invoke];
        } else {
            OSSpinLockUnlock(&_lock);
            [NSException raise:@"ActivationException" format:@"Could not find initializer '%@' on %@", NSStringFromSelector(initializerSelector), NSStringFromClass(t)];
        }
    }
    
    NSMutableArray *parameters = [[NSMutableArray alloc] init];
    for (int i = 0; i < ctorInfo.parameterTypes.count; i++) {
        Class ctorClass = ctorInfo.parameterTypes[i];
        NSString *serviceType;
        BOOL isClass = [ctorClass.description hasPrefix:@"<Protocol"] ? NO : YES;
        if(isClass) {
            serviceType = NSStringFromClass(ctorInfo.parameterTypes[i]);
        } else {
            serviceType = NSStringFromProtocol(ctorInfo.parameterTypes[i]);
        }
        OSSpinLockUnlock(&_lock);
        [parameters addObject:[self getSerivce:serviceType]];
    }
    __unsafe_unretained id argsArray[parameters.count];
    [parameters getObjects:argsArray];
    
    if ([instance respondsToSelector:buildSelector])
    {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[instance methodSignatureForSelector:buildSelector]];
        
        for (int i = 0; i < parameters.count; i++)
        {
            [invocation setArgument:&argsArray[i] atIndex:i + 2];
        }
        
        [invocation setSelector:buildSelector];
        [invocation invokeWithTarget:instance];
    }
    
    return instance;
}

-(void)simpleIocRequiresInjection:(id)instance {
    Class t  = [instance class];
    SEL getConstructInfoMethod = @selector(getConstructorInfo);
    NSString *tClass = NSStringFromClass(t);
    if(![t conformsToProtocol:@protocol(IConstructorProvider)] && ![instance respondsToSelector:getConstructInfoMethod])
    {
        return;
    }
    id<IConstructorProvider> ctorInstance = instance;
    ConstructorInfo *ctorInfo = nil;
    if([self.constructorInfos objectForKey:tClass]) {
        ctorInfo = self.constructorInfos[tClass];
    }
    
    if([ctorInfo isEqual:@""] || ctorInfo == nil) {
        ctorInfo = [ctorInstance getConstructorInfo];
        self.constructorInfos[tClass] = ctorInfo;
    }
    SEL buildSelector = NSSelectorFromString(ctorInfo.buildSelectorString);
    NSMutableArray *parameters = [[NSMutableArray alloc] init];
    for (int i = 0; i < ctorInfo.parameterTypes.count; i++) {
        Class ctorClass = ctorInfo.parameterTypes[i];
        NSString *serviceType;
        BOOL isClass = [ctorClass.description hasPrefix:@"<Protocol"] ? NO : YES;
        if(isClass) {
            serviceType = NSStringFromClass(ctorInfo.parameterTypes[i]);
        } else {
            serviceType = NSStringFromProtocol(ctorInfo.parameterTypes[i]);
        }
        [parameters addObject:[self getSerivce:serviceType]];
    }
    __unsafe_unretained id argsArray[parameters.count];
    [parameters getObjects:argsArray];
    
    if ([instance respondsToSelector:buildSelector])
    {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[instance methodSignatureForSelector:buildSelector]];
        
        for (int i = 0; i < parameters.count; i++)
        {
            [invocation setArgument:&argsArray[i] atIndex:i + 2];
        }
        
        [invocation setSelector:buildSelector];
        [invocation invokeWithTarget:instance];
    }
}
//end

//////////////////// 实现IServiceProvider ////////////////////
//begin
-(id)getSerivce:(NSString*)className {
    OSSpinLockLock(&_lock);
    id result = [self doGetService:className key:self.defaultKey arguments:nil];
    OSSpinLockUnlock(&_lock);
    return result;
}
//end

//////////////////// 实现IServiceLocator ////////////////////
//begin
-(NSArray *)getAllInstance:(Class)className {
    OSSpinLockLock(&_lock);
    NSString *serviceType = NSStringFromClass(className);
    if([self.factories objectForKey:serviceType]) {
        NSArray *keyArray = self.factories.allKeys;
        for (NSString *factoryKey in keyArray) {
            [self getInstance:className key:factoryKey];
        }
    }
    
    if([self.instancesRegistry objectForKey:serviceType]) {
        NSMutableDictionary *dict = self.instancesRegistry[serviceType];
        return dict.allValues;
    }
    OSSpinLockUnlock(&_lock);
    return [[NSArray alloc] init];
}

-(id)getInstance:(Class)className {
    return [self doGetService:NSStringFromClass(className) key:self.defaultKey arguments:nil];
}

-(id)getInstance:(Class)className key:(NSString *)classKey {
    return [self doGetService:NSStringFromClass(className) key:classKey arguments:nil];
}

-(id)getInstanceWithArguments:(Class)className arguments:(NSArray *)args {
    return [self doGetService:NSStringFromClass(className) key:self.defaultKey arguments:args];
}

-(id)getInstanceWithArguments:(Class)className arguments:(NSArray *)args key:(NSString *)classKey {
    return [self doGetService:NSStringFromClass(className) key:classKey arguments:args];
}

-(id)getInstanceByProtocolWithArguments:(Protocol *)protocol arguments:(NSArray *)args {
    return [self doGetService:NSStringFromProtocol(protocol) key:self.defaultKey arguments:args];
}

-(id)getInstanceByProtocolWithArguments:(Protocol *)protocol arguments:(NSArray *)args protocolKey:(NSString *)key {
    return [self doGetService:NSStringFromProtocol(protocol) key:key arguments:args];
}

-(id)getInstanceByProtocol:(Protocol *)protocol {
    return [self doGetService:NSStringFromProtocol(protocol) key:self.defaultKey arguments:nil];
}

-(id)getInstanceByProtocol:(Protocol *)protocol protocolKey:(id)key {
    return [self doGetService:NSStringFromProtocol(protocol) key:key arguments:nil];
}
//end
@end

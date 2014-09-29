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
static SimpleIoc *_default;

typedef id (^makeInstance)(NSString*);
@interface SimpleIoc()
@property(nonatomic) NSMutableDictionary* constructorInfos;
@property(nonatomic,copy) NSString* defaultKey;
@property(nonatomic) NSArray* emptyArguments; //object[]
@property(nonatomic) NSMutableDictionary* factories;// Dictionary<Type,Dictionary<string,Delegate>>
@property(nonatomic) NSMutableDictionary* instancesRegistry; //Dictionary<Type,Dictionary<string,object>>
@property(nonatomic) NSMutableDictionary* interfaceToClassMap; //Dictionary<Type,Type>
@property(nonatomic) NSObject* syncLock;
-(id) makeInstance:(NSString*)tClass;
-(void) doRegister:(NSString*)className classType:(NSString*)type factory:(makeInstance)factory classKey:(NSString*)key;
-(id) doGetService:(NSString*)serviceType key:(NSString*)key;
@end
@implementation SimpleIoc
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
    if(_default == nil) {
        _default = [[SimpleIoc alloc] init];
        return _default;
    } else {
        return _default;
    }
}

//////////////////// 实现ISimpleIoc ////////////////////
//begin
-(BOOL) containCreated:(NSString*) className {
    return [self containCreated:className key:nil];
}

-(BOOL) containCreated:(NSString*) className key:(Class)classKey {
    NSString *name = className;
    if([self.instancesRegistry objectForKey:name] == nil) {
        return NO;
    }
    NSMutableDictionary *instances = [self.instancesRegistry objectForKey:name];
    if(classKey == nil) {
        NSMutableDictionary *instances = [self.instancesRegistry objectForKey:name];
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
    @synchronized(self.syncLock) {
        NSString *classType = NSStringFromClass(className);
        NSString *interfaceType = NSStringFromProtocol(interfaceName)   ;
        if([self.interfaceToClassMap objectForKey:interfaceType]) {
            
            if([self.interfaceToClassMap objectForKey:interfaceType]) {
                [NSException raise:@"InvalidOperation" format:@"Class %@ is already registered",classType];
            }
        } else {
            self.interfaceToClassMap[interfaceType] = classType;
            self.constructorInfos[classType] = @"";
        }
        makeInstance factory = ^(NSString* className) {
            return [self makeInstance:className];
        };
        [self doRegister:nil classType:interfaceType factory:factory classKey:self.defaultKey];
        if(createInstanceImmediately) {
            [self getInstance:className];
        }
    }
}

-(void) registerInstance:(Class) className {
    [self registerInstance:className createInstanceImmediately:NO];
}

-(void) registerInstance:(Class) className createInstanceImmediately:(BOOL)createInstanceImmediately {
    NSString *classType = NSStringFromClass(className);
    @synchronized(self.syncLock) {
        if([self.factories objectForKey:classType] && [self.factories[classType] objectForKey:self.defaultKey]) {
            [NSException raise:@"InvalidOperation" format:@"Class %@ is already registered",classType];
            return;
        }
        
        if([self.interfaceToClassMap objectForKey:classType] == nil) {
            self.interfaceToClassMap[classType] = @"";
        }
        
        makeInstance factory = ^(NSString* className) {
            return [self makeInstance:className];
        };
        
        [self doRegister:classType classType:classType factory:factory classKey:self.defaultKey];
        
        if (createInstanceImmediately) {
            [self getInstance:className];
        }
    }
}

-(void)registerInstance:(Class)className createInstanceImmediately:(BOOL)createInstanceImmediately key:(NSString *)classKey {
    NSString *classType = NSStringFromClass(className);
    @synchronized(self.syncLock) {
        if([self.factories objectForKey:classType] && [self.factories[classType] objectForKey:classKey]) {
            if([self.constructorInfos objectForKey:classType] == nil) {
                [NSException raise:@"InvalidOperation" format:@"Class %@ is already registered.",classType];
            }
            
            return;
        }
        
        if([self.interfaceToClassMap objectForKey:classType] == nil) {
            self.interfaceToClassMap[classType] = @"";
        }
        
        if([self.constructorInfos objectForKey:classType] == nil) {
            self.constructorInfos[classType] = @"";
        }
        
        makeInstance factory = ^(NSString *className) {
            return [self makeInstance:className];
        };
        
        [self doRegister:classType classType:classType factory:factory classKey:classKey];
        
        if(createInstanceImmediately) {
            [self getInstance:className key:classKey];
        }
    }
}

-(void) registerInstance:(Class) className factory:(id(^)(Class className))factory {
    [self registerInstance:nil factory:factory createInstanceImmediately:NO];
}

-(void) registerInstance:(Class) className factory:(id(^)(Class className))factory createInstanceImmediately:(BOOL)createInstanceImmediately {
    NSString *classType = NSStringFromClass(className);
    if(!factory) {
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

-(void) registerInstance:(Class) className factory:(id(^)(Class className))factory
                     key:(NSString*)classKey {
    [self registerInstance:className factory:factory key:classKey createInstanceImmediately:NO];
}

-(void) registerInstance:(Class) className factory:(id(^)(Class className))factory
                     key:(NSString*)classKey createInstanceImmediately:(BOOL)createInstanceImmediately {
    @synchronized(self.syncLock) {
        NSString *classType = NSStringFromClass(className);
        if([self.factories objectForKey:classType] && [self.factories[classType] objectForKey:classKey]) {
            [NSException raise:@"InvalidOperation" format:@"There is already a facotry register for %@",classType];
        }
        
        if(![self.interfaceToClassMap objectForKey:classType]) {
            self.interfaceToClassMap[classType] = @"";
        }
        
        [self doRegister:classType classType:classType factory:factory classKey:classKey];
        
        if(createInstanceImmediately) {
            [self getInstance:className];
        }
    }
}

-(void) reset {
    [self.interfaceToClassMap removeAllObjects];
    [self.instancesRegistry removeAllObjects];
    [self.constructorInfos removeAllObjects];
    [self.factories removeAllObjects];
}


-(void) unRegisterInstance:(Class) className {
    @synchronized(self.syncLock) {
        NSString *serviceType = NSStringFromClass(className);
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
    }
}

-(void) unRegisterInstance:(Class) className instance:(id)instance {
    @synchronized(self.syncLock) {
        NSString *classType = NSStringFromClass(className);
        if([self.instancesRegistry objectForKey:classType]) {
            NSMutableDictionary *list = self.instancesRegistry[classType];
            NSArray *keyEnumerator = list.allKeys;
            for (NSInteger i = 0; i<keyEnumerator.count; i++) {
                NSObject *value;
                NSObject *key;
                key = keyEnumerator[i];
                value = list[key];
                if([value isEqual:instance]) {
                    [list removeObjectForKey:key];
                }
                if([self.factories objectForKey:classType]) {
                    if([self.factories[classType] objectForKey:key]) {
                        [self.factories[classType] removeObjectForKey:key];
                    }
                }
            }
        }
    }
}

-(void) unRegisterInstance:(Class) className key:(Class)classKey {
    @synchronized(self.syncLock) {
        NSString *classType = NSStringFromClass(className);
        if([self.instancesRegistry objectForKey:classType]) {
            NSMutableDictionary *list = self.instancesRegistry[classType];
            NSArray *keyEnumerator = list.allKeys;
            for (NSInteger i = 0; i<keyEnumerator.count; i++) {
                NSObject *value;
                NSObject *key;
                key = keyEnumerator[i];
                if([value isEqual:classKey]) {
                    [list removeObjectForKey:key];
                }
                if([self.factories objectForKey:classType]) {
                    if([self.factories[classType] objectForKey:key]) {
                        [self.factories[classType] removeObjectForKey:key];
                    }
                }
            }
            
        }
    }
}

-(id)doGetService:(NSString*)serviceType key:(NSString *)key {
    @synchronized(self.syncLock) {
        if(key == nil || [key isEqualToString:@""]) {
            key = self.defaultKey;
        }
        
        NSMutableDictionary *instances;
        if([self.instancesRegistry objectForKey:serviceType] == nil) {
            if([self.interfaceToClassMap objectForKey:serviceType] == nil) {
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
                    NSString* implementationType = self.interfaceToClassMap[serviceType];
                    instance = factory(implementationType);
                } else {
                    instance = factory(serviceType);
                }
            } else {
                if([self.factories[serviceType] objectForKey:self.defaultKey]) {
                    makeInstance factory = self.factories[serviceType][key];
                    instance = factory(serviceType);
                } else {
                    [NSException raise:@"ActivationException" format:@"Type not found in cache without a key: %@",serviceType];
                }
            }
        }
        [instances setObject:instance forKey:key];
        return instance;
    }
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

-(id) makeInstance:(NSString*)tClass {
    //    NSString *getConstructorInfo = GetConstructorInfoMethodName;
    //    SEL getCtorSel = NSSelectorFromString(getConstructorInfo);
    
    Class t = NSClassFromString(tClass);
    id instance = [[t alloc] init];
    if(![t conformsToProtocol:@protocol(IConstructorProvider)])
    {
        return instance;
    }
    id<IConstructorProvider> ctorInstance = instance;
    //    IMP getCtorMethod = [instance methodForSelector:getCtorSel];
    //    ConstructorInfo *(*func)(id, SEL) = (void*)getCtorMethod;
    //    ConstructorInfo *ctorInfo = func(instance, getCtorSel);
    ConstructorInfo *ctorInfo = [ctorInstance getConstructorInfo];
    SEL buildSelector = NSSelectorFromString(ctorInfo.buildSelectorString);
    self.constructorInfos[tClass] = ctorInfo;
    NSMutableArray *parameters = [[NSMutableArray alloc] init];
    for (int i = 0; i < ctorInfo.parameterTypes.count; i++) {
        Protocol *p = ctorInfo.parameterTypes[i];
        NSString *serviceType = NSStringFromProtocol(p);
        if(serviceType == nil) {
            serviceType = NSStringFromClass(ctorInfo.parameterTypes[i]);
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
    
    
    return instance;
}



//end

//////////////////// 实现IServiceProvider ////////////////////
//begin
-(id)getSerivce:(NSString*)className {
    return [self doGetService:className key:self.defaultKey];
}
//end

//////////////////// 实现IServiceLocator ////////////////////
//begin
-(NSArray *)getAllInstance:(Class)className {
    @synchronized(self.factories) {
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
    }
    return [[NSArray alloc] init];
}

-(id)getInstance:(Class)className {
    return [self doGetService:NSStringFromClass(className) key:self.defaultKey];
}

-(id)getInstance:(Class)className key:(NSString *)classKey {
    return [self doGetService:NSStringFromClass(className) key:classKey];
}


-(id)getInstanceByProtocol:(Protocol *)protocol {
    return [self doGetService:NSStringFromProtocol(protocol) key:self.defaultKey];
}

-(id)getInstanceByProtocol:(Protocol *)protocol protocolKey:(id)key {
    return [self doGetService:NSStringFromProtocol(protocol) key:key];
}
//end


@end

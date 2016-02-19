//
//  TestViewController.m
//  SimpleIoc
//
//  Created by qvod on 14-9-28.
//  Copyright (c) 2014年 YF. All rights reserved.
//

#import "TestViewController.h"
#import "SimpleIoc.h"

@implementation TestViewController

-(ConstructorInfo *)getConstructorInfo {
    ConstructorInfo *ctor = [[ConstructorInfo alloc] init];
//    ctor.parameterTypes = [[NSMutableArray alloc] initWithObjects:@protocol(ITestServiceA), [SampleUIViewControl class], nil];
//    ctor.buildSelectorString = NSStringFromSelector(@selector(build:testControl:));
    ctor.initializerSelectorString = NSStringFromSelector(@selector(init:));
    ctor.arguments = [[NSMutableArray alloc] initWithObjects:@"OK", nil];
    return ctor;
}

- (instancetype)init:(NSString*) type
{
    self = [super init];
    if (self) {
        NSLog(@"自定义构造 type %@",type);
    }
    return self;
}

-(void) build:(id<ITestServiceA>) testService testControl:(SampleUIViewControl*)control{
    self.testServiceA = testService;
    NSLog(@"工厂构造了 TestServiceViewController 并注入了 testService");
}
-(void)viewDidLoad {
    NSLog(@"已加载TestViewController viewDidLoad");
    self.view.backgroundColor  = [[UIColor alloc] initWithWhite:1.0 alpha:1.0];
}

-(void)viewWillDisappear:(BOOL)animated {
    NSLog(@"我要消失了 TestViewController 准备反注清理");
    [[SimpleIoc defaultInstance] unRegisterInstance:NSStringFromClass([TestViewController class])];
}

-(void)dealloc {
    NSLog(@"我要销毁了 TestViewController");
}
@end

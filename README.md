CocoaSimpleIOC
=========================

Simple IOC for Objective-c  from MVVMLight


你可以这样注册单例



[[SimpleIoc defaultInstance] registerInstance:[SampleUIViewControl class]];

[[SimpleIoc defaultInstance] registerInstance:[MainViewModel class]];

[[SimpleIoc defaultInstance] registerInstance:[MainViewModel class] createInstanceImmediately:NO key:@"OtherMainView"];






可以这么注册对应协议的实现






[[SimpleIoc defaultInstance] registerInstance:@protocol(ITestServiceA) tClassName:[TestServiceA class]];

[[SimpleIoc defaultInstance] registerInstance:@protocol(ITestServiceB) tClassName:[TestServiceB class]];

[[SimpleIoc defaultInstance] registerInstance:@protocol(ITestServiceC) tClassName:[TestServiceC class]];






在对象中声明需要的工厂零件






@implementation TestViewController

- (ConstructorInfo *)getConstructorInfo {
    ConstructorInfo* ctor = [[ConstructorInfo alloc] init];

    ctor.initializerSelectorString = NSStringFromSelector(@selector(build:testControl:));
    
    ctor.arguments = [[NSMutableArray alloc] initWithObjects:@"OK", nil];
    
    return ctor;
    
}


- (void)build:(id<ITestServiceA>)testService testControl:(SampleUIViewControl *)control {
- 
    self.testServiceA = testService;

    NSLog(@"工厂构造了 TestServiceViewController 并注入了 testService:%@", testService);
    
}

- (void)viewDidLoad {
- 
    NSLog(@"已加载TestViewController viewDidLoad");

    self.view.backgroundColor  = [[UIColor alloc] initWithWhite:1.0 alpha:1.0];
    
}



- (void)viewDidDisappear:(BOOL)animated {
- 
    [super viewDidDisappear:animated];

    NSLog(@"我要消失了 TestViewController 准备反注清理");
    
    [[SimpleIoc defaultInstance] unRegisterInstance:NSStringFromClass([TestViewController class])];
    
}



- (void)dealloc {
- 
    NSLog(@"我要销毁了 TestViewController");


}



@end









然后我们从工厂中拿到这个对象





TestViewController *viewController = [[SimpleIoc defaultInstance] getInstance:[TestViewController class]];



工厂负责组装这些单例的零件，你并不需知道实现

2016-02-19 16:57:40.275 SimpleIocTest[7294:741970] 工厂构造了 TestServiceViewController 并注入了 testService:OK
2016-02-19 16:57:40.276 SimpleIocTest[7294:741970] 已加载TestViewController viewDidLoad

//
//  TestViewController.h
//  SimpleIoc
//
//  Created by qvod on 14-9-28.
//  Copyright (c) 2014年 YF. All rights reserved.
//

#import "ViewController.h"
#import "IConstructorProvider.h"
#import "ITestServiceA.h"
#import "SampleUIViewControl.h"


@interface TestViewController : ViewController<IConstructorProvider>
@property id<ITestServiceA> testServiceA;
@end

//
//  TestServiceB.h
//  SimpleIoc
//
//  Created by qvod on 14-9-25.
//  Copyright (c) 2014年 YF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IConstructorProvider.h"
#import "ITestServiceC.h"

@interface TestServiceB : NSObject<IConstructorProvider>

@end

//
//  MainViewModel.h
//  SimpleIoc
//
//  Created by qvod on 14-9-25.
//  Copyright (c) 2014年 YF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IConstructorProvider.h"

@interface MainViewModel : NSObject<IConstructorProvider>
-(void) isOK;
@end

//
//  Cdrcus.m
//  iRecorder
//
//  Created by KevinDong on 15/3/27.
//  Copyright (c) 2015年 KevinDong. All rights reserved.
//

#import "Cdrcus.h"

@implementation Cdrcus

-(id)initWithCusno:(NSString *)cusno Cusna:(NSString *)cusna {
    self = [super init];
    if(self){
        self.cusno= cusno;
        self.cusna= cusna;
        return self;
    }
    return nil;
}

@end

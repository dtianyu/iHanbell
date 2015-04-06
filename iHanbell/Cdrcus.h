//
//  Cdrcus.h
//  iRecorder
//
//  Created by KevinDong on 15/3/27.
//  Copyright (c) 2015年 KevinDong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cdrcus : NSObject

@property(nonatomic,strong) NSString *cusno;
@property(nonatomic,strong) NSString *cusna;

-(id)initWithCusno:(NSString *)no Cusna:(NSString *)name;

@end

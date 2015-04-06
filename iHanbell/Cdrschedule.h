//
//  Cdrschedule.h
//  iRecorder
//
//  Created by KevinDong on 15/4/2.
//  Copyright (c) 2015年 KevinDong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cdrschedule : NSObject

@property(nonatomic,strong) NSString *cdrno;
@property(nonatomic,strong) NSString *itnbrcus;
@property(nonatomic,assign) int qty;
@property(nonatomic,assign) int inqty;
@property(nonatomic,assign) int shipqty;
@property(nonatomic,strong) NSString *outdate;

-(id)initWithCdrno:(NSString *)cdrno Itnbrcus:(NSString *)itnbrcus Qty:(int) qty Inqty:(int)inqty Shipqty:(int) shipqty Outdate:(NSString *) outdate;

@end

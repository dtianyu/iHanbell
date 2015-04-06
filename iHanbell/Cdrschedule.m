//
//  Cdrschedule.m
//  iRecorder
//
//  Created by KevinDong on 15/4/2.
//  Copyright (c) 2015年 KevinDong. All rights reserved.
//

#import "Cdrschedule.h"

@implementation Cdrschedule

-(id)initWithCdrno:(NSString *)cdrno Itnbrcus:(NSString *)itnbrcus Qty:(int)qty Inqty:(int)inqty Shipqty:(int)shipqty Outdate:(NSString *)outdate {
    self =[super init];
    if(self){
        self.cdrno= cdrno;
        self.itnbrcus= itnbrcus;
        self.qty = qty;
        self.inqty = inqty;
        self.shipqty = shipqty;
        self.outdate = outdate;
        return self;
    }
    return nil;
}
@end

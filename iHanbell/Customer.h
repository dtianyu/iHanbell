//
//  Customer.h
//  iHanbell
//
//  Created by KevinDong on 15/4/6.
//  Copyright (c) 2015年 KevinDong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Customer : NSManagedObject

@property (nonatomic, retain) NSString * cusna;
@property (nonatomic, retain) NSString * cusno;

@end

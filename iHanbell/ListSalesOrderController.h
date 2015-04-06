//
//  ListSalesOrderController.h
//  iRecorder
//
//  Created by KevinDong on 15/4/2.
//  Copyright (c) 2015年 KevinDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableController.h"
#import "Customer.h"

@interface ListSalesOrderController : CoreDataTableController<NSURLConnectionDelegate,
NSXMLParserDelegate>

@property(nonatomic,strong) NSString *currentCusno;
@property(nonatomic,strong) NSString *currentCusna;

@end

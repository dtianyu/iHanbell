//
//  AddCustomerViewController.h
//  iRecorder
//
//  Created by KevinDong on 15/3/26.
//  Copyright (c) 2015年 KevinDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableController.h"
#import "Customer.h"

@interface AddCustomerController : CoreDataTableController<NSURLConnectionDelegate,
NSXMLParserDelegate>

@property(strong,nonatomic)NSFetchedResultsController *fetchedResultsController;

@end

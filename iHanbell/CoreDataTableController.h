//
//  CoreDataTableController.h
//  iRecorder
//
//  Created by KevinDong on 15/3/26.
//  Copyright (c) 2015年 KevinDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoreDataTableController : UITableViewController<UIAlertViewDelegate>

@property(strong,nonatomic)NSManagedObjectContext *managedObjectContext;

@property(strong,nonatomic)NSString *userid;

-(void) cancelAndDismiss;

-(void) save;

-(void) saveAndDismiss;

-(void)showAlertView:(NSString *) message;

@end

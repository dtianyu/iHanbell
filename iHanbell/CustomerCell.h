//
//  AddCustomerCell.h
//  iRecorder
//
//  Created by KevinDong on 15/3/27.
//  Copyright (c) 2015年 KevinDong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Customer.h"

@interface CustomerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cusno;
@property (weak, nonatomic) IBOutlet UILabel *cusna;

@end

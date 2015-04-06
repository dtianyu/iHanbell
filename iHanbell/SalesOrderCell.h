//
//  SalesOrderCell.h
//  iRecorder
//
//  Created by KevinDong on 15/4/5.
//  Copyright (c) 2015年 KevinDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SalesOrderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cdrno;
@property (weak, nonatomic) IBOutlet UILabel *itnbrcus;
@property (weak, nonatomic) IBOutlet UILabel *qty;
@property (weak, nonatomic) IBOutlet UILabel *inqty;
@property (weak, nonatomic) IBOutlet UILabel *shipqty;
@property (weak, nonatomic) IBOutlet UILabel *outdate;

@end

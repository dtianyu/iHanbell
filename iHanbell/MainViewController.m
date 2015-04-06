//
//  MainViewController.m
//  iRecorder
//
//  Created by KevinDong on 15/3/24.
//  Copyright (c) 2015年 KevinDong. All rights reserved.
//

#import "MainViewController.h"
#import "EditCustomerController.h"

@interface MainViewController ()

@end

@implementation MainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier]isEqualToString:@"editCustomer"]) {
        
        EditCustomerController *editCustomerController = segue.destinationViewController;
        editCustomerController.userid = self.userid;
        
    }
    
}


@end

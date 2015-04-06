//
//  ViewController.h
//  iRecorder
//
//  Created by KevinDong on 15/3/9.
//  Copyright (c) 2015年 KevinDong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UIAlertViewDelegate,NSURLConnectionDelegate,
NSXMLParserDelegate>

- (IBAction)login:(UIButton *)sender;

@end


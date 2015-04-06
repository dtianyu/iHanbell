//
//  ViewController.m
//  iRecorder
//
//  Created by KevinDong on 15/3/9.
//  Copyright (c) 2015年 KevinDong. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"
#import "AppDelegate.h"

static NSString *baseURL=@"http://ar.hanbell.com.cn:8480/RESTWebService/webresources";

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *userid;
@property (weak, nonatomic) IBOutlet UITextField *pwd;
@property (strong, nonatomic) NSMutableData *responseData;
@property(nonatomic, strong) NSMutableArray *queryResults;
@property (nonatomic,assign)long responseState;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)login:(UIButton *)sender {
    if (self.userid.text.length==0 || self.pwd.text.length==0) {
        [self showMessage:@"用户名或密码不能空白!"];
        return;
    }

    NSString *htttpURL =  [NSString stringWithFormat :@"%@/shberp.entity.cdrschedule/id;facno=C;cdrno=CC15030624-001",baseURL] ;
    
    NSURLRequest *httpRequest =[NSURLRequest requestWithURL:
                                [NSURL URLWithString: htttpURL]
                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                            timeoutInterval:60.0];
    NSURLConnection *httpConnection=[[NSURLConnection alloc] initWithRequest:httpRequest delegate:self];
    if (!httpConnection) {
        self.responseData=nil;
        //返回响应状态.
        _responseState=000;
    }
}


-(void)showMessage:(NSString *) message{
    UIAlertView *msg=[[UIAlertView alloc] initWithTitle:@"Information"
                                                message:message
                                               delegate:self cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil, nil];
    [msg show];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark-
#pragma mark NSURLConnection
    
    
-(NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse
{
    return request;
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    assert( [httpResponse isKindOfClass:[NSHTTPURLResponse class]] );
    //返回响应状态
    _responseState = (long)(httpResponse.statusCode);
    [self.responseData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.responseData appendData:data];
}

-(NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse{
    return cachedResponse;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if(_responseState==200 || _responseState==204){
        //进入系统
        MainViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"MainCtrl"];
        view.userid = self.userid.text;
        [self.navigationController pushViewController:view animated:YES];
    }
    else{
        [self showMessage:@"用户或密码错误"];
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    _responseState=000;
    [self showMessage:@"网络连接异常"];
}


@end

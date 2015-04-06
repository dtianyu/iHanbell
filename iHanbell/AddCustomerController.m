//
//  AddCustomerViewController.m
//  iRecorder
//
//  Created by KevinDong on 15/3/26.
//  Copyright (c) 2015年 KevinDong. All rights reserved.
//

#import "AddCustomerController.h"
#import "CustomerCell.h"
#import "Cdrcus.h"

static NSString *baseURL=@"http://ar.hanbell.com.cn:8480/RESTWebService/webresources";

@interface AddCustomerController ()

@property (nonatomic,strong) Customer *addCustomer;
@property (nonatomic,strong) NSArray *localData;
@property (nonatomic,assign) bool alreadyAdded;

@property (nonatomic,strong) NSMutableData *responseData;
@property (nonatomic,strong) NSMutableArray *queryResults;
@property (nonatomic,assign)int responseState;

@property(nonatomic,strong) NSXMLParser *xmlParser;
@property(nonatomic) NSString *innerText;
@property(nonatomic) BOOL hasFound;

@property(nonatomic,strong) Cdrcus *currentCustomer;
@property(nonatomic) NSString *cusno;
@property(nonatomic) NSString *cusna;

@end

@implementation AddCustomerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.userid!=nil){
        
        self.responseData = [NSMutableData dataWithCapacity: 0];
        
        //RESTful资源地址
        NSString *htttpURL = [NSString stringWithFormat :@"%@/shberp.entity.cdrcus/man/%@",baseURL,@"C0013"] ;
        
        NSURLRequest *httpRequest =[NSURLRequest requestWithURL:
                                    [NSURL URLWithString: htttpURL]
                                                    cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                timeoutInterval:60.0];
        
        NSURLConnection *httpConnection=[[NSURLConnection alloc] initWithRequest:httpRequest delegate:self];
        if (!httpConnection) {
            self.responseData=nil;
            //返回响应状态.
            self.responseState=000;
        }
        
        
    }else{
        [self showAlertView:@"非法账户,请立即退出!"];
    }
    
    _localData = [_fetchedResultsController fetchedObjects];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.queryResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if(!cell){
        cell=[[CustomerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    Cdrcus *cdrcus = [self.queryResults objectAtIndex:indexPath.row];

    cell.cusno.text = cdrcus.cusno;
    cell.cusna.text= cdrcus.cusna;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Cdrcus *cdrcus = [self.queryResults objectAtIndex:indexPath.row];
    _alreadyAdded =false;
    for (int i = 0; i < _localData.count; i++) {
        Customer *customer = (Customer *)[_localData objectAtIndex:i];
        if ([customer.cusno isEqualToString:cdrcus.cusno]) {
            _alreadyAdded=true;
            break;
        }
    }
    if(_alreadyAdded){
        [self showAlertView:@"此客户已添加"];
    }
    else{
        self.addCustomer = [NSEntityDescription insertNewObjectForEntityForName:@"Customer" inManagedObjectContext:self.managedObjectContext];
        self.addCustomer.cusno = cdrcus.cusno;
        self.addCustomer.cusna = cdrcus.cusna;
        [self save];
    }
    
}

/*
 // Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - NSURLConnection
    
    
-(NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse
{
    return request;
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{

    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    assert( [httpResponse isKindOfClass:[NSHTTPURLResponse class]] );
    //返回响应状态
    self.responseState = (int)(httpResponse.statusCode);
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
    if(self.responseState == 404){
        [self showAlertView:@"从服务器获取客户资料失败"];
        [self cancelAndDismiss];//这个不起作用
    }
    else
    {
    //将XML解析为对象
        if(self.responseData!=nil){
            _xmlParser = [[NSXMLParser alloc] initWithData: self.responseData];
            [_xmlParser setDelegate: self];
            [_xmlParser setShouldResolveExternalEntities: YES];
            [_xmlParser parse];//解析
            [self.tableView reloadData];
        }
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
 
    [self showAlertView:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
    
}

#pragma mark - XML Parser Delegate Methods

// 开始解析一个元素名
-(void) parser:(NSXMLParser *) parser didStartElement:(NSString *) elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *) qName attributes:(NSDictionary *) attributeDict {
    
    if ([elementName isEqualToString:@"cdrcus"]) {
        self.hasFound = YES;
    }

}

// 追加找到的元素值，一个元素值可能要分几次追加
-(void)parser:(NSXMLParser *) parser foundCharacters:(NSString *)string {
    
    if (_hasFound) {
        _innerText = [[NSString alloc] initWithString: string ];
    }
}

// 结束解析这个元素名
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"cdrcus"]) {

        self.currentCustomer =[[Cdrcus alloc] initWithCusno:_cusno Cusna:_cusna];

        if (!_queryResults) {
            _queryResults = [[NSMutableArray alloc] init];
        }
        
        [_queryResults addObject:self.currentCustomer];
        
        _hasFound = NO;
        
    }
    else if ([elementName isEqualToString:@"cusno"]){
        
        _cusno = _innerText;
        
    }
    else if ([elementName isEqualToString:@"cusna"]){
        
        _cusna = _innerText;
        
    }
    self.innerText=@"";
    
}

// 解析整个文件结束后
- (void)parserDidEndDocument:(NSXMLParser *)parser {

}

@end

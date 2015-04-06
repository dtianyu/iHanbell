//
//  ListSalesOrderController.m
//  iRecorder
//
//  Created by KevinDong on 15/4/2.
//  Copyright (c) 2015年 KevinDong. All rights reserved.
//

#import "ListSalesOrderController.h"
#import "SalesOrderCell.h"
#import "Cdrschedule.h"

static NSString *baseURL=@"http://ar.hanbell.com.cn:8480/RESTWebService/webresources";

@interface ListSalesOrderController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *queryState;
@property (nonatomic,strong) NSMutableData *responseData;
@property (nonatomic,strong) NSMutableArray *queryResults;
@property (nonatomic,assign)int responseState;

@property(nonatomic,strong) NSXMLParser *xmlParser;
@property(nonatomic) NSString *innerText;
@property(nonatomic) BOOL hasFound;

@property(nonatomic,strong) Cdrschedule *currentCdrschedule;
@property(nonatomic) NSString *cdrno;
@property(nonatomic) NSString *itnbrcus;
@property(nonatomic) int qty;
@property(nonatomic) int inqty;
@property(nonatomic) int shipqty;
@property(nonatomic,strong) NSString *outdate;

@end

@implementation ListSalesOrderController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.currentCusno!=nil){
        [self initURLConnctionWithState:@"N"];
    }else{
        [self showAlertView:@"非法客户资料,请立即退出!"];
    }
    
}

- (IBAction)queryStateChanged:(UISegmentedControl *)sender {
    
    if ([self.queryState selectedSegmentIndex]==0) {
        [self.queryResults removeAllObjects];
        [self initURLConnctionWithState:@"N"];
    }
    else if([self.queryState selectedSegmentIndex]==1){
        [self.queryResults removeAllObjects];
        [self initURLConnctionWithState:@"Y"];
    }
    else{
        [self.queryResults removeAllObjects];
        [self initURLConnctionWithState:@"A"];
    }
    
}

-(void)initURLConnctionWithState:(NSString *)state{
    self.responseData = [NSMutableData dataWithCapacity: 0];
    //RESTful资源地址
    NSString *htttpURL = [NSString stringWithFormat :@"%@/shberp.entity.cdrschedule/%@/%@",baseURL,_currentCusno,state] ;
    
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
    return [_queryResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SalesOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if(!cell){
        cell=[[SalesOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    Cdrschedule *cdrschedule = [_queryResults objectAtIndex:indexPath.row];
    
    cell.cdrno.text = cdrschedule.cdrno;
    cell.itnbrcus.text = cdrschedule.itnbrcus;
    cell.qty.text =[[NSString alloc] initWithFormat:@"接单:%d", cdrschedule.qty ];
    cell.inqty.text =[[NSString alloc] initWithFormat:@"入库:%d", cdrschedule.inqty ];
    cell.shipqty.text=[[NSString alloc] initWithFormat:@"出货:%d", cdrschedule.shipqty ];
    cell.outdate.text = [[NSString alloc] initWithFormat:@"%@交货", cdrschedule.outdate ];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [[NSString alloc]initWithFormat:@"%@共%lu笔资料" ,_currentCusna, (unsigned long)[_queryResults count]] ;
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return [[NSString alloc]initWithFormat:@"%@共%lu笔资料" ,_currentCusna, (unsigned long)[_queryResults count]] ;
}

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
        [self showAlertView:@"从服务器获取资料失败"];
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
    //key需要查找的节点
    if ([elementName isEqualToString:@"cdrschedule"]) {
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
    //key需要查找的节点
    if ([elementName isEqualToString:@"cdrschedule"]) {

        self.currentCdrschedule =[[Cdrschedule alloc] initWithCdrno:_cdrno Itnbrcus:_itnbrcus Qty:_qty Inqty:_inqty Shipqty:_shipqty Outdate:_outdate];

        if (!_queryResults) {
            _queryResults = [[NSMutableArray alloc] init];
        }
        
        [_queryResults addObject:self.currentCdrschedule];
        
        _hasFound = NO;
        
    }
    else if ([elementName isEqualToString:@"cdrno"]){
        
        _cdrno = _innerText;//解析字段
        
    }
    else if ([elementName isEqualToString:@"itnbrcus"]){
        
        _itnbrcus = _innerText;
        
    }
    else if ([elementName isEqualToString:@"qty"]){
        
        _qty = [_innerText intValue];
        
    }
    else if ([elementName isEqualToString:@"inqty"]){
        
        _inqty = [_innerText intValue];
        
    }
    else if ([elementName isEqualToString:@"shipqty"]){
        
        _shipqty = [_innerText intValue];
        
    }
    else if ([elementName isEqualToString:@"shipday1"]){
            
        _outdate = [_innerText substringToIndex:10];
        
    }
    self.innerText=@"";//开始下一次解析前清空
    
}

// 解析整个文件结束后
- (void)parserDidEndDocument:(NSXMLParser *)parser {

}

@end

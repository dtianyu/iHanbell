//
//  ListCustomerController.m
//  iRecorder
//
//  Created by KevinDong on 15/4/2.
//  Copyright (c) 2015年 KevinDong. All rights reserved.
//

#import "ListCustomerController.h"
#import "CustomerCell.h"
#import "ListSalesOrderController.h"

@interface ListCustomerController ()

@property(nonatomic,strong)NSFetchedResultsController *fetchedResultsController;
@property(nonatomic,strong)Customer *currentCustomer;

@end

@implementation ListCustomerController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSError *error = nil;
    if (![[self fetchedResultsController]performFetch:&error]) {
        NSString *str=[[NSString alloc]initWithFormat:@"Failure: %@",[error localizedDescription]];
        [self showAlertView:str];
        abort();
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [[self.fetchedResultsController sections]count];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    id<NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections]
                                                   objectAtIndex:section];
    return [sectionInfo numberOfObjects];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if(!cell){
        cell=[[CustomerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    Customer *customer = [_fetchedResultsController objectAtIndexPath:indexPath];
    cell.cusno.text = customer.cusno;
    cell.cusna.text = customer.cusna;
    return cell;
    
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


#pragma mark - Fetched Results Controller Section

-(NSFetchedResultsController*)fetchedResultsController{

    if (_fetchedResultsController!=nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Customer"
                                              inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"cusno" ascending:YES];
    
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors: sortDescriptors];
    
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    _fetchedResultsController.delegate = self ;
    
    return _fetchedResultsController;
    
}

#pragma mark - Fetched Results Controller Delegates

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller{

    [self.tableView beginUpdates];

}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{

    [self.tableView endUpdates];
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath{
    
    UITableView *tableView = self.tableView;
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            break;
        case NSFetchedResultsChangeMove:
            break;
        default:
            break;
    }
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([[segue identifier]isEqualToString:@"toOrderList"]) {
        CustomerCell *cell=(CustomerCell *)sender;
        if(cell.cusno.text){
            ListSalesOrderController *listSalesOrderController  = segue.destinationViewController;
            listSalesOrderController.currentCusno = cell.cusno.text;
            listSalesOrderController.currentCusna = cell.cusna.text;
        }
        else{
            abort();
        }
    }
    
}


@end

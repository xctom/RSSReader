//
//  MasterViewController.m
//  splittingUpIsEasyToDo
//
//  Created by xuchen on 2/11/15.
//  Copyright (c) 2015 __ChenXu__. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "SharedNetworking.h"
#import "NewsTableViewCell.h"

@interface MasterViewController ()

@property NSMutableArray *objects;
@property NSDictionary *links;

@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    self.clearsSelectionOnViewWillAppear = NO;
    self.preferredContentSize = CGSizeMake(320.0, 600.0);
}

- (void)viewWillAppear:(BOOL)animated{
    [self downloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    UIRefreshControl *pullToRefresh = [[UIRefreshControl alloc] init];
    pullToRefresh.tintColor = [UIColor grayColor];
    [pullToRefresh addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = pullToRefresh;

}

- (void) refreshAction{
    [self downloadData];
}


- (void)downloadData{
    [[SharedNetworking sharedSharedNetworking] getFeedForURL:nil
                                                     success:^(NSDictionary *dictionary, NSError *error) {
                                                         self.objects = dictionary[@"responseData"][@"feed"][@"entries"];
                                                         
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                             [self.tableView reloadData];
                                                             
                                                             //when data is downloaded, stop the spinner
                                                             if(self.refreshControl.refreshing){
                                                                 [self.refreshControl endRefreshing];
                                                             }
                                                         });
                                                         
                                                     } failure:^{
                                                         UIAlertView *alert = [[UIAlertView alloc]
                                                                               initWithTitle:@"Network Error"
                                                                               message:@"Cannot connect to Internet"
                                                                               delegate:nil
                                                                               cancelButtonTitle:@"OK"
                                                                               otherButtonTitles:nil];
                                                         [alert show];
                                                         
                                                         //stop spinning
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                             
                                                             if(self.refreshControl.refreshing){
                                                                 [self.refreshControl endRefreshing];
                                                             }
                                                         });
                                                         
                                                     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *object = self.objects[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:[[NSMutableDictionary alloc] initWithDictionary:object]];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsTableViewCell *cell = (NewsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];

    NSDictionary *object = self.objects[indexPath.row];
    
    cell.titleLabel.text = object[@"title"];
    cell.contentLabel.text = object[@"contentSnippet"];
    
    //parse date data from string
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"eee, dd MMM yyyy HH:mm:ss ZZZZ"];
    NSDate *date = [dateFormatter dateFromString:object[@"publishedDate"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    cell.dateLabel.text = [dateFormatter stringFromDate:date];
    
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    [cell setSelected:YES];
    
    return cell;
}


@end

//
//  MasterViewController.m
//  splittingUpIsEasyToDo
//
//  Created by xuchen on 2/11/15.
//  Copyright (c) 2015 __ChenXu__. All rights reserved.
//

#import "MasterViewController.h"
#import "SharedNetworking.h"
#import "NewsTableViewCell.h"
#import "Article.h"

@interface MasterViewController ()

@property NSMutableArray *articles;

@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    self.clearsSelectionOnViewWillAppear = NO;
    self.preferredContentSize = CGSizeMake(320.0, 600.0);
}

- (void)viewWillAppear:(BOOL)animated{
    
    //set estimatedRowHeight and rowHeight
    self.tableView.estimatedRowHeight = 120;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    //register notification center
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stateChange)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stateChange)
                                                 name:NSUserDefaultsDidChangeNotification
                                               object:nil];
    
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    //set up pull to refresh
    UIRefreshControl *pullToRefresh = [[UIRefreshControl alloc] init];
    pullToRefresh.tintColor = [UIColor grayColor];
    [pullToRefresh addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = pullToRefresh;
    
    [self downloadData];
}

- (void) refreshAction{
    [self downloadData];
}


- (void)downloadData{
    
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"colorful-triangles-background"]];
    
    [self.delegate showSplashing:vc];
    
    [[SharedNetworking sharedSharedNetworking] getFeedForURL:nil
                                                     success:^(NSDictionary *dictionary, NSError *error) {
                                                         NSDictionary* links = dictionary[@"responseData"][@"feed"][@"entries"];
                                                         
                                                        
                                                         self.articles = [[NSMutableArray alloc] init];
                                                         
                                                         for (NSDictionary* link in links) {
                                                             Article* single = [[Article alloc] init];
                                                             single.title = link[@"title"];
                                                             single.contentSnippet = link[@"contentSnippet"];
                                                             single.link = link[@"link"];
                                                             single.date = link[@"publishedDate"];
                                                             
                                                             [self.articles addObject:single];
                                                         }
                                                         
                                                         dispatch_async(dispatch_get_main_queue(), ^{
                                                            
                                                             [self.tableView reloadData];
                                                             
                                                             [self.delegate dismissSplashing];
                                                             
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
        Article *current = self.articles[indexPath.row];
        
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:current];
        
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.articles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsTableViewCell *cell = (NewsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];

    Article *single = self.articles[indexPath.row];
    
    cell.titleLabel.text = single.title;
    //set font to system preference
    cell.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    
    cell.contentLabel.text = single.contentSnippet;
    //set font to system preference
    cell.contentLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    
    //parse date data from string
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"eee, dd MMM yyyy HH:mm:ss ZZZZ"];
    NSDate *date = [dateFormatter dateFromString:single.date];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    cell.dateLabel.text = [dateFormatter stringFromDate:date];
    //set font to system preference
    cell.dateLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
    
    //check night_mode
    //reference http://stackoverflow.com/questions/26008817/how-to-check-if-time-is-day-night-objective-c
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"night_mode"]) {
        cell.backgroundColor = [UIColor blackColor];
        cell.titleLabel.textColor = [UIColor whiteColor];
        cell.contentLabel.textColor = [UIColor whiteColor];
    }else{
        cell.backgroundColor = [UIColor whiteColor];
        cell.titleLabel.textColor = [UIColor blackColor];
        cell.contentLabel.textColor = [UIColor blackColor];
    }
    
    [cell setSelected:YES];
    [cell setSelected:NO];
    
    [cell layoutIfNeeded];
    
    return cell;
}

#pragma mark change font
- (void)stateChange{
    [self.tableView reloadData];
}


@end

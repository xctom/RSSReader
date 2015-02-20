//
//  DetailViewController.m
//  splittingUpIsEasyToDo
//
//  Created by xuchen on 2/11/15.
//  Copyright (c) 2015 __ChenXu__. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(NSDictionary*)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = [[NSMutableDictionary alloc] initWithDictionary:newDetailItem];
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    //check for if there exists "lastViewed" in NSUserDefaults
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *lastViewed = (NSDictionary*)[defaults objectForKey:@"lastViewed"];
    
    //if exists lastViewed and detailItem is nil, set it to the detailItem
    if (lastViewed && self.detailItem == nil) {
        self.detailItem = [[NSMutableDictionary alloc] initWithDictionary:lastViewed];
    }
    
    // Update the user interface for the detail item.
    if (self.detailItem) {
        
        self.navigationItem.title = self.detailItem[@"title"];
        
        NSURL *url = [[NSURL alloc] initWithString:self.detailItem[@"link"]];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        [self.webView loadRequest:request];
        
        //update lastViewed
        [defaults setObject:self.detailItem forKey:@"lastViewed"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"popoverSeque"]) {
        UINavigationController *nvc = (UINavigationController*)segue.destinationViewController;
        BookmarkTableViewController *bvc = (BookmarkTableViewController*)nvc.topViewController;
        bvc.delegate = self;
    }
}

- (void)bookmark:(id)sender sendsURL:(NSURL *)url{
    
    //change the detailItem to selected item in the popover menu
    self.detailItem = [[NSMutableDictionary alloc] initWithDictionary:(NSDictionary*)sender];
    
    self.navigationItem.title = self.detailItem[@"title"];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

/**
 *  click "Add to Favortie" button and add data to NSUserDefaults
 *
 */
- (IBAction)AddToFavorite:(id)sender {
    //chekc if there is already bookmark data in NSUserDefaults
    //if not create one
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *array = (NSArray*)[defaults objectForKey:@"bookmarks"];
    NSMutableArray *newArray = nil;
    
    if (array) {
        newArray = [[NSMutableArray alloc] initWithArray:array];
    } else {
        newArray = [[NSMutableArray alloc] init];
    }
    
    //check if detailItem is nil or has been added into the bookmark
    if (self.detailItem == nil || self.detailItem[@"addToFavorite"] != nil) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Cannot add item"
                              message:@"Content invalid or already in Bookmark"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }else{
        //add a new key-value to detialItem
        [self.detailItem setValue:@"YES" forKey:@"addToFavorite"];
        [newArray addObject:self.detailItem];
    }
    
    [defaults setObject:newArray forKey:@"bookmarks"];
    
}

- (IBAction)twitterSharing:(id)sender {
    
    //check detailItem not null
    if (self.detailItem) {
        //check if account has been set up
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
            SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            [tweetSheet setInitialText:[[NSString alloc] initWithFormat:@"I like this news, %@ : %@", self.detailItem[@"title"], self.detailItem[@"link"]]];
            [self presentViewController:tweetSheet animated:YES completion:nil];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"Service not avaliable"
                                  message:@"Twitter account has not been set up yet"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    
}

@end

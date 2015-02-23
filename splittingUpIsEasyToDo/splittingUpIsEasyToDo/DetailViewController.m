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

- (void)setDetailItem:(Article*)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    
    NSUserDefaults* defualts = [NSUserDefaults standardUserDefaults];
    
    // Read
    NSData* data = [defualts dataForKey:@"lastViewedArticle"];
    Article *lastViewed = (Article*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    //check for if there exists "lastViewed" is user Document
    //if exists lastViewed and detailItem is nil, set it to the detailItem
    
    if (lastViewed && self.detailItem == nil) {
        self.detailItem = lastViewed;
    }
    
    // Update the user interface for the detail item.
    if (self.detailItem) {
        
        //check for if this is a favorite and show star
        if ([self.detailItem isFavorite]) {
            [self showStar];
        }else{
            [self hideStar];
        }
        
        self.navigationItem.title = self.detailItem.title;
        
        NSURL *url = [[NSURL alloc] initWithString:self.detailItem.link];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
        [self.webView loadRequest:request];
        
        //update lastViewed
        NSData* lastViewedData = [NSKeyedArchiver archivedDataWithRootObject:self.detailItem];
        //NSLog(@"%@",lastViewedData);
        [defualts setObject:lastViewedData forKey:@"lastViewedArticle"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView.delegate = self;
    
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"popoverSeque"]) {
        UINavigationController *nvc = segue.destinationViewController;
        
        UIPopoverPresentationController *pvc = nvc.popoverPresentationController;
        pvc.delegate = self;
        
        BookmarkTableViewController *bvc = (BookmarkTableViewController*)nvc.topViewController;
        bvc.delegate = self;
    }
}


//denied model presentation
- (UIModalPresentationStyle) adaptivePresentationStyleForPresentationController: (UIPresentationController * ) controller {
    return UIModalPresentationNone;
}

- (void)bookmark:(id)sender sendsURL:(NSURL *)url{
    
    //change the detailItem to selected item in the popover menu
    self.detailItem = (Article*)sender;
    
    self.navigationItem.title = self.detailItem.title;
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

/**
 *  click "Add to Favortie" button and add data to plist
 *
 */
- (IBAction)AddToFavorite:(id)sender {
    
    // File path
    NSError* err = nil;
    NSURL *docs = [[NSFileManager new] URLForDirectory:NSDocumentDirectory
                                              inDomain:NSUserDomainMask
                                     appropriateForURL:nil
                                                create:YES
                                                 error:&err];
    
    NSURL* file = [docs URLByAppendingPathComponent:@"bookmarks.plist"];
    
    // Read
    NSData* data = [[NSData alloc] initWithContentsOfURL:file];
    NSArray* bookmarks = (NSArray*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    //chekc if there is already bookmark data in plist
    //if not create one
    NSMutableArray *newArray = nil;
    
    if (bookmarks) {
        newArray = [[NSMutableArray alloc] initWithArray:bookmarks];
    } else {
        newArray = [[NSMutableArray alloc] init];
    }
    
    //check if detailItem is nil or has been added into the bookmark
    if (self.detailItem == nil || [self.detailItem isFavorite]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Cannot add item"
                              message:@"Content invalid or already in Bookmark"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }else{
        //add a new key-value to detialItem
        [newArray addObject:self.detailItem];
    }
    
    //write to app/Document
    NSData* bookmarkData = [NSKeyedArchiver archivedDataWithRootObject:newArray];
    [bookmarkData writeToURL:file atomically:NO];
    
    //show star
    [self showStar];
    
}

#pragma mark social

- (IBAction)twitterSharing:(id)sender {
    
    //check detailItem not null
    if (self.detailItem) {
        //check if account has been set up
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
            SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            [tweetSheet setInitialText:[[NSString alloc] initWithFormat:@"I like this news, %@ : %@", self.detailItem.title, self.detailItem.link]];
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

#pragma mark manage star

-(void) showStar{
    [[self.view viewWithTag:10] setHidden:NO];
}

-(void) hideStar{
    [[self.view viewWithTag:10] setHidden:YES];
}

#pragma mark webView delegate

-(void)webViewDidStartLoad:(UIWebView *)webView{
    UIView* loadingView = [self.view viewWithTag:11];
    [loadingView setHidden:NO];
    loadingView.center = self.webView.center;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    UIView* loadingView = [self.view viewWithTag:11];
    [loadingView setHidden:YES];
    loadingView.center = self.webView.center;
}

@end

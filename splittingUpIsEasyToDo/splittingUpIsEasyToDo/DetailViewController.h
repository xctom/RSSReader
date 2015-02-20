//
//  DetailViewController.h
//  splittingUpIsEasyToDo
//
//  Created by xuchen on 2/11/15.
//  Copyright (c) 2015 __ChenXu__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import "BookmarkTableViewController.h"

@interface DetailViewController : UIViewController <BookmarkToWebViewDelegate>

//use NSMutableDictionary for adding key "addToFavorite" to avoid duplicate adding
@property (strong, nonatomic) NSMutableDictionary* detailItem;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (IBAction)AddToFavorite:(id)sender;

- (IBAction)twitterSharing:(id)sender;

@end


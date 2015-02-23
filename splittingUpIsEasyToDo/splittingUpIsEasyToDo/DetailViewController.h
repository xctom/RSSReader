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
#import "DismissSplashingViewDelegate.h"
#import "Article.h"

@interface DetailViewController : UIViewController <BookmarkToWebViewDelegate,UIWebViewDelegate, UIPopoverPresentationControllerDelegate>

//use NSMutableDictionary for adding key "addToFavorite" to avoid duplicate adding
@property (strong, nonatomic) Article* detailItem;

@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (IBAction)AddToFavorite:(id)sender;

- (IBAction)twitterSharing:(id)sender;

@end


//
//  BookmarkTableViewController.h
//  splittingUpIsEasyToDo
//
//  Created by xuchen on 2/13/15.
//  Copyright (c) 2015 __ChenXu__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"

@protocol BookmarkToWebViewDelegate <NSObject>

- (void) bookmark:(id)sender sendsURL:(NSURL*)url;

@end

@interface BookmarkTableViewController : UITableViewController

@property (weak, nonatomic) id<BookmarkToWebViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;
- (IBAction)enterEditMode:(id)sender;

@end

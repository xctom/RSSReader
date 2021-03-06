//
//  MasterViewController.h
//  splittingUpIsEasyToDo
//
//  Created by xuchen on 2/11/15.
//  Copyright (c) 2015 __ChenXu__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
#import "DismissSplashingViewDelegate.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (weak, nonatomic) id<DismissSplashingViewDelegate> delegate;

@end


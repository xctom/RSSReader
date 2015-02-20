//
//  NewsTableViewCell.h
//  splittingUpIsEasyToDo
//
//  Created by xuchen on 2/12/15.
//  Copyright (c) 2015 __ChenXu__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

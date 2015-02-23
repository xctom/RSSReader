//
//  Article.h
//  splittingUpIsEasyToDo
//
//  Created by xuchen on 2/20/15.
//  Copyright (c) 2015 __ChenXu__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Article : NSObject <NSCoding>

@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* link;
@property (strong, nonatomic) NSString* date;
@property (strong, nonatomic) NSString* contentSnippet;

-(BOOL)isFavorite;

@end

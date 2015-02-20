//
//  SharedNetworking.h
//  splittingUpIsEasyToDo
//
//  Created by xuchen on 2/11/15.
//  Copyright (c) 2015 __ChenXu__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SharedNetworking : NSObject

/**
 *  Singleton declaration
 *
 *  @return a instance of the class
 */
+ (id) sharedSharedNetworking;

- (void) getFeedForURL:(NSString*)url
               success:(void (^)(NSDictionary *dictionary, NSError *error))successCompletion
               failure:(void (^)(void)) failureCompletion;
@end

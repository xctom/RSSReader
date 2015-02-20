//
//  SharedNetworking.m
//  splittingUpIsEasyToDo
//
//  Created by xuchen on 2/11/15.
//  Copyright (c) 2015 __ChenXu__. All rights reserved.
//

#import "SharedNetworking.h"

@implementation SharedNetworking

+ (id)sharedSharedNetworking
{
    //structure used to test whether the block has complete or not
    static dispatch_once_t p = 0;
    
    //initialize sharedObject as nil(first call only)
    static SharedNetworking *shared= nil;
    
    //executes a block object once and only once for the application lifetime
    dispatch_once(&p, ^{
        shared = [[self alloc] init];
    });
    
    //returhs the same objec each time
    return shared;
}

- (id)init{
    if(self = [super init]){
        
    }
    return self;
}

#pragma mark - Requests
- (void)getFeedForURL:(NSString*)url
               success:(void (^)(NSDictionary *dictionary, NSError *error))successCompletion
               failure:(void (^)(void)) failureCompletion
{
    /**
     *  use networkActivityIndicator to show network activity
     */
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    //Google API url
    NSString *gURL = @"http://ajax.googleapis.com/ajax/services/feed/load?v=1.0&num=16&q=http%3A%2F%2Fnews.google.com%2Fnews%3Foutput%3Drss";
    
    //Create NSUrlSession
    NSURLSession *session = [NSURLSession sharedSession];
    
    //Create data download task
    [[session dataTaskWithURL:[NSURL URLWithString:gURL]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                
                NSHTTPURLResponse *httpPesp = (NSHTTPURLResponse*) response;
                
                if (httpPesp.statusCode == 200) {
                    NSError *jsonError;
                    
                    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
                    
                    //call the block
                    successCompletion(dictionary,nil);
                    
                } else {
                    
                    NSLog(@"Fail Not 200:");
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //call the failure if exist
                        if (failureCompletion) {
                            failureCompletion();
                        }

                    });
                }
                
                /**
                 *  turn of networkActivityIndicator
                 */
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                
            }] resume];
}

@end

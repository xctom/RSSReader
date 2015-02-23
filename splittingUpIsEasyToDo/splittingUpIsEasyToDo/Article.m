//
//  Article.m
//  splittingUpIsEasyToDo
//
//  Created by xuchen on 2/20/15.
//  Copyright (c) 2015 __ChenXu__. All rights reserved.
//

#import "Article.h"

@implementation Article

- (void)encodeWithCoder:(NSCoder *)encoder {
    //[super encodeWithCoder: encoder]; // if super conforms to NSCoding
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.link forKey:@"link"];
    [encoder encodeObject:self.date forKey:@"date"];
    [encoder encodeObject:self.contentSnippet forKey:@"contentSnippet"];
}

- (id) initWithCoder:(NSCoder *)decoder {
    //self = [super initWithCoder: decoder]; // if super conforms to NSCoding
    self = [super init];
    self.title = [decoder decodeObjectForKey:@"title"];
    self.link = [decoder decodeObjectForKey:@"link"];
    self.date = [decoder decodeObjectForKey:@"date"];
    self.contentSnippet = [decoder decodeObjectForKey:@"contentSnippet"];
    return self;
}


//traverse all bookmarks to find if there already exist this article
-(BOOL)isFavorite{
    
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

    for (Article* single in bookmarks) {
        if ([single.title isEqualToString:self.title]) {
            return YES;
        }
    }
    
    return NO;
}

@end

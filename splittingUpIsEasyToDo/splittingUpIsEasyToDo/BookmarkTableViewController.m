//
//  BookmarkTableViewController.m
//  splittingUpIsEasyToDo
//
//  Created by xuchen on 2/13/15.
//  Copyright (c) 2015 __ChenXu__. All rights reserved.
//

#import "BookmarkTableViewController.h"
#include "Article.h"

@interface BookmarkTableViewController ()

@property NSMutableArray *bookmarks;

@end

@implementation BookmarkTableViewController

- (void) viewDidLoad{
    
    //set up as a observer 
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stateChange)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stateChange)
                                                 name:NSUserDefaultsDidChangeNotification
                                               object:nil];
    //read data from plist
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
    NSArray* array = (NSArray*)[NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    self.bookmarks = [[NSMutableArray alloc] initWithArray:array];

    if (self.bookmarks) {
        for (int i = 0; i < self.bookmarks.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
    
}

- (IBAction)enterEditMode:(id)sender {
    
    if ([self.tableView isEditing]) {
        // If the tableView is already in edit mode, turn it off. Also change the title of the button to reflect the intended verb (‘Edit’, in this case).
        [self.tableView setEditing:NO animated:YES];
        
        [self.editButton setTitle:@"Edit"];
        
    }else {
        // Turn on edit mode
        [self.tableView setEditing:YES animated:YES];
        
        [self.editButton setTitle:@"Done"];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bookmarks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"bookmarkCell" forIndexPath:indexPath];
    
    Article *object = self.bookmarks[indexPath.row];
    
    cell.textLabel.text = object.title;
    //set font to system preference
    cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    
    cell.detailTextLabel.text = object.contentSnippet;
    //set font to system preference
    cell.detailTextLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"night_mode"]) {
        cell.superview.backgroundColor = [UIColor darkGrayColor];
        cell.backgroundColor = [UIColor darkGrayColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
    }else{
        cell.superview.backgroundColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.textColor = [UIColor blackColor];
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Article* object = self.bookmarks[indexPath.row];
    NSString *url = object.link;
    //send selected item back
    [self.delegate bookmark:self.bookmarks[indexPath.row] sendsURL:[NSURL URLWithString:url]];
    //dismiss the bookmark view
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.bookmarks removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        //update plist
        // File path
        NSError* err = nil;
        NSURL *docs = [[NSFileManager new] URLForDirectory:NSDocumentDirectory
                                                  inDomain:NSUserDomainMask
                                         appropriateForURL:nil
                                                    create:YES
                                                     error:&err];
        
        NSURL* file = [docs URLByAppendingPathComponent:@"bookmarks.plist"];
        
        NSData* bookmarkData = [NSKeyedArchiver archivedDataWithRootObject:self.bookmarks];
        [bookmarkData writeToURL:file atomically:NO];
    }
}

-(void)stateChange{
    [self.tableView reloadData];
}

@end

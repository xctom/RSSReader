//
//  BookmarkTableViewController.m
//  splittingUpIsEasyToDo
//
//  Created by xuchen on 2/13/15.
//  Copyright (c) 2015 __ChenXu__. All rights reserved.
//

#import "BookmarkTableViewController.h"

@interface BookmarkTableViewController ()

@property NSMutableArray *bookmarks;

@end

@implementation BookmarkTableViewController

- (void) viewDidLoad{
    //load data from UserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.bookmarks = [[NSMutableArray alloc] initWithArray:[defaults objectForKey:@"bookmarks"]];

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
    
    NSDictionary *object = self.bookmarks[indexPath.row];
    
    cell.textLabel.text = object[@"title"];
    cell.detailTextLabel.text = object[@"contentSnippet"];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *url = self.bookmarks[indexPath.row][@"link"];
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
        
        //update userdefault
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.bookmarks forKey:@"bookmarks"];
        
    }
}

@end

//
//  MasterViewController.h
//  com.pjtann.NoteLocker
//
//  Created by PT on 4/12/16.
//  Copyright © 2016 PeterTanner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class DetailViewController;

@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

// properties for the search - to store the results in an object and an array
@property (strong, nonatomic) NSArray *searchResults;
@property (strong, nonatomic) UISearchController *searchController;

@property (strong, nonatomic) NSFetchRequest *searchFetchRequest;




@end


//
//  MasterViewController.m
//  com.pjtann.NoteLocker
//
//  Created by PT on 4/12/16.
//  Copyright © 2016 PeterTanner. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

@interface MasterViewController () <UISearchResultsUpdating>


@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    // ************ start of search controller stuff
    
    // Create the search results controller and store a reference to it.
    //MasterViewController* searchResultsController = [[MasterViewController alloc] init];
   // self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsController];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    
    // The searchcontroller's searchResultsUpdater property will contain our tableView.
    self.searchController.searchResultsUpdater = self;
    
    // The searchBar contained in XCode's storyboard is a leftover from UISearchDisplayController.
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x,
                                                       self.searchController.searchBar.frame.origin.y,
                                                       self.searchController.searchBar.frame.size.width, 44.0);
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    
    
    // ************ end of search controller stuff
    
    
    

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (void)insertNewObject:(id)sender {
   // NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    //NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    //NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];

    [self performSegueWithIdentifier:@"showDetail" sender:self];
        
    // Save the context.
//    NSError *error = nil;
//    if (![context save:&error]) {
//        // Replace this implementation with code to handle the error appropriately.
//        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
//    }
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSManagedObject *object = [[self fetchedResultsController] objectAtIndexPath:indexPath];
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
        [controller setDetailItem:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
        
        controller.myManagedObjectContext = self.managedObjectContext; // attempt to send managed object from this master controller to the detail controller?????
        
    }
}



#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.searchController.active) {
        return 1;
    } else {
        return [[self.fetchedResultsController sections] count];
    }

    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchController.active) {
        return self.searchResults.count;
    } else {
        id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
        return [sectionInfo numberOfObjects];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    
    // thought this would elminate the crashing, but doesn't seem to do anything
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
            
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *object;
    if (self.searchController.active) {
        object = [self.searchResults objectAtIndex:indexPath.row];
    } else {
       object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
    
    cell.textLabel.text = [[ object valueForKey:@"noteTitle"] description];
    cell.detailTextLabel.text = [[object valueForKey:@"noteBody"] description];
    
    
}


#pragma mark - UISearchController

-(void) updateSearchResultsForSearchController:(UISearchController *) searchController{
    NSLog(@"searchbar text: %@",searchController.searchBar.text);
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Notes" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"noteDateModified" ascending:NO];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"noteBody CONTAINS[c] %@ OR noteTitle CONTAINS[c] %@", searchController.searchBar.text, searchController.searchBar.text];
    [fetchRequest setPredicate:predicate];
    self.searchResults = [self.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    [self.tableView reloadData];
    
}


#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Notes" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"noteDateModified" ascending:NO];

    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	     // Replace this implementation with code to handle the error appropriately.
	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}    

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}


-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
}

-(NSFetchRequest *) searchFetchRequest
{
    if (_searchFetchRequest != nil) {
        return _searchFetchRequest;
        
    }
    _searchFetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Title" inManagedObjectContext:self.managedObjectContext];
    [_searchFetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Title" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [_searchFetchRequest setSortDescriptors:sortDescriptors];
    
    return _searchFetchRequest;
    
}



/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

@end

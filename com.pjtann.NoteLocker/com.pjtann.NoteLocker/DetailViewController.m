//
//  DetailViewController.m
//  com.pjtann.NoteLocker
//
//  Created by PT on 4/12/16.
//  Copyright © 2016 PeterTanner. All rights reserved.
//

#import "DetailViewController.h"
#import "AppDelegate.h"

@interface DetailViewController ()


@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        
        //self.detailDescriptionLabel.text = [[self.detailItem valueForKey:@"noteDateCreated"] description];
        
        // set the data from the coredata database tables into the screen fields
        self.dateCreated.text = [[self.detailItem valueForKey:@"noteDateCreated"] description];
        self.dateModified.text = [[self.detailItem valueForKey:@"noteDateModified"] description];
        self.noteBodyText.text = [[self.detailItem valueForKey:@"noteBody"] description];
        
        // send Created date to formatting method
        NSString *sendString = self.dateCreated.text;
        NSString *returnedValue = [self dateFormat:sendString];
        self.dateCreated.text = returnedValue;
        
        // send Modified date to formatting method
        NSString *sendDateModifiedString = self.dateModified.text;
        NSString *returnedModifiedValue = [self dateFormat:sendDateModifiedString];
        self.dateModified.text = returnedModifiedValue;
        

        UIBarButtonItem *updateButton = [[UIBarButtonItem alloc] initWithTitle:@"Update" style:UIBarButtonItemStylePlain target:self action:@selector(updateNote)];
            self.navigationItem.rightBarButtonItem = updateButton;
        
    }else{

        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(addNote)];
           self.navigationItem.rightBarButtonItem = addButton;
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

-(NSString *) dateFormat:(NSString *) rawDate{

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; //initialize
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss +0000"]; // assign expected format
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:rawDate]; // convert from string to date
    [dateFormatter setDateFormat:@"MM-dd-yyyy hh:mm a"]; // assign desired format - the lower case hh instead of HH puts it into 12 hour clock, the a creates the am/pm at the end
    NSString *formattedDateString = [dateFormatter stringFromDate:dateFromString];// convert from data back to string
    
    return formattedDateString;
    
}


-(void) addNote{
    // this hopefully has brought the context over to be able to use it????
    NSManagedObjectContext *managedObjectContext = self.myManagedObjectContext;

    NSString *entityName = @"Notes";
    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:managedObjectContext];
    [newManagedObject setValue:[NSDate date] forKey:@"noteDateCreated"];
    [newManagedObject setValue:self.noteBodyText.text forKey:@"noteBody"];
    
    NSError *error = nil;
    if (![managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Save Failed with error = %@, %@", error, [error userInfo]);
        abort();
    }else{
        NSLog(@"Save Successful!");
        
    }
    
    [self performSegueWithIdentifier:@"segueFromDetailToMaster" sender:self];
    
    
}

-(void) updateNote{
  
    // this hopefully has brought the context over to be able to use it????
    NSManagedObjectContext *managedObjectContext = self.myManagedObjectContext;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];

        // update the existing record/object
        [self.detailItem setValue:[NSDate date] forKey:@"noteDateModified"];
        [self.detailItem setValue:self.noteBodyText.text forKey:@"noteBody"];
   
    NSError *error = nil;
    if (![managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Save Failed with error = %@, %@", error, [error userInfo]);
        abort();
    }else{
        NSLog(@"Save Successful!");
        
    }
    
    [self performSegueWithIdentifier:@"segueFromDetailToMaster" sender:self];
    
    
    
    
}

-(void) saveNote{
    
    // this hopefully has brought the context over to be able to use it????
    NSManagedObjectContext *managedObjectContext = self.myManagedObjectContext;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    if (self.detailItem) {
        // update the existing record/object
        [self.detailItem setValue:[NSDate date] forKey:@"noteDateModified"];
        [self.detailItem setValue:self.noteBodyText.text forKey:@"noteBody"];
        
    }else{
        //create a new object/record
        NSString *entityName = @"Notes";
        NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:managedObjectContext];
        [newManagedObject setValue:[NSDate date] forKey:@"noteDateCreated"];
        [newManagedObject setValue:self.noteBodyText.text forKey:@"noteBody"];

        NSLog(@"Line to pause during breakpoint");
        
    }
    
    NSError *error = nil;
    if (![managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Save Failed with error = %@, %@", error, [error userInfo]);
        abort();
    }else{
        NSLog(@"Save Successful!");
        
    }
    
    [self performSegueWithIdentifier:@"segueFromDetailToMaster" sender:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
//
//  ShareViewController.m
//  CopyContentToNoteExtension
//
//  Created by PT on 5/8/16.
//  Copyright © 2016 PeterTanner. All rights reserved.
//

#import "ShareViewController.h"
#import <Foundation/Foundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>


@interface ShareViewController ()



@end

@implementation ShareViewController

- (BOOL)isContentValid {
    // Do validation of contentText and/or NSExtensionContext attachments here
    return YES;
}

- (void)didSelectPost {
    // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
    NSLog(@"Inside didSelectPost..");
    
    // get url
    NSExtensionItem *item = self.extensionContext.inputItems.firstObject;
    NSItemProvider *itemProvider = item.attachments.firstObject;
    
    NSString __block *urlString;
    
    if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeURL]) {
        [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeURL options:nil completionHandler:^(NSURL *url, NSError *error) {
            
            urlString = [NSString stringWithFormat:@"%@",url.absoluteString];
            // get the title
            NSString *title = self.contentText;
            
            // create and save a new item in the database
            
            NSLog(@"urlString value = %@", urlString);

            self.noteLocker = [[NoteLockerCoreData alloc] init];
            NSManagedObjectContext *context = self.noteLocker.managedObjectContext;

            //create a new object/record
            NSString *entityName = @"Notes";
            NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
            
            
            [newManagedObject setValue:[NSDate date] forKey:@"noteDateCreated"];
            // ORIGINAL = [newManagedObject setValue:self.noteTitle.text forKey:@"noteTitle"];
            
            // contentText identifies the title of the selected post
            [newManagedObject setValue:title forKey:@"noteTitle"];
            // ORIGINAL = [newManagedObject setValue:self.noteBodyText.text forKey:@"noteBody"];
            
            // extensionContext identifies the body of hte selected post
            [newManagedObject setValue:urlString forKey:@"noteBody"];
            
            [context save:&error];
            NSLog(@"%@",error);


          
            
            
       }];
    }
    
    
    // *&*&*&&*&&@*#&@*&#*& - ADD THE CREATE NEW RECORD lines from the detailviewcontroller lines 231...
    
    
    // managed object context
    // ORIGINAL = NSManagedObjectContext *managedObjectContext = self.myManagedObjectContext;
    
    
//    NSLog(@"ContextText = title ...: %@", self.contentText);
//    NSLog(@"Extension context = body ...: %@", self.extensionContext);
    
    
//    NSManagedObject *myManagedObject = item; // WHAT do we set this equal to?
//    NSManagedObjectContext *myManagedObjectContext; // WHAT do we set this equal to?

    //NSManagedObjectContext *managedObjectContext = myExtensionContext; // WHAT do we set this equal to?

    
    
    
    

    
    
//    //create a new object/record
//    NSString *entityName = @"Notes";
//    NSManagedObject *newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:context];
//    
//    
//    [newManagedObject setValue:[NSDate date] forKey:@"noteDateCreated"];
//    // ORIGINAL = [newManagedObject setValue:self.noteTitle.text forKey:@"noteTitle"];
//    
//    // contentText identifies the title of the selected post
//        [newManagedObject setValue:self.contentText forKey:@"noteTitle"];
//    // ORIGINAL = [newManagedObject setValue:self.noteBodyText.text forKey:@"noteBody"];
//    
//    // extensionContext identifies the body of hte selected post
//    [newManagedObject setValue:self.extensionContext forKey:@"noteBody"];
//    
//    NSLog(@"Line to pause during breakpoint");

    
    
    
    

    
    
    // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
    [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
}

- (NSArray *)configurationItems {
    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    return @[];
}






@end

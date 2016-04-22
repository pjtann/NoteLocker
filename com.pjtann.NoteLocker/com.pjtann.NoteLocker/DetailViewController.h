//
//  DetailViewController.h
//  com.pjtann.NoteLocker
//
//  Created by PT on 4/12/16.
//  Copyright © 2016 PeterTanner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (nonatomic, strong) NSManagedObjectContext *myManagedObjectContext; // attempt to pass the managedObject to this detailed controller from Master controller

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UITextView *noteBodyText;

@property (weak, nonatomic) IBOutlet UITextField *dateCreated;

@property (weak, nonatomic) IBOutlet UITextField *dateModified;

@property (weak, nonatomic) IBOutlet UITextField *noteTitle;


@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end


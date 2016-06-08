//
//  ShareViewController.h
//  CopyContentToNoteExtension
//
//  Created by PT on 5/8/16.
//  Copyright © 2016 PeterTanner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import "NoteLockerCoreData.h"

@interface ShareViewController : SLComposeServiceViewController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NoteLockerCoreData *noteLocker;



@end

//
//  NoteLockerCoreData.h
//  com.pjtann.NoteLocker
//
//  Created by PT on 5/1/16.
//  Copyright © 2016 PeterTanner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
//#import <UIKit/UIKit.h>


@interface NoteLockerCoreData : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

//+(void)initializeCoreData;


@end

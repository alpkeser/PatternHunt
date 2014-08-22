//
//  DataManager.m
//  PatternHunt
//
//  Created by Alp Keser on 8/20/14.
//  Copyright (c) 2014 alp keser. All rights reserved.
//

#import "DataManager.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
@implementation DataManager
static NSMutableArray*quests;
- (void)loadDB{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Quests" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count == 0) {
        [self setupDB];
    }
    quests = [NSMutableArray new];
    for (NSManagedObject *info in fetchedObjects) {
        
    }
}
- (void)setupDB{
    // Path to the plist (in the application bundle)
    NSString *path = [[NSBundle mainBundle] pathForResource:
                      @"QuestsList" ofType:@"plist"];
    
    // Build the array from the plist
    NSMutableArray *array2 = [[NSMutableArray alloc] initWithContentsOfFile:path];
    
    // Show the string values
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSManagedObject *questData ;
    for (NSDictionary *questItem in array2){
        questData = [NSEntityDescription
                     insertNewObjectForEntityForName:@"Quests"
                     inManagedObjectContext:context];
        [questData setValue:[NSNumber numberWithInt:(int)questItem[@"questId"]] forKey:@"id"];
        [questData setValue:NO forKey:@"isCompleted"];
        [questData setValue:questItem[@"questDescription"] forKey:@"quest_description"];
        [questData setValue:questItem[@"questType"] forKey:@"quest_type"];
        [questData setValue:[NSNumber numberWithInt:(int)questItem[@"questCountLimit"]] forKey:@"quest_count_limit"];
        [questData setValue:[NSNumber numberWithInt:(int)questItem[@"questLimit"]] forKey:@"quest_limit"];
    }
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

- (void)deleteDB{
    [self deleteAllObjects:@"Quests"];
}

#pragma mark - private methods

- (void) deleteAllObjects: (NSString *) entityDescription  {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [context executeFetchRequest:fetchRequest error:&error];
    
    
    for (NSManagedObject *managedObject in items) {
    	[context deleteObject:managedObject];
//    	DLog(@"%@ object deleted",entityDescription);
    }
    if (![context save:&error]) {
//    	DLog(@"Error deleting %@ - error:%@",entityDescription,error);
    }
    
}
#pragma mark - sample codes
- (void)saveDummyData{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSManagedObject *failedBankInfo = [NSEntityDescription
                                       insertNewObjectForEntityForName:@"Quests"
                                       inManagedObjectContext:context];
    //    [failedBankInfo setValue:[NSNumber numberWithInt:0] forKey:@"id"];
    [failedBankInfo setValue:@"deneme" forKey:@"quest_description"];
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
}

- (void)loadDummyData{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Quests" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *info in fetchedObjects) {
        NSLog(@"Name: %@", [info valueForKey:@"quest_description"]);
        //        NSManagedObject *details = [info valueForKey:@"details"];
        //        NSLog(@"Zip: %@", [details valueForKey:@"zip"]);
    }
}
@end

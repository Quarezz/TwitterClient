//
//  TWCPostsStorage.m
//  TwitClient
//
//  Created by Ruslan Nikolaev on 03/11/2017.
//  Copyright © 2017 Ruslan Nikolaev. All rights reserved.
//

#import "TWCPostsStorage.h"
#import <CoreData/CoreData.h>
#import "TWCPostItem.h"
#import "TWCPostStorageItem+CoreDataClass.h"

static NSString *kEntityName = @"TWCPostStorageItem";

@interface TWCPostsStorage()

@property (nonatomic, strong) NSPersistentStoreCoordinator *storeCoordinator;

@end

@implementation TWCPostsStorage

#pragma mark - Initialization


-(id) initWithInMemoryStorage:(BOOL)inMemory
{
    if (self = [super init])
    {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TWCPostStorageItem" withExtension:@"momd"];
        NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        self.storeCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        
        if (inMemory)
        {
            [self.storeCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:nil];
        }
        else
        {
            NSURL *documentsUrl = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
            NSURL *storageUrl = [documentsUrl URLByAppendingPathComponent:@"Storage.sqlite"];
            
            NSError *error = nil;
            [self.storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storageUrl options:nil error:&error];
            if (error)
            {
                NSLog(@"Error during Core Data setup: %@",error.localizedDescription);
            }
        }
    }
    return self;
}

#pragma mark - TWCPostsStorageInterface

-(void) storePosts: (NSArray<TWCPostItem *> *) posts
{
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    context.persistentStoreCoordinator = self.storeCoordinator;
    
    [self clearPosts];
    
    [posts enumerateObjectsUsingBlock:^(TWCPostItem * _Nonnull post, NSUInteger idx, BOOL * _Nonnull stop) {
        
        TWCPostStorageItem *storageItem = [NSEntityDescription insertNewObjectForEntityForName:kEntityName inManagedObjectContext:context];
        storageItem.identifier = post.identifier;
        storageItem.text = post.text;
        storageItem.date = post.date;
        storageItem.favouriteCount = post.favouriteCount;
        storageItem.authorName = post.authorName;
        storageItem.authorScreenName = post.authorScreenName;
    }];
    
    [context save:nil];
}

-(NSArray<TWCPostItem *> *) fetchPosts
{
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    context.persistentStoreCoordinator = self.storeCoordinator;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:kEntityName];
    
    NSError *error = nil;
    NSArray *storedItems = [context executeFetchRequest:fetchRequest error:&error];
    if (error)
    {
        NSLog(@"%@",error.localizedDescription);
    }
    
    NSMutableArray<TWCPostItem *> *posts = [NSMutableArray new];
    [storedItems enumerateObjectsUsingBlock:^(TWCPostStorageItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [posts addObject:[TWCPostItem fromStorableData:obj]];
    }];
    return posts;
}

-(void) clearPosts
{
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    context.persistentStoreCoordinator = self.storeCoordinator;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:kEntityName];
    
    NSError *error = nil;
    NSArray *storedItems = [context executeFetchRequest:fetchRequest error:&error];
    if (error)
    {
        NSLog(@"%@",error.localizedDescription);
    }
    [storedItems enumerateObjectsUsingBlock:^(TWCPostStorageItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [context deleteObject:obj];
    }];
    [context save:nil];
}
@end

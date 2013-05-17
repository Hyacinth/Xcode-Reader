#import "SLibraryManager.h"

const NSString *SLibraryManagerWillReloadLibrariesNotification = @"Library Manager Will Reload Libraries";
const NSString *SLibraryManagerDidReloadLibrariesNotification = @"Library Manager Did Reload Libraries";

@interface SLibraryManager()

// Use SLibrary's rootNodes property to prefetch all libraries' root nodes.
- (void)prefetchLibrariesRootNodes;

@end

@implementation SLibraryManager

- (id)init
{
    self = [super init];
    if (self) {
        // NSManagedObjectModel
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"docSet" withExtension:@"mom"];
        NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];

        // NSPersistentStoreCoordinator.
        _coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    }
    return self;
}

+ (id)share
{
    static SLibraryManager *share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[SLibraryManager alloc] init];
    });
    return share;
}

- (void)reloadLibraries
{
    // Remove old store in coordinator.
    if (self.coordinator.persistentStores) {
        for (NSPersistentStore *store in self.coordinator.persistentStores) {
            [self.coordinator removePersistentStore:store error:nil];
        }
    }

    // Scan and locate files with docset extension in App's Document directory.
    NSMutableArray *libraries = [[NSMutableArray alloc] init];
    NSMutableDictionary *librariesByStoreID = [[NSMutableDictionary alloc] init];
    
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    for (NSString *path in [fileManager contentsOfDirectoryAtPath:documentPath error:nil]) {
        if ([path.pathExtension isEqualToString:@"docset"]) {
            NSString *libraryPath = [documentPath stringByAppendingPathComponent:path];
            SLibrary *library = [[SLibrary alloc] initWithPath:libraryPath];
            
            // Add persistent store into coordinator.
            [self.coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:library.storeURL options:@{NSReadOnlyPersistentStoreOption : @YES} error:nil];

            NSPersistentStore *store = [self.coordinator persistentStoreForURL:library.storeURL];
            [libraries addObject:library];
            [librariesByStoreID setObject:library forKey:store.identifier];
        }
    }

    self.libraries = libraries;
    self.librariesByStoreID = librariesByStoreID;

    // Every time reload libraries, prefetch libraries' root nodes.
    [self prefetchLibrariesRootNodes];
}

- (void)prefetchLibrariesRootNodes
{

}

@end
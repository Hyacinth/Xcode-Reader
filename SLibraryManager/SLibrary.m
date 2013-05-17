#import "SLibrary.h"
#import "SLibraryManager.h"
#import "SNode.h"

NSString *const kLibraryInfoPlistPath = @"Contents/Info.plist";
NSString *const kLibraryStorePath = @"Contents/Resources/docSet.dsidx";
NSString *const kLibraryDocumentPath = @"Contents/Resources/Documents";

@implementation SLibrary

- (id)initWithPath:(NSString *)path
{
    self = [super init];
    if (self) {
        _path = path;
        NSString *infoPlistPath = [path stringByAppendingPathComponent:kLibraryInfoPlistPath];
        NSDictionary *infoPlist = [NSDictionary dictionaryWithContentsOfFile:infoPlistPath];
        if (infoPlist) {
            _name = infoPlist[@"CFBundleName"];
            _copyright = infoPlist[@"NSHumanReadableCopyright"];
            _ID = infoPlist[@"CFBundleIdentifier"];
            _fallback = infoPlist[@"DocSetFallbackURL"];

            NSString *storePath = [_path stringByAppendingPathComponent:kLibraryStorePath];
            _storeURL = [NSURL fileURLWithPath:storePath];
        }   else {
            NSLog(@"Library: fail to init because of nil info.plist");
        }
    }
    return self;
}

- (NSArray *)rootNodes
{
    if (_rootNodes == nil) {
        // Create NSManagedObjectContext.
        NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSConfinementConcurrencyType];
        context.persistentStoreCoordinator = [[SLibraryManager share] coordinator];
 
        // ObjectIDDescription
        NSExpressionDescription *objectIDDescription = [[NSExpressionDescription alloc] init];
        objectIDDescription.name = @"Object ID";
        objectIDDescription.expression = [NSExpression expressionForEvaluatedObject];
        objectIDDescription.expressionResultType = NSObjectIDAttributeType;
        
        // Fetch request and request properties.
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Node"];

        // Predicate
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"kIsSearchable == NO AND primaryParent.kName == [c] %@", @"Developer Library"];

        // SortDescriptors
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"kName" ascending:YES selector:@selector(caseInsensitiveCompare:)]];

        // Affected Stores
        fetchRequest.affectedStores = @[[[[SLibraryManager share] coordinator] persistentStoreForURL:self.storeURL]];

        // Result type.
        fetchRequest.resultType = NSDictionaryResultType;

        // Properties to fetch.
        NSEntityDescription *nodeEntity = [NSEntityDescription entityForName:@"Node" inManagedObjectContext:context];
        NSAttributeDescription *nodeNameAttribute = [nodeEntity attributesByName][@"kName"];
        fetchRequest.propertiesToFetch = @[objectIDDescription, nodeNameAttribute];

        NSArray *fetchResults = [context executeFetchRequest:fetchRequest error:nil];

        // Turn fetch result into SNodes.
        NSMutableArray *rootNodes = [[NSMutableArray alloc] init];
        for (NSDictionary *fetchResult in fetchResults) {
            SNode *node = [[SNode alloc] initWithName:fetchResult[@"kName"] ID:fetchResult[@"objectID"]];
            [rootNodes addObject:node];
        }

        _rootNodes = rootNodes;
    }
    return _rootNodes;
}

@end
#import <Foundation/Foundation.h>
#import "SSearchCompletionOperation.h"
#import "SSearchToken.h"
#import "SSearchNode.h"
#import "STokenSearchOperation.h"
#import "SNodeSearchOperation.h"
#import "SLibraryManager.h"

@class STokenSearchOperation, SNodeSearchOperation, SSearchManager;

UIKIT_EXTERN NSString *const kSearchManagerTokenResultsKey;
UIKIT_EXTERN NSString *const kSearchManagerNodeResultsKey;
UIKIT_EXTERN NSString *const kSearchManagerCellDatasForTokenKey;
UIKIT_EXTERN NSString *const kSearchManagerCellDatasForNodeKey;

UIKIT_EXTERN NSString *const SSearchManagerDidBeginPrepareSearchNotification;
UIKIT_EXTERN NSString *const SSearchManagerDidEndPrepareSearchNotification;

@protocol SSearchManagerDelegate <NSObject>

- (void)searchManager:(SSearchManager *)searchManager didFinishSearchWithSearchResult:(NSDictionary *)searchResult;

@end

@interface SSearchManager : NSObject

// Pre-fetched STokens in memory from Core Data.
@property (nonatomic, strong) NSArray *prefetchedTokens;

// Pre-fetched SNodes in memory from Core Data.
@property (nonatomic, strong) NSArray *prefetchedNodes;

// Boolean value to determine if SSearchManager is in the preparing progress.
@property (nonatomic, assign) BOOL preparing;

// NSOperationQueue.
@property (nonatomic, strong) NSOperationQueue *searchQueue;

// STokenSearchOperation.
@property (nonatomic, strong) STokenSearchOperation *tokenSearchOperation;

// SNodeSearchOperation.
@property (nonatomic, strong) SNodeSearchOperation *nodeSearchOperation;

// Completion operation that depend on token and node search operation.
@property (nonatomic, strong) SSearchCompletionOperation *searchCompletionOperation;

// Store historical token search operation for following search.
@property (nonatomic, strong) NSMutableArray *tokenSearchHistory;

// Search string.
@property (nonatomic, copy) NSString *searchString;

// Delegate. SSearchController.
@property (nonatomic, strong) id<SSearchManagerDelegate> delegate;

// The singleton search manager.
+ (id)share;

// Prefetch all searchable tokens and nodes from Core Data into STokens and SNodes.
- (void)prepareSearch;

// The only single method search manager need to execute a search, the only parameter it needs is searchString.
// Search Manager will take care of everything, like cancel previous search, execute new search, or search operation's dependency and etc.
- (void)searchWithSearchString:(NSString *)searchString delegate:(id<SSearchManagerDelegate>)delegate;

@end
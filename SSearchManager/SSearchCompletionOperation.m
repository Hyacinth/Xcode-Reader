//
//  SSearchCompletionOperation.m
//  Xcode Reader
//
//  Created by Song Hui on 13-5-13.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import "SSearchCompletionOperation.h"
#import "SSearchManager.h"

@implementation SSearchCompletionOperation

- (id)initWithSearchString:(NSString *)searchString
{
	self = [super init];
	if (self) {
		_searchString = searchString;
	}
	return self;
}

- (void)main
{
	NSLog(@"SearchCompletionOperation. \"%@\":start.", self.searchString);

	if ([self isCancelled]) return;

	NSArray *nodes, *tokens, *dataForNodes, *dataForTokens = nil;
	
	// Check search strings, if search strings are not equal, completion should return.
	if ([self.searchString isEqualToString:[[SSearchManager share] searchString]]) {
		// Obtain nodes, cell datas.
		if ([self.searchString isEqualToString:[[[SSearchManager share] nodeSearchOperation] searchString]]) {
			nodes = [[[SSearchManager share] nodeSearchOperation] nodes];
			dataForNodes = [[[SSearchManager share] nodeSearchOperation] cellDatas];
		}	else {
			return;
		}
		// Obtain tokens, cell datas.
		if ([self.searchString isEqualToString:[[[SSearchManager share] tokenSearchOperation] searchString]]) {
			tokens = [[[SSearchManager share] tokenSearchOperation] tokens];
			dataForTokens = [[[SSearchManager share] tokenSearchOperation] cellDatas];;
		}	else {
			return;
		}
	}	else {
		return;
	}

	if ([self isCancelled]) return;

	[[NSOperationQueue mainQueue] addOperationWithBlock:^{
		NSDictionary *searchResult = @{kSearchManagerNodeResultsKey: nodes,
								 kSearchManagerCellDatasForNodeKey : dataForNodes,
								 kSearchManagerTokenResultsKey : tokens,
								 kSearchManagerCellDatasForTokenKey : dataForTokens};
		NSLog(@"Search Completion Operation \"%@\" complete and call delegate method.", self.searchString);
		[[[SSearchManager share] delegate] searchManager:[SSearchManager share]
						 didFinishSearchWithSearchResult:searchResult];
	}];
}

@end

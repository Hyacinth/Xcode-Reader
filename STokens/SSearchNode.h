#import <Foundation/Foundation.h>
#import "SNode.h"

// A subclass of SNode that has extra properties to assistant SNodeSearchOperation.
@interface SSearchNode : SNode <NSCopying>

// A mutable array contains all match ranges regarding search string with this node.
@property (nonatomic, strong) NSMutableArray *matchRanges;

// Minimum match range's location among all ranges in matchRanges.
@property (nonatomic, assign) NSInteger minimumMatchLocation;

@end
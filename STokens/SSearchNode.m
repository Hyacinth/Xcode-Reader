#import "SSearchNode.h"

@implementation SSearchNode

- (id)initWithName:(NSString *)name ID:(NSManagedObjectID *)ID
{
    self = [super initWithName:name ID:ID];
    if (self) {
        _matchRanges = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    SSearchNode *copy = [super copyWithZone:zone];
    copy.matchRanges = [[NSMutableArray alloc] initWithArray:self.matchRanges copyItems:YES];
    return copy;
}

@end
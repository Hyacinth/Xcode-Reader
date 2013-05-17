#import "SDocumentTag.h"
#import "SDocumentTagView.h"

@implementation SDocumentTag

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (id)initWithTagName:(NSAttributedString *)tagName type:(SDocumentTagType)type
{
    self = [self init];
    if (self) {
        _tagName = tagName;
        _type = type;
    }
	return self;
}

@end
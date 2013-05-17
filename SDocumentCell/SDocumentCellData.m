#import "SDocumentCellData.h"

@implementation SDocumentCellData

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"Data: \n mainAttributedText: %@\n descriptionAttributedText: %@\n mainFitSize: %@\n descriptionFitSize: %@\n tagsCount: %d\n imageName: %@\n cellHeight: %.f \n \n", self.mainAttributedText.string, self.descriptionAttributedText.string, NSStringFromCGSize(self.mainFitSize), NSStringFromCGSize(self.descriptionFitSize), self.tags.count, self.imageName, self.cellHeight];
}

@end
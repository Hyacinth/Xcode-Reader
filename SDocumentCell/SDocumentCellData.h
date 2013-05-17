#import <Foundation/Foundation.h>
#import "SDocumentTag.h"

// Encapsulate all needed datas of Document Cell.
@interface SDocumentCellData : NSObject

// Main label's attributedText.
@property (nonatomic, strong) NSAttributedString *mainAttributedText;

// Description label's attributedText.
@property (nonatomic, strong) NSAttributedString *descriptionAttributedText;

// Main label's sizeThatFit: size.
@property (nonatomic, assign) CGSize mainFitSize;

// Description label's sizeThatFit: size.
@property (nonatomic, assign) CGSize descriptionFitSize;

// Cell's SDocumentTags.
@property (nonatomic, strong) NSArray *tags;

// Cell's image name.
@property (nonatomic, copy) NSString *imageName;

// Accessory type.
@property (nonatomic, assign) UITableViewCellAccessoryType accessoryType;

// Cell's height.
@property (nonatomic, assign) CGFloat cellHeight;

@end


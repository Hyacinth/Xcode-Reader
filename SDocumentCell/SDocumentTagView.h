#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SDocumentTag.h"

UIKIT_EXTERN const CGFloat kTagBorderInset;

@interface SDocumentTagView : UIView

- (id)initWithTags:(NSArray *)tags;

@end
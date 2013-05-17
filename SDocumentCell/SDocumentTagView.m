#import "SDocumentTagView.h"

NSString *const kTagTypeContainerBorderImageName = @"DocumentTag_Border_Container.png";
NSString *const kTagTypeDeprecatedBorderImageName = @"DocumentTag_Border_Deprecated.png";
const CGFloat kTagBorderInset = 5.0;
const CGFloat kTagBorderSpace = 10.0;
const CGFloat kTagCornerRadius = 6.0;

@implementation SDocumentTagView

- (id)initWithTags:(NSArray *)tags
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        CGFloat tagViewWidth = 0.0;
        CGFloat tagViewHeight = 0.0;
        CGFloat x = 0.0;

		NSMutableArray *tagLabels = [[NSMutableArray alloc] init];
		NSMutableArray *borderViews = [[NSMutableArray alloc] init];
        for (SDocumentTag *tag in tags) {
            UILabel *tagLabel = [[UILabel alloc] init];
            tagLabel.backgroundColor = [UIColor clearColor];

            tagLabel.attributedText = tag.tagName;
            [tagLabel sizeToFit];
            CGSize tagSize = tagLabel.bounds.size;
            
			UIImage *borderImage = nil;
            
            if (tag.type == SDocumentTagTypeContainer) {
				borderImage = [[UIImage imageNamed:@"DocumentTag_Border_Container.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(kTagCornerRadius, kTagCornerRadius, kTagCornerRadius, kTagCornerRadius)];
            }   else if (tag.type == SDocumentTagTypeDeprecated) {
				borderImage = [[UIImage imageNamed:@"DocumentTag_Border_Deprecated.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(kTagCornerRadius, kTagCornerRadius, kTagCornerRadius, kTagCornerRadius)];
			}

            UIImageView *borderView = [[UIImageView alloc] initWithImage:borderImage];
            tagLabel.frame = CGRectMake(x + kTagBorderInset, kTagBorderInset, tagSize.width, tagSize.height);
            borderView.frame = CGRectMake(x, 0, tagSize.width + 2 * kTagBorderInset, tagSize.height + 2 * kTagBorderInset);
            
			[tagLabels addObject:tagLabel];
			[borderViews addObject:borderView];

            x += borderView.bounds.size.width + kTagBorderSpace;
            tagViewHeight = borderView.bounds.size.height;
        }

        tagViewWidth = x - kTagBorderSpace;
        self.frame = CGRectMake(0, 0, tagViewWidth, tagViewHeight);
        self.backgroundColor = [UIColor clearColor];
//        self.layer.shouldRasterize = YES;

		for (UIImageView *borderView in borderViews) {
			[self addSubview:borderView];
		}

		for (UILabel *tagLabel in tagLabels) {
			[self addSubview:tagLabel];
		}
    }
    return self;
}

@end
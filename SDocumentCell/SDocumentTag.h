#import <Foundation/Foundation.h>
#import "SDocumentTagView.h"

typedef NS_ENUM(NSInteger, SDocumentTagType) {
    SDocumentTagTypeContainer,
    SDocumentTagTypeDeprecated,
	SDocumentTagTypePlaceholder1
};

@interface SDocumentTag : NSObject

@property (nonatomic, strong) NSAttributedString *tagName;

@property (nonatomic, assign) SDocumentTagType type;

- (id)initWithTagName:(NSAttributedString *)tagName type:(SDocumentTagType)type;

@end
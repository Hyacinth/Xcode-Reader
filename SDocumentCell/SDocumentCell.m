//
//  SDocumentCell.m
//  Xcode Reader
//
//  Created by Song Hui on 13-5-13.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import "SDocumentCell.h"

const CGSize kCellLabelSizeThatFitAccessoryNone = {270, CGFLOAT_MAX};
const CGSize kCellLabelSizeThatFitAccessoryIndicator = {240, CGFLOAT_MAX};
const CGFloat kCellVerticalSpace = 15.0;
const CGFloat kCellLabelVerticalSpace = 10.0;
const CGPoint kCellImageCenter = {25.0, 25.0};
const CGFloat kCellLabelLeftSpace = 40.0;

@interface SDocumentCell ()

// Main label's attributes for token.
@property (nonatomic, strong) NSDictionary *tokenMainAttributes;

// Main label's attributes for node.
@property (nonatomic, strong) NSDictionary *nodeMainAttributes;

// Tag label's attributes for type container.
@property (nonatomic, strong) NSDictionary *tagTypeContainerAttributes;

// Tag label's attributes for type deprecated.
@property (nonatomic, strong) NSDictionary *tagTypeDeprecatedAttributes;

// Description label's attributes.
@property (nonatomic, strong) NSDictionary *descriptionAttributes;

@end

@implementation SDocumentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		// Background.
		self.contentView.backgroundColor = [UIColor clearColor];
		UIImage *backgroundImage = [[UIImage imageNamed:@"DocumentCell-Background.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(1.0, 0, 1.0, 0)];
//        self.backgroundView.layer.contents = (__bridge id)[backgroundImage CGImage];
		self.backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
		// Selection.
		self.selectionStyle = UITableViewCellSelectionStyleBlue;
		// Main label.
		_main = [[UILabel alloc] init];
		_main.backgroundColor = [UIColor clearColor];
		_main.numberOfLines = NSIntegerMax;
		[self.contentView addSubview:_main];
		// Description label.
		_description = [[UILabel alloc] init];
		_description.backgroundColor = [UIColor clearColor];
		_description.numberOfLines = 2;
		[self.contentView addSubview:_description];
		// Icon.
		_icon = [[UIImageView alloc] initWithFrame:CGRectZero];
		[self.contentView addSubview:_icon];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)didEndDiplayedByTableView
{
	self.tagView = nil;
	self.icon.image = nil;
	self.accessoryType = UITableViewCellAccessoryNone;
}

#pragma mark - Accessor method.

- (void)setTagView:(SDocumentTagView *)tagView
{
	[_tagView removeFromSuperview];
	_tagView = tagView;
	[self.contentView addSubview:_tagView];
}

- (void)setData:(SDocumentCellData *)data
{
	if (_data != data) {
		_data = data;
		self.main.attributedText = data.mainAttributedText;
		if (data.tags == nil) {
			self.tagView = nil;
		}	else {
			self.tagView = [[SDocumentTagView alloc] initWithTags:data.tags];
		}

		// Make sure number of lines.
//		self.description.numberOfLines = 2;
		self.description.numberOfLines = 0;
//		self.description.numberOfLines = NSIntegerMax;
		self.description.attributedText = data.descriptionAttributedText;

		self.icon.image = [UIImage imageNamed:data.imageName];
		self.accessoryType = data.accessoryType;
		[self setNeedsLayout];
	}
}

// Lazy initialization.
- (NSDictionary *)tokenMainAttributes
{
	if (_tokenMainAttributes == nil) {
		
		// NSParagraphStyle
		NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
		paragraph.lineBreakMode = NSLineBreakByCharWrapping | NSLineBreakByTruncatingTail;
//		paragraph.lineBreakMode = NSLineBreakByCharWrapping;
		paragraph.maximumLineHeight = 21.0;
		paragraph.minimumLineHeight = 21.0;
		paragraph.hyphenationFactor = 1.0;

		_tokenMainAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0],
						   NSForegroundColorAttributeName : [UIColor colorWithRed:0.24 green:0.24 blue:0.24 alpha:1.0],
						   NSParagraphStyleAttributeName : paragraph};
	}
	return _tokenMainAttributes;
}

// Lazy initialization.
- (NSDictionary *)nodeMainAttributes
{
	if (_nodeMainAttributes == nil) {
		NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
		paragraph.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
//		paragraph.lineBreakMode = NSLineBreakByWordWrapping;
		paragraph.maximumLineHeight = 21.0;
		paragraph.minimumLineHeight = 21.0;

		_nodeMainAttributes = @{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0],
						  NSForegroundColorAttributeName : [UIColor colorWithRed:0.24 green:0.24 blue:0.24 alpha:1.0],
						  NSParagraphStyleAttributeName : paragraph};
	}
	return _nodeMainAttributes;
}

- (NSDictionary *)tagTypeContainerAttributes
{
	if (_tagTypeContainerAttributes == nil) {
		NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
		paragraph.lineBreakMode = NSLineBreakByTruncatingTail;
//		paragraph.maximumLineHeight = 16.0;
//		paragraph.minimumLineHeight = 16.0;

		_tagTypeContainerAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:10.0],
								  NSForegroundColorAttributeName : [UIColor colorWithRed:0.47 green:0.47 blue:0.47 alpha:1.0],
								  NSParagraphStyleAttributeName : paragraph};
	}
	return _tagTypeContainerAttributes;
}

- (NSDictionary *)tagTypeDeprecatedAttributes
{
	if (_tagTypeDeprecatedAttributes == nil) {
		NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
		paragraph.lineBreakMode = NSLineBreakByTruncatingTail;
//		paragraph.maximumLineHeight = 16.0;
//		paragraph.minimumLineHeight = 16.0;

		_tagTypeDeprecatedAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:10.0],
								  NSForegroundColorAttributeName : [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0],
								  NSParagraphStyleAttributeName : paragraph};
	}
	return _tagTypeDeprecatedAttributes;
}

- (NSDictionary *)descriptionAttributes
{
	if (_descriptionAttributes == nil) {
		NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
		paragraph.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
//		paragraph.lineBreakMode = NSLineBreakByWordWrapping;
		paragraph.maximumLineHeight = 16.0;
		paragraph.minimumLineHeight = 16.0;

		_descriptionAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:10.0],
							 NSForegroundColorAttributeName : [UIColor colorWithRed:0.71 green:0.71 blue:0.71 alpha:1.0],
							 NSParagraphStyleAttributeName : paragraph};
	}
	return _descriptionAttributes;
}

#pragma mark - Data composition.

- (SDocumentCellData *)dataForCellWithToken:(SToken *)token
{
	SDocumentCellData *data = [[SDocumentCellData alloc] init];
	CGSize sizeThatFit = CGSizeZero;
	CGFloat cellHeight = 0;
	

	// Accessory type decides sizeThatFit.
	data.accessoryType = UITableViewCellAccessoryNone;
	if (data.accessoryType == UITableViewCellAccessoryNone) {
		sizeThatFit = kCellLabelSizeThatFitAccessoryNone;
	}	else if (data.accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
		sizeThatFit = kCellLabelSizeThatFitAccessoryIndicator;
	}

	// Main
	data.mainAttributedText = [[NSAttributedString alloc] initWithString:token.name
															  attributes:self.tokenMainAttributes];
	self.main.attributedText = data.mainAttributedText;
	data.mainFitSize = [self.main sizeThatFits:sizeThatFit];
	cellHeight += kCellVerticalSpace + data.mainFitSize.height;

    // Tags
	NSMutableArray *tags = [[NSMutableArray alloc] init];
	if (token.container) {
		NSAttributedString *tagName = [[NSAttributedString alloc] initWithString:token.container
																	  attributes:self.tagTypeContainerAttributes];
		SDocumentTag *tag = [[SDocumentTag alloc] initWithTagName:tagName
															 type:SDocumentTagTypeContainer];
		[tags addObject:tag];
	}
	if (token.deprecated) {
		NSAttributedString *tagName = [[NSAttributedString alloc] initWithString:token.deprecatedSinceVersion
																	  attributes:self.tagTypeDeprecatedAttributes];
		SDocumentTag *tag = [[SDocumentTag alloc] initWithTagName:tagName
															 type:SDocumentTagTypeDeprecated];
		[tags addObject:tag];
	}
	if (tags.count == 0) {
		data.tags = nil;
	}	else {
		data.tags = tags;
		SDocumentTagView *tagView = [[SDocumentTagView alloc] initWithTags:data.tags];
		cellHeight += kCellLabelVerticalSpace + tagView.bounds.size.height ;
	}

	// Description
	if (token.abstract) {
		data.descriptionAttributedText = [[NSAttributedString alloc] initWithString:token.abstract
																		 attributes:self.descriptionAttributes];
		self.description.attributedText = data.descriptionAttributedText;
		data.descriptionFitSize = [self.description sizeThatFits:sizeThatFit];
		cellHeight += kCellLabelVerticalSpace + data.descriptionFitSize.height;
	}

	// Cell height.
	cellHeight += kCellVerticalSpace;
	data.cellHeight = cellHeight;

	// Image name.
	data.imageName = token.type;

	return data;
}

- (SDocumentCellData *)dataForCellWithNode:(SNode *)node
{
	SDocumentCellData *data = [[SDocumentCellData alloc] init];
	CGSize sizeThatFit = CGSizeZero;
	CGFloat cellHeight = 0;
	
	// Expandable decides accessory type.
	data.accessoryType = node.expandable ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
	// Accessory type decides sizeThatFit
	if (data.accessoryType == UITableViewCellAccessoryNone) {
		sizeThatFit = kCellLabelSizeThatFitAccessoryNone;
	}	else if (data.accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
		sizeThatFit = kCellLabelSizeThatFitAccessoryIndicator;
	}

	// Main
	data.mainAttributedText = [[NSAttributedString alloc] initWithString:node.name
															  attributes:self.nodeMainAttributes];
	self.main.attributedText = data.mainAttributedText;
	data.mainFitSize = [self.main sizeThatFits:sizeThatFit];

	// Cell height.
	cellHeight = 2 * kCellVerticalSpace + data.mainFitSize.height;
	data.cellHeight = cellHeight;

	// Image name.
	if ([node.nodeType isEqualToString:@"file"]) {
		data.imageName = @"Book.png";
	}	else {
		if (node.documentType == 0) {
			data.imageName = @"Book.png";
		}	else if (node.documentType == 1) {
			data.imageName = @"Sample-Code.png";
		}	else if (node.documentType == 2) {
			data.imageName = @"Reference.png";
		}	else {
			data.imageName = @"Book.png";
		}
	}

	return data;
}

#pragma mark - Layout subviews

- (void)layoutSubviews
{
	[super layoutSubviews];
//
//	if ([self isSelected]) {
//		// Adjust position when selected.
//	}	else {
		[self.icon sizeToFit];
		self.icon.center = CGPointMake(20.0, 30.0);

		CGFloat y = 0.0;
		y += kCellVerticalSpace;

		self.main.frame = CGRectMake(kCellLabelLeftSpace, y, self.data.mainFitSize.width, self.data.mainFitSize.height);
		y += self.data.mainFitSize.height;

		if (self.tagView) {
			y += kCellLabelVerticalSpace;
			self.tagView.frame = CGRectMake(kCellLabelLeftSpace, y, self.tagView.bounds.size.width, self.tagView.bounds.size.height);
			y += self.tagView.bounds.size.height;
		}

		if (self.data.descriptionAttributedText) {
			y += kCellLabelVerticalSpace;
//			CGFloat descriptionHeightAddition = 10.0;
			self.description.frame = CGRectMake(kCellLabelLeftSpace, y, self.data.descriptionFitSize.width, self.data.descriptionFitSize.height);
		}
//	}
}

@end

//
//  SSearchHeader.m
//  Xcode Reader
//
//  Created by Song Hui on 13-5-14.
//  Copyright (c) 2013年 Code Bone. All rights reserved.
//

#import "SSearchHeader.h"

const CGFloat kHeaderLabelLeftSpace = 40.0;

@interface SSearchHeader ()

@property (nonatomic, strong) NSDictionary *headerTitleAttributes;

@end

@implementation SSearchHeader

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//		self.contentView.backgroundColor = [UIColor clearColor];
//		UIImage *backgroundImage = [[UIImage imageNamed:@"SearchHeader-Background.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//		self.backgroundView.layer.contents = (__bridge id)[backgroundImage CGImage];
//		self.textLabel.shadowColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0];
//		self.textLabel.shadowOffset = CGSizeMake(0, 1);
//    }
//    return self;
//}

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithReuseIdentifier:reuseIdentifier];
	if (self) {
		self.contentView.backgroundColor = [UIColor clearColor];
		UIImage *backgroundImage = [[UIImage imageNamed:@"SearchHeader-Background.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(1.0, 0.0, 1.0, 0.0)];
		self.backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];

		_headerLabel = [[UILabel alloc] init];
		_headerLabel.backgroundColor = [UIColor clearColor];
		_headerLabel.shadowColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0];
		_headerLabel.shadowOffset = CGSizeMake(0, 1);

		[self.contentView addSubview:self.headerLabel];
//
//		self.textLabel.shadowColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0];
//		self.textLabel.shadowOffset = CGSizeMake(0, 1);
	}
	return self;
}

- (NSDictionary *)headerTitleAttributes
{
	if (_headerTitleAttributes == nil) {
		_headerTitleAttributes = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0],
							 NSForegroundColorAttributeName : [UIColor colorWithRed:0.29 green:0.29 blue:0.29 alpha:1.0]};
	}
	return _headerTitleAttributes;
}

//- (void)prepareForReuse
//{
//	self.textLabel.attributedText = nil;
//}

- (void)setHeaderTitle:(NSString *)headerTitle
{
//	if (_headerTitle != headerTitle) {
		_headerTitle = headerTitle;
		self.headerLabel.attributedText = [[NSAttributedString alloc] initWithString:_headerTitle
																		attributes:self.headerTitleAttributes];
//		[self.textLabel sizeToFit];
		[self setNeedsLayout];
//	}
}

//
- (void)layoutSubviews
{
	[super layoutSubviews];
	[self.headerLabel sizeToFit];
	self.headerLabel.frame = CGRectMake(kHeaderLabelLeftSpace, (self.frame.size.height - self.headerLabel.bounds.size.height) / 2, self.headerLabel.bounds.size.width, self.headerLabel.bounds.size.height);
	self.headerLabel.frame = CGRectIntegral(self.headerLabel.frame);
//	self.textLabel.frame = CGRectMake(kHeaderLabelLeftSpace, (self.frame.size.height - self.textLabel.bounds.size.height) / 2, self.textLabel.bounds.size.width, self.textLabel.bounds.size.height);
//	self.textLabel.frame = CGRectIntegral(self.textLabel.frame);
}

@end

//
//  SPopoverBackgroundView.m
//  Xcode Reader
//
//  Created by Song Hui on 13-4-23.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import "SPopoverBackgroundView.h"

const CGFloat kSPopoverBackgroundViewArrowBase = 22.0;
const CGFloat kSPopoverBackgroundViewArrowHeight = 16.0;
const CGFloat kSPopoverBackgroundViewArrowVerticalOffset = 1.0;
const CGFloat kSPopoverBackgroundViewBorderVerticalOffset = 0.0;
const UIEdgeInsets kSPopoverBackgroundViewBorderImageCapInsets = {7.0, 7.0, 7.0, 7.0};
const UIEdgeInsets kSPopoverBackgroundViewBorderContentInsets = {7.0, 7.0, 7.0, 7.0};

NSString *const kSPopoverBackgroundViewBorderImageName = @"Popover-Border.png";
NSString *const kSPopoverBackgroundViewArrowImageName = @"Popover-Arrow.png";

@interface SPopoverBackgroundView()

@property (nonatomic, strong) UIImageView *borderView;

@property (nonatomic, strong) UIImageView *arrowView;

@end

@implementation SPopoverBackgroundView

@synthesize arrowOffset = _arrowOffset, arrowDirection = _arrowDirection;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kSPopoverBackgroundViewArrowImageName]];
        _borderView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:kSPopoverBackgroundViewBorderImageName] resizableImageWithCapInsets:kSPopoverBackgroundViewBorderImageCapInsets]];
        [self addSubview:_borderView];
        //  Arrow will be the uppermost view.
        [self addSubview:_arrowView];  
        [self setNeedsLayout];

        //  Custom border view's shadow.
        [_borderView.layer setShadowColor:[[UIColor blackColor] CGColor]];
        [_borderView.layer setShadowOpacity:0.2];
        [_borderView.layer setShadowRadius:10.0];
        [_borderView.layer setShadowOffset:CGSizeMake(5.0, 0.0)];
    }
    return self;
}

+ (BOOL)wantsDefaultContentAppearance
{
    return NO;
}

+ (CGFloat)arrowBase
{
    return kSPopoverBackgroundViewArrowBase;
}

+ (CGFloat)arrowHeight
{
    return kSPopoverBackgroundViewArrowHeight;
}

+ (UIEdgeInsets)contentViewInsets
{
    return kSPopoverBackgroundViewBorderContentInsets;
}

- (void)setArrowOffset:(CGFloat)arrowOffset
{
    _arrowOffset = arrowOffset;
    [self setNeedsLayout];
}

- (void)setArrowDirection:(UIPopoverArrowDirection)arrowDirection
{
    _arrowDirection = arrowDirection;
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
//  [super layoutSubviews];

    //  Custom border view's shadow.
    [_borderView.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [_borderView.layer setShadowOpacity:0.2];
    [_borderView.layer setShadowRadius:6.0];
    [_borderView.layer setShadowOffset:CGSizeMake(0.0, 3.0)];
    
    CGFloat popoverWidth = self.frame.size.width;
    CGFloat popoverHeight = self.frame.size.height;
    switch (self.arrowDirection) {
        case UIPopoverArrowDirectionUp:
            self.arrowView.frame = CGRectIntegral(CGRectMake(popoverWidth / 2 + self.arrowOffset - kSPopoverBackgroundViewArrowBase / 2, kSPopoverBackgroundViewArrowVerticalOffset, kSPopoverBackgroundViewArrowBase, kSPopoverBackgroundViewArrowHeight));
            self.borderView.frame = CGRectIntegral(CGRectMake(0, kSPopoverBackgroundViewArrowHeight - kSPopoverBackgroundViewBorderVerticalOffset, popoverWidth, popoverHeight - (kSPopoverBackgroundViewArrowHeight - kSPopoverBackgroundViewBorderVerticalOffset)));
            break;
        case UIPopoverArrowDirectionDown:
            [self.arrowView setTransform:CGAffineTransformMakeRotation(M_PI)];
            self.arrowView.frame = CGRectIntegral(CGRectMake(popoverWidth / 2 + self.arrowOffset - kSPopoverBackgroundViewArrowBase / 2, popoverHeight - kSPopoverBackgroundViewArrowHeight - kSPopoverBackgroundViewArrowVerticalOffset, kSPopoverBackgroundViewArrowBase, kSPopoverBackgroundViewArrowHeight));
            self.borderView.frame = CGRectIntegral(CGRectMake(0, 0, popoverWidth, popoverHeight - (kSPopoverBackgroundViewArrowHeight - kSPopoverBackgroundViewBorderVerticalOffset)));
            break;
        case UIPopoverArrowDirectionLeft:
            [self.arrowView setTransform:CGAffineTransformMakeRotation(-M_PI / 2)];
            self.arrowView.frame = CGRectIntegral(CGRectMake(kSPopoverBackgroundViewArrowVerticalOffset, popoverHeight / 2 + self.arrowOffset - kSPopoverBackgroundViewArrowBase / 2, kSPopoverBackgroundViewArrowHeight, kSPopoverBackgroundViewArrowBase));
            self.borderView.frame = CGRectIntegral(CGRectMake(0, 0, popoverWidth - (kSPopoverBackgroundViewArrowHeight + kSPopoverBackgroundViewBorderVerticalOffset), popoverHeight));
            break;
        case UIPopoverArrowDirectionRight:
            [self.arrowView setTransform:CGAffineTransformMakeRotation(-M_PI / 2)];
            self.arrowView.frame = CGRectIntegral(CGRectMake(popoverWidth - kSPopoverBackgroundViewArrowHeight - kSPopoverBackgroundViewArrowVerticalOffset, popoverHeight / 2 + self.arrowOffset - kSPopoverBackgroundViewArrowBase / 2, kSPopoverBackgroundViewArrowHeight, kSPopoverBackgroundViewArrowBase));
            self.borderView.frame = CGRectIntegral(CGRectMake(0, 0, popoverWidth - (kSPopoverBackgroundViewArrowHeight + kSPopoverBackgroundViewBorderVerticalOffset), popoverHeight));
            break;
        default:
            break;
    }
}

@end

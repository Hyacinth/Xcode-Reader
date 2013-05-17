//
//  SReaderBarPad.m
//  Xcode Reader
//
//  Created by Song Hui on 13-4-23.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import "SReaderBarPad.h"
#import "SDirectionPanGestureRecognizer.h"

const CGFloat kSReaderBarPadButtonInteval = 60.0;
const CGFloat kSReaderBarPadLabelMaximumWidth = 358.0;
const CGFloat kSReaderBarPadHorizontalOffSet = 25.0;

@interface SReaderBarPad ()

//  The central label.
@property (nonatomic, strong) UILabel *centralLabel;

//  The central label's attributedText's attributes
@property (nonatomic, strong) NSDictionary *centralLabelAttributes;

@end

@implementation SReaderBarPad

#pragma mark - Life cycle and accessor methods

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _centralLabel = [[UILabel alloc] init];
        _centralLabel.backgroundColor = [UIColor clearColor];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        _centralLabelAttributes = @{ NSParagraphStyleAttributeName: paragraphStyle, NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0], NSForegroundColorAttributeName: [UIColor colorWithRed:0.29 green:0.29 blue:0.29 alpha:1.0] };
        [self addSubview:_centralLabel];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame backgroundImage:(UIImage *)backgroundImage shadowImage:(UIImage *)shadowImage {
    self = [self initWithFrame:frame];
    if (self) {
        [self setBackgroundImage:backgroundImage forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
        [self setShadowImage:shadowImage forToolbarPosition:UIToolbarPositionAny];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:title attributes:self.centralLabelAttributes];
    self.centralLabel.attributedText = attributedText;
    [self layoutLabel];
}

- (void)setLeftBarButtons:(NSArray *)leftBarButtons {
    for (UIButton *button in _leftBarButtons) {
        [button removeFromSuperview];
    }
    _leftBarButtons = leftBarButtons;
    for (UIButton *button in _leftBarButtons) {
        [self addSubview:button];
    }
}

- (void)setRightBarButtons:(NSArray *)rightBarButtons {
    for (UIButton *button in _rightBarButtons) {
        [button removeFromSuperview];
    }
    _rightBarButtons = rightBarButtons;
    for (UIButton *button in _rightBarButtons) {
        [self addSubview:button];
    }
}

#pragma mark - View hierachy and layout management

- (void)layoutLabel {
    CGSize barSize = self.frame.size;
    CGSize labelSizeToFit = [self.centralLabel sizeThatFits:CGSizeMake(kSReaderBarPadLabelMaximumWidth, 44.0)];
    CGFloat labelWidth = labelSizeToFit.width;
    CGFloat labelHeight = labelSizeToFit.height;
    self.centralLabel.frame = CGRectIntegral(CGRectMake((barSize.width - labelWidth) / 2, (barSize.height - labelHeight) / 2, labelWidth, labelHeight));
}

- (void)layoutButtons {
    //  Layout left and right buttons and calculate the button's image edge insets
    CGSize barSize = self.frame.size;
    CGFloat horizontalOffSet = kSReaderBarPadHorizontalOffSet;
    for (UIButton *button in self.leftBarButtons) {
        CGFloat buttonWidth = button.frame.size.width;
        CGFloat buttonHeight = button.frame.size.height;
        button.frame = CGRectIntegral(CGRectMake((kSReaderBarPadButtonInteval - buttonWidth) / 2 + horizontalOffSet, (barSize.height - buttonHeight) / 2, buttonWidth, buttonHeight));
        CGFloat imageWidth = button.imageView.image.size.width;
        CGFloat imageHeight = button.imageView.image.size.height;
        CGFloat topEdgeInset = floorf((buttonHeight - imageHeight) / 2);
        CGFloat leftEdgeInset = floorf((buttonWidth - imageWidth) / 2);
        CGFloat bottomEdgeInset = ceilf((buttonHeight - imageHeight) / 2);
        CGFloat rightEdgeInset = ceilf((buttonWidth - imageWidth) / 2);
        button.imageEdgeInsets = UIEdgeInsetsMake(topEdgeInset, leftEdgeInset, bottomEdgeInset, rightEdgeInset);
        horizontalOffSet += kSReaderBarPadButtonInteval;
    }
    horizontalOffSet = kSReaderBarPadHorizontalOffSet + kSReaderBarPadButtonInteval;
    for (UIButton *button in self.rightBarButtons) {
        CGFloat buttonWidth = button.frame.size.width;
        CGFloat buttonHeight = button.frame.size.height;
        button.frame = CGRectIntegral(CGRectMake((kSReaderBarPadButtonInteval - buttonWidth) / 2 + barSize.width - horizontalOffSet, (barSize.height - buttonHeight) / 2, buttonWidth, buttonHeight));
        CGFloat imageWidth = button.imageView.image.size.width;
        CGFloat imageHeight = button.imageView.image.size.height;
        CGFloat topEdgeInset = floorf((buttonHeight - imageHeight) / 2);
        CGFloat leftEdgeInset = floorf((buttonWidth - imageWidth) / 2);
        CGFloat bottomEdgeInset = ceilf((buttonHeight - imageHeight) / 2);
        CGFloat rightEdgeInset = ceilf((buttonWidth - imageWidth) / 2);
        button.imageEdgeInsets = UIEdgeInsetsMake(topEdgeInset, leftEdgeInset, bottomEdgeInset, rightEdgeInset);
        horizontalOffSet += kSReaderBarPadButtonInteval;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutLabel];
    [self layoutButtons];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[SDirectionPanGestureRecognizer class]]) {
        return NO;
    }
    return YES;
}

@end

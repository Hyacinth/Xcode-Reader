//
//  SToolkitBar.h
//  Xcode Reader
//
//  Created by Song Hui 2013-4-11
//  Copyright(C)Song Hui. All rights reserved.

#import "SToolkitBar.h"
#import "STabControl.h"

@implementation SToolkitBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame barItems:(NSArray *)barItems backgroundImage:(UIImage *)backgroundImage shadowImage:(UIImage *)shadowImage
{
    self = [self initWithFrame:frame];
    if (self) {
        self.barItems = barItems;
        [self setBackgroundImage:backgroundImage forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
//      [self setBackgroundImage:backgroundImage forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsLandscapePhone];
        [self setShadowImage:shadowImage forToolbarPosition:UIToolbarPositionAny];
//      [self setShadowImage:shadowImage forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsLandscapePhone];
        self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
    }
    return self;
}

- (void)setBarItems:(NSArray *)barItems
{
    for (id barItem in _barItems) {
        [barItem removeFromSuperview];
    }
    _barItems = barItems;
    for (id barItem in self.barItems) {
        if ([barItem isKindOfClass:[STabControl class]]) {
            [self addSubview:barItem];
        }   else if ([barItem isKindOfClass:[UIButton class]]) {
            [self addSubview:barItem];
        }   else {
            NSLog(@"SToolkitBar: Unacceptable Bar Item Type.");
        }
    }
}

@end
// 
//  STabControl.m
//  Xcode Reader
//  
//  Created by Song Hui 2013-4-15
//  Copyright(C)Song Hui. All rights reserved.


#import "STabControl.h"

const NSInteger kSTabControlAffectiveTouchWidth = 44;

@implementation STabControl

- (id)initWithFrame:(CGRect)frame tabImages:(NSArray *)tabImages tabSelectedImages:(NSArray *)tabSelectedImages
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _tabImages = tabImages;
        _tabSelectedImages = tabSelectedImages;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)superview
{
    [super willMoveToSuperview:superview];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (self.tabImages.count == 0) {
            NSLog(@"STabControl: Tab images empty.");
            return;
        }
        if (self.tabImages.count != self.tabSelectedImages.count) {
            NSLog(@"STabControl: Tab images' count and selected images' count not match.");
            return;
        }
        NSInteger tabWidth = kSTabControlAffectiveTouchWidth;
        NSInteger tabHeight = self.frame.size.height;
        CGFloat horizontalOffset = self.frame.size.width / self.tabImages.count;
        CGFloat x = (horizontalOffset - tabWidth) / 2;
        NSMutableArray *tabs = [[NSMutableArray alloc] initWithCapacity:self.tabImages.count];
        for (NSInteger i = 0; i < self.tabImages.count; i++) {
            UIButton *tab = [[UIButton alloc] initWithFrame:CGRectIntegral(CGRectMake(x, 0, tabWidth, tabHeight))];
            [tab setImage:self.tabImages[i] forState:UIControlStateNormal];
            [tab setImage:self.tabSelectedImages[i] forState:UIControlStateSelected];
            [tab addTarget:self action:@selector(tabTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];

            //  Calculate tab's image edge insets.
            UIImage *tabImage = self.tabImages[i];
            CGSize tabImageSize = tabImage.size;
            NSInteger topEdgeInset = floor((tabHeight - tabImageSize.height) / 2);
            NSInteger leftEdgeInset = floor((tabWidth - tabImageSize.width) / 2);
            NSInteger bottomEdgeInset = ceil((tabHeight - tabImageSize.height) / 2);
            NSInteger rightEdgeInset = ceil((tabWidth - tabImageSize.width) / 2);
            tab.imageEdgeInsets = UIEdgeInsetsMake(topEdgeInset, leftEdgeInset, bottomEdgeInset, rightEdgeInset);

            [self addSubview:tab];
            [tabs addObject:tab];
            x += horizontalOffset;
        }
        self.tabs = tabs;
        [self selectTab:self.tabs[0] animated:NO];
    });
}

- (void)selectTab:(UIButton *)selectedTab animated:(BOOL)animated
{
    for (UIButton *tab in self.tabs) {
        if (selectedTab == tab) {
            tab.selected = YES;
            self.selectedIndex = [self.tabs indexOfObject:tab];
        } else {
            tab.selected = NO;
        }
    }
}

- (void)tabTouchUpInside:(UIButton *)tab
{
    [self selectTab:tab animated:NO];
    [self.delegate tabControl:self didSelectTabAtIndex:self.selectedIndex];
}

@end
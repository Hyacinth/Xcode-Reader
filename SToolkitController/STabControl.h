// 
//  STabControl.h
//  Xcode Reader
//  
//  Created by Song Hui 2013-4-15
//  Copyright(C)Song Hui. All rights reserved.

#import <UIKit/UIKit.h>

@class STabControl;

@protocol STabControlDelegate<NSObject>

- (void)tabControl:(STabControl *)tabControl didSelectTabAtIndex:(NSInteger)index;

@end

@interface STabControl : UIView

//  Tab images for normal/ unselected state.
@property (nonatomic, strong) NSArray *tabImages;

//  Tab images for selected state.
//  Selected images' size should be the same with normal/ unselected images' respectively.
@property (nonatomic, strong) NSArray *tabSelectedImages;

//  All tabs STabControl owned from left to right order.
@property (nonatomic, strong) NSArray *tabs;

//  Selected index.
@property (nonatomic, assign) NSInteger selectedIndex;

//  Control's delegate.
@property (nonatomic, weak) id<STabControlDelegate> delegate;

//  Designated Initializer
- (id)initWithFrame:(CGRect)frame tabImages:(NSArray *)tabImages tabSelectedImages:(NSArray *)tabSelectedImages;

@end



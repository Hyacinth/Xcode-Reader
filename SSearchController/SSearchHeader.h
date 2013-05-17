//
//  SSearchHeader.h
//  Xcode Reader
//
//  Created by Song Hui on 13-5-14.
//  Copyright (c) 2013年 Code Bone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface SSearchHeader : UITableViewHeaderFooterView

@property (nonatomic, copy) NSString *headerTitle;

@property (nonatomic, strong) UILabel *headerLabel;

@end

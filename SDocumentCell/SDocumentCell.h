//
//  SDocumentCell.h
//  Xcode Reader
//
//  Created by Song Hui on 13-5-13.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SDocumentTagView.h"
#import "SDocumentTag.h"
#import "SDocumentCellData.h"
#import "SNode.h"
#import "SToken.h"

//@class SDocumentCellData;

@interface SDocumentCell : UITableViewCell

// Main label.
@property (nonatomic, strong) UILabel *main;

// Tag view
@property (nonatomic, strong) SDocumentTagView *tagView;

// Description label.
@property (nonatomic, strong) UILabel *description;

// Image Icon
@property (nonatomic, strong) UIImageView *icon;

// Cell's data
@property (nonatomic, strong) SDocumentCellData *data;

// UITableViewDelegate has a method tableView:didEndDisplayingCell:forRowAtIndexPath:.
// Call below method in this delegate method to reset cell.
- (void)didEndDiplayedByTableView;

// Compose cell's data with given SToken.
- (SDocumentCellData *)dataForCellWithToken:(SToken *)token;

// Compose cell's data with given SNode.
- (SDocumentCellData *)dataForCellWithNode:(SNode *)node;

@end

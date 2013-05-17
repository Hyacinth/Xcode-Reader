//
//  SSearchController.h
//  Xcode Reader
//
//  Created by Song Hui on 13-5-14.
//  Copyright (c) 2013年 Code Bone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSearchManager.h"

@interface SSearchController : UIViewController<UISearchBarDelegate, UITableViewDataSource,  UITableViewDelegate, SSearchManagerDelegate>

// Search bar.
@property (strong, nonatomic) UISearchBar *searchbar;

// Search bar will be located on this bar.
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

// Table view.
@property (weak, nonatomic) IBOutlet UITableView *tableView;

// Model: nodes.
@property (strong, nonatomic) NSArray *nodes;

// Model: tokens.
@property (strong, nonatomic) NSArray *tokens;

// Model: cell data for nodes.
@property (strong, nonatomic) NSArray *dataForNodes;

// Model: cell data for tokens.
@property (strong, nonatomic) NSArray *dataForTokens;

@end

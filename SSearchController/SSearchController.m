//
//  SSearchController.m
//  Xcode Reader
//
//  Created by Song Hui on 13-5-14.
//  Copyright (c) 2013年 Code Bone. All rights reserved.
//

#import "SSearchController.h"
#import "SDocumentCell.h"
#import "SSearchHeader.h"

const UIEdgeInsets kSearchFieldImageInsets = {9.0, 9.0, 10.0, 9.0};

NSString *const kSearchControllerCellReuseIdentifier = @"Search Controller Cell Identifier";
NSString *const kSearchControllerHeaderReuseIdentifier = @"Search Controller Header Identifier";

@interface SSearchController ()

@end

@implementation SSearchController

#pragma mark - Life Cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {		
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	// Toolbar
	UIImage *toolbarBackgroundImage = [[UIImage imageNamed:@"Navigation-Background.png"] resizableImageWithCapInsets:UIEdgeInsetsZero];
	UIImage *toolbarShadowImage = [[UIImage imageNamed:@"Navigation-Shadow.png"] resizableImageWithCapInsets:UIEdgeInsetsZero];
	[self.toolbar setBackgroundImage:toolbarBackgroundImage
				  forToolbarPosition:UIToolbarPositionAny
						  barMetrics:UIBarMetricsDefault];
	[self.toolbar setShadowImage:toolbarShadowImage
			  forToolbarPosition:UIToolbarPositionAny];

	// Searchbar
	self.searchbar = [[UISearchBar alloc] initWithFrame:CGRectMake(5.0, 0.0, 310.0, 44.0)];
	self.searchbar.autocorrectionType = UITextAutocorrectionTypeNo;
	self.searchbar.showsCancelButton = YES;
	self.searchbar.spellCheckingType = UITextSpellCheckingTypeNo;
	[self.searchbar setImage:[UIImage imageNamed:@"SearchBarIcon-Search.png"]
			forSearchBarIcon:UISearchBarIconSearch
					   state:UIControlStateNormal];
	[self.searchbar setImage:[UIImage imageNamed:@"SearchBarIcon-Clear.png"]
			forSearchBarIcon:UISearchBarIconClear
					   state:UIControlStateNormal];
	[self.searchbar setSearchFieldBackgroundImage:[[UIImage imageNamed:@"SearchField.png"] resizableImageWithCapInsets:kSearchFieldImageInsets]
										 forState:UIControlStateNormal];
	self.searchbar.backgroundImage = nil;
	self.searchbar.backgroundColor = [UIColor clearColor];
	for (UIView *subview in self.searchbar.subviews) {
		if ([subview isKindOfClass:[UITextField class]]) {
			[(UITextField *)subview setTextColor:[UIColor colorWithRed:0.68 green:0.68 blue:0.68 alpha:1.0]];
			break;
		}
	}

	[self.toolbar addSubview:self.searchbar];

	self.searchbar.delegate = self;
	self.tableView.delegate = self;
	self.tableView.dataSource = self;


	[self.tableView registerClass:[SDocumentCell class] forCellReuseIdentifier:kSearchControllerCellReuseIdentifier];
	[self.tableView registerClass:[SSearchHeader class] forHeaderFooterViewReuseIdentifier:kSearchControllerHeaderReuseIdentifier];
}

- (void)viewWillAppear:(BOOL)animated
{
	[self.tableView flashScrollIndicators];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Searchbar delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	[[SSearchManager share] searchWithSearchString:searchText delegate:self];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
	[[SSearchManager share] prepareSearch];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
	[self.searchbar resignFirstResponder];
}

#pragma mark - SSearchManager delegate

- (void)searchManager:(SSearchManager *)searchManager didFinishSearchWithSearchResult:(NSDictionary *)searchResult
{
	self.nodes = searchResult[kSearchManagerNodeResultsKey];
	self.dataForNodes = searchResult[kSearchManagerCellDatasForNodeKey];
	self.tokens = searchResult[kSearchManagerTokenResultsKey];
	self.dataForTokens = searchResult[kSearchManagerCellDatasForTokenKey];

	[self.tableView reloadData];
}

#pragma mark - Tableview delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	if (self.nodes.count == 0 && self.tokens.count == 0) {
		return 0;
	}	else if (self.nodes.count != 0 && self.tokens.count == 0) {
		return 1;
	}	else if (self.nodes.count == 0 && self.tokens.count != 0) {
		return 1;
	}	else {
		return 2;
	}
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (self.nodes.count == 0 && self.tokens.count == 0) {
		return 0;
	}	else if (self.nodes.count != 0 && self.tokens.count == 0) {
		return self.nodes.count;
	}	else if (self.nodes.count == 0 && self.tokens.count != 0) {
		return self.tokens.count;
	}	else {
		if (section == 0) {
			return self.nodes.count;
		}	else if (section == 1) {
			return self.tokens.count;
		}
	}
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	SDocumentCellData *data = [self dataAtIndexPath:indexPath];
	if (data) {
		return data.cellHeight;
	}	else {
		// FIXEME: If data == nil, return 0.0 is not wise.
		return 44.0;
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	SSearchHeader *header = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:kSearchControllerHeaderReuseIdentifier];
	if (self.nodes.count == 0 && self.tokens.count == 0) {
		header = nil;
	}	else if (self.nodes.count != 0 && self.tokens.count == 0) {
		[header setHeaderTitle:@"Guide"];
	}	else if (self.nodes.count == 0 && self.tokens.count != 0) {
		[header setHeaderTitle:@"Reference"];
	}	else {
		if (section == 0) {
			[header setHeaderTitle:@"Guide"];
		}	else if (section == 1) {
			[header setHeaderTitle:@"Reference"];
		}
	}
	return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	SDocumentCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kSearchControllerCellReuseIdentifier
															   forIndexPath:indexPath];
	SDocumentCellData *data = [self dataAtIndexPath:indexPath];
	[cell setData:data];

	return cell;
}

- (SDocumentCellData *)dataAtIndexPath:(NSIndexPath *)indexPath
{
	SDocumentCellData *data = nil;
	if (self.nodes.count == 0 && self.tokens.count == 0) {
	}	else if (self.nodes.count != 0 && self.tokens.count == 0) {
		return self.dataForNodes[indexPath.row];
	}	else if (self.nodes.count == 0 && self.tokens.count != 0) {
		return self.dataForTokens[indexPath.row];
	}	else {
		if (indexPath.section == 0) {
			return self.dataForNodes[indexPath.row];
		}	else if (indexPath.section == 1) {
			return self.dataForTokens[indexPath.row];
		}
	}
	return data;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//	[(SDocumentCell *)cell didEndDiplayedByTableView];
}

@end

//
//  SToolkitBar.h
//  Xcode Reader
//
//  Created by Song Hui 2013-4-11
//  Copyright(C)Song Hui. All rights reserved.
 
#import <UIKit/UIKit.h>
 
@interface SToolkitBar : UIToolbar
 
//  SToolkitBar can have STabControl and UIButton as its items.
//  Before assignment, please ensure each item has correct frame and UIViewAutoResizingMask, so SToolkitBar can layout all items appropriately when device rotate and any other reason causing SToolkitBar's geometry change.
//  FUTURE UPDATE: When UIViewAutoResizingMask cannot achieve the intended layout request. Update maybe require.
@property (nonatomic, strong) NSArray *barItems;
 
//  Designated Initializer is still initWithFrame:. This is just a continent initial method.
- (id)initWithFrame:(CGRect)frame barItems:(NSArray *)barItems backgroundImage:(UIImage *)backgroundImage shadowImage:(UIImage *)shadowImage;

@end
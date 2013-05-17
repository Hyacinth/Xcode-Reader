//
//  SToolkitcontroller.h
//  Xcode Reader
//
//  Created by Song Hui 2013-4-11
//  Copyright(C)Song Hui. All rights reserved.

#import <UIKit/UIKit.h>
#import "STabControl.h"
#import "SToolkitBar.h"

@interface SToolkitController : UIViewController<STabControlDelegate>

UIKIT_EXTERN const CGFloat kSToolkitControllerWidth;

//  Controller's root superview.
//  Be responsible for displaying a shadow effect at controller's right border.
@property (nonatomic, strong) UIView *containerView;

//  The superview for all children view controller.
@property (nonatomic, strong) UIView *viewControllerTransitionView;

//  SToolkitController's children view controller.
@property (nonatomic, strong) NSArray *viewControllers;

//  The current selected/ on screen child controller.
@property (nonatomic, strong) UIViewController *selectedViewController;

//  Self explained.
@property (nonatomic, assign) NSInteger selectedIndex;

//  The main function bar of SToolkitController, controller use it to switch its children controllers.
//  ToolkitBar is a hybrid of UITabbar and Standard UIToolbar.
//  It has a STabControl to achieve the tab switch ability, along with that, it also has a setting button.
//  Because UIToolbar already can put STabControl and UIButton on itself, toolkitBar will be UIToolbar for now.
//  Subclass of UIToolbar may be required in later progress of Xcode Reader Project.
@property (nonatomic, strong) SToolkitBar *toolkitBar;

//  Tab control located on toolkitBar. Controller use it to switch its children controllers.
@property (nonatomic, strong) STabControl *tabControl;

//  Toolkit Bar items will determine what's currently displayed on Toolkit Bar.
@property (nonatomic, strong) NSArray *barItems;

//  The root/ default Toolkit bar items.
@property (nonatomic, strong) NSArray *defautBarItems;

- (id)initWithViewControllers:(NSArray *)viewControllers selectedIndex:(NSInteger)selectedIndex;

@end

@interface UIViewController (SToolkitController)

//  If view controller has a SToolkitController as its ancestor, return it. Otherwise, return nil.
//  Child view controller of SToolkitController that want to quick access SToolkitController can write an getter method in its implementation.
@property (nonatomic, readonly, weak) UIViewController *toolkitController;

//  Child view controller of SToolkitController can override this property's setter method in order to change the Bar items display on its parent' Toolkit Bar.
//  The override of setter method only require assign the SToolkitBarItems intended to be displayed on ToolkitBar, SToolkitController will notice the change and update the bar appropriately.
//  NOTICE: If not being a child of SToolkitController, don't implement this property.
@property (nonatomic, readwrite, weak) NSArray *toolkitBarItems;

@end



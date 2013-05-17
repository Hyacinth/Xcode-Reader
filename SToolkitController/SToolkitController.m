//
//  SToolkitcontroller.m
//  Xcode Reader
//
//  Created by Song Hui 2013-4-11
//  Copyright(C)Song Hui. All rights reserved.

#import "SToolkitController.h"

const CGFloat kSToolkitControllerWidth = 320.0;
const CGFloat kSToolkitBarHeight = 44.0;
const UIEdgeInsets kSToolkitBarBackgroundImageCapInsets = {1.0, 1.0, 1.0, 1.0};
const UIEdgeInsets kSToolkitBarShadowImageCapInsets = {0, 0, 0, 0};
const UIEdgeInsets kSToolkitBarSettingButtonImageCapInsets = {7.0, 7.0, 8.0, 7.0};
const UIEdgeInsets kSToolkitBarSettingImageInsets = {3, 4, 4, 3};
const CGRect kSTabControlFrame = {{40, 0}, {180, 44}};
const CGRect kSSettingButtonFrame = {{277, 5}, {33, 34}};
NSString* const kSToolkitBarBackgroundImageName = @"ToolkitBar-Background.png";
NSString* const kSToolkitBarShadowImageName = @"ToolkitBar-Shadow.png";
NSString* const kSTabControlSearchImageName = @"TabControl-Search.png";
NSString* const kSTabControlExploreImageName = @"TabControl-Explore.png";
NSString* const kSTabControlBookmarkImageName = @"TabControl-Bookmark.png";
NSString* const kSTabControlSearchSelectedImageName = @"TabControl-Search-Selected.png";
NSString* const kSTabControlExploreSelectedImageName = @"TabControl-Explore-Selected.png";
NSString* const kSTabControlBookmarkSelectedImageName = @"TabControl-Bookmark-Selected.png";
NSString* const kSToolkitBarSettingImageName = @"ToolkitBar-Setting.png";
NSString* const kSToolkitBarSettingButtonImageName = @"ToolkitBar-SettingButton.png";
NSString* const kSToolkitBarSettingButtonSelectedImageName = @"ToolkitBar-SettingButton-Selected.png";

typedef NS_ENUM(NSInteger, SToolkitTransitionAnimation) {
    SToolkitTransitionAnimationNone,
    SToolkitTransitionAnimationPlaceholder1,
    SToolkitTransitionAnimationPlaceholder2
};

@interface SToolkitController()

//  Child view controller's transition will be added to this queue. And execute FIFO.
@property (nonatomic, strong) NSMutableArray *transitionQueue;

@end

@implementation SToolkitController

#pragma mark - Life Cycle

- (id)initWithViewControllers:(NSArray *)viewControllers selectedIndex:(NSInteger)selectedIndex
{
    self = [super init];
    if (self) {
        _viewControllers = viewControllers;
        _selectedIndex = selectedIndex;
        _transitionQueue = [[NSMutableArray alloc] init];

        //  Default Bar Items Creation
        UIImage *tabControlSearchImage = [UIImage imageNamed:kSTabControlSearchImageName];
        UIImage *tabControlExploreImage = [UIImage imageNamed:kSTabControlExploreImageName];
        UIImage *tabControlBookmarkImage = [UIImage imageNamed:kSTabControlBookmarkImageName];
        UIImage *tabControlSearchSelectedImage = [UIImage imageNamed:kSTabControlSearchSelectedImageName];
        UIImage *tabControlExploreSelectedImage = [UIImage imageNamed:kSTabControlExploreSelectedImageName];
        UIImage *tabControlBookmarkSelectedImage = [UIImage imageNamed:kSTabControlBookmarkSelectedImageName];
        STabControl *tabControl = [[STabControl alloc] initWithFrame:kSTabControlFrame tabImages:@[tabControlSearchImage, tabControlExploreImage, tabControlBookmarkImage] tabSelectedImages:@[tabControlSearchSelectedImage, tabControlExploreSelectedImage, tabControlBookmarkSelectedImage]];
        tabControl.delegate = self;
        UIButton *settingButton = [[UIButton alloc] initWithFrame:kSSettingButtonFrame];
        UIImage *settingImage = [UIImage imageNamed:kSToolkitBarSettingImageName];
        UIImage *settingButtonImage = [[UIImage imageNamed:kSToolkitBarSettingButtonImageName] resizableImageWithCapInsets:kSToolkitBarSettingButtonImageCapInsets];
        UIImage *settingButtonSelectedImage = [[UIImage imageNamed:kSToolkitBarSettingButtonSelectedImageName] resizableImageWithCapInsets:kSToolkitBarSettingButtonImageCapInsets];
        settingButton.imageEdgeInsets = kSToolkitBarSettingImageInsets;
        [settingButton setImage:settingImage forState:UIControlStateNormal];
        [settingButton setBackgroundImage:settingButtonImage forState:UIControlStateNormal];
        [settingButton setBackgroundImage:settingButtonSelectedImage forState:UIControlStateHighlighted | UIControlStateSelected];
        [settingButton addTarget:self action:@selector(settingButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        NSArray *defaultBarItems = @[tabControl, settingButton];
        _defautBarItems = defaultBarItems;
        _barItems = defaultBarItems;
    }
    return self;
}

- (void)loadView
{
    CGSize applicationSize = [[UIScreen mainScreen] applicationFrame].size;
    CGFloat applicationHeight = applicationSize.height;
    if (UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        applicationHeight = applicationSize.width;
    }

    //  Alloc and init views
    _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSToolkitControllerWidth, applicationHeight)];
    _viewControllerTransitionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSToolkitControllerWidth, applicationHeight - kSToolkitBarHeight)];
    UIImage *toolkitBarBackgroundImage = [[UIImage imageNamed:kSToolkitBarBackgroundImageName] resizableImageWithCapInsets:kSToolkitBarBackgroundImageCapInsets];
    UIImage *toolkitBarShadowImage = [[UIImage imageNamed:kSToolkitBarShadowImageName] resizableImageWithCapInsets:kSToolkitBarShadowImageCapInsets];
    _toolkitBar = [[SToolkitBar alloc] initWithFrame:CGRectMake(0, applicationHeight - kSToolkitBarHeight, kSToolkitControllerWidth, kSToolkitBarHeight) barItems:self.barItems backgroundImage:toolkitBarBackgroundImage shadowImage:toolkitBarShadowImage];
    
    //  Views's autoresizingMask configuration.
    _containerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    _viewControllerTransitionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    _toolkitBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;

    //  View Hierachy.
    self.view = _containerView;
    [_containerView addSubview:_viewControllerTransitionView];
    [_containerView addSubview:_toolkitBar];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Children view controllers' toolkitBatItem observing.
    for (UIViewController *viewController in self.viewControllers) {
        [viewController addObserver:self forKeyPath:@"toolkitBatItems" options:NSKeyValueObservingOptionNew context:nil];
    }

	// Select selected controller.
	[self selectViewControllerAtIndex:self.selectedIndex animationType:SToolkitTransitionAnimationNone];
}

#pragma mark - Children View Controllers Management and Transition

- (void)selectViewControllerAtIndex:(NSInteger)selectedIndex animationType:(SToolkitTransitionAnimation)animationType
{
    if (!self.selectedViewController || self.selectedIndex != selectedIndex) {
        NSArray *transition = @[[NSNumber numberWithInteger:self.selectedIndex], [NSNumber numberWithInteger:selectedIndex]];
        //  Add transition to transition queue.
        if (self.transitionQueue.count == 0) {
            [self.transitionQueue addObject:transition];
            //  Only immediately start transition if queue is empty.
            [self executeTransitionWithAnimationType:animationType];
        }   else {
            [self.transitionQueue addObject:transition];
        }
    }
}

- (void)executeTransitionWithAnimationType:(SToolkitTransitionAnimation)animationType
{
    NSArray *transition = self.transitionQueue[0];
    NSInteger fromIndex = [transition[0] integerValue];
    NSInteger toIndex = [transition[1] integerValue];
    UIViewController *fromController = self.viewControllers[fromIndex];
    UIViewController *toController = self.viewControllers[toIndex];
    if (animationType == SToolkitTransitionAnimationNone) {
        toController.view.frame = CGRectMake(0, 0, self.viewControllerTransitionView.bounds.size.width, self.viewControllerTransitionView.bounds.size.height);
        if (self.selectedViewController && self.selectedViewController == fromController) {
            [self.selectedViewController removeFromParentViewController];
            [self.selectedViewController beginAppearanceTransition:NO animated:NO];
            [self.selectedViewController.view removeFromSuperview];
            [self.selectedViewController endAppearanceTransition];
        }
        [self addChildViewController:toController];
        [toController beginAppearanceTransition:YES animated:NO];
        [self.viewControllerTransitionView addSubview:toController.view];
        [toController endAppearanceTransition];
    }   else if (animationType == SToolkitTransitionAnimationPlaceholder1) {
    }
    self.selectedIndex = toIndex;
    self.selectedViewController = toController;
    
    //  Queue out transition and execute next one if there is.
    [self.transitionQueue removeObject:transition];
    if (self.transitionQueue.count != 0) {
        [self executeTransitionWithAnimationType:SToolkitTransitionAnimationNone];
    }
}

- (void)tabControl:(STabControl *)tabControl didSelectTabAtIndex:(NSInteger)index
{
    [self selectViewControllerAtIndex:index animationType:SToolkitTransitionAnimationNone];
}

#pragma mark - Toolkit Bar Items Update

- (void)observeForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"toolkitBarItems"] && object == self.selectedViewController) {
        self.barItems = self.selectedViewController.toolkitBarItems;
        self.toolkitBar.barItems = self.barItems;
    }
}

#pragma mark - Setting

- (void)settingButtonTouchUpInside:(UIButton *)settingButton
{
    
}

@end
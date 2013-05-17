//
//  SReaderController.m
//  Xcode Reader
//
//  Created by Song Hui on 13-4-23.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import "SReaderController.h"
#import "SPopoverBackgroundView.h"

const UIEdgeInsets kSReaderBarBackgroundImageCapInsets = {0.0, 0.0, 0.0, 0.0};
const UIEdgeInsets kSReaderBarShadowImageCapInsets = {0.0, 25.0, 0.0, 25.0};
const CGRect kSReaderBarPadButtonFrame = {{0.0, 0.0}, {44.0, 44.0}};
NSString *const kSReaderBarBackgroundImageName = @"ReaderBar-Background.png";
NSString *const kSReaderBarShadowImageName = @"ReaderBar-Shadow.png";
NSString *const kSReaderBarDeveloperImageName = @"ReaderBar-Developer.png";
NSString *const kSReaderBarBackImageName = @"ReaderBar-Back.png";
NSString *const kSReaderBarForwardImageName = @"ReaderBar-Forward.png";
NSString *const kSReaderBarFontImageNmae = @"ReaderBar-Font.png";
NSString *const kSReaderBarBookmarkImageName = @"ReaderBar-Bookmark.png";
NSString *const kSReaderBarOutlineImageName = @"ReaderBar-Outline.png";

@interface SReaderController ()

@property (nonatomic, strong) UIButton *develperButton;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *forwardButton;
@property (nonatomic, strong) UIButton *fontButton;
@property (nonatomic, strong) UIButton *bookmarkButton;
@property (nonatomic, strong) UIButton *outlineButton;
//  Convenient property to store all buttons on reader bar, so it will be possible to set all buttons with little code.
@property (nonatomic, strong) NSArray *readerBarButtons;

@property (nonatomic, strong) UIPopoverController *outlinePopoverController;

@end

@implementation SReaderController

#pragma mark - Life Cycle

- (id)init
{
    self = [super init];
    if (self) {
        //  Reader bar pad's buttons creation.
        _develperButton = [[UIButton alloc] initWithFrame:kSReaderBarPadButtonFrame];
        _backButton = [[UIButton alloc] initWithFrame:kSReaderBarPadButtonFrame];
        _forwardButton = [[UIButton alloc] initWithFrame:kSReaderBarPadButtonFrame];
        _fontButton = [[UIButton alloc] initWithFrame:kSReaderBarPadButtonFrame];
        _bookmarkButton = [[UIButton alloc] initWithFrame:kSReaderBarPadButtonFrame];
        _outlineButton = [[UIButton alloc] initWithFrame:kSReaderBarPadButtonFrame];
        [_develperButton setImage:[UIImage imageNamed:kSReaderBarDeveloperImageName] forState:UIControlStateNormal];
        [_backButton setImage:[UIImage imageNamed:kSReaderBarBackImageName] forState:UIControlStateNormal];
        [_forwardButton setImage:[UIImage imageNamed:kSReaderBarForwardImageName] forState:UIControlStateNormal];
        [_fontButton setImage:[UIImage imageNamed:kSReaderBarFontImageNmae] forState:UIControlStateNormal];
        [_bookmarkButton setImage:[UIImage imageNamed:kSReaderBarBookmarkImageName] forState:UIControlStateNormal];
        [_outlineButton setImage:[UIImage imageNamed:kSReaderBarOutlineImageName] forState:UIControlStateNormal];
        _readerBarButtons = @[_develperButton, _backButton, _forwardButton, _fontButton, _bookmarkButton, _outlineButton];
    }
    return self;
}

- (void)loadView
{
    
    //  Create root view and readerBar.
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    self.view = [[UIView alloc] initWithFrame:applicationFrame];
    UIImage *readerBarBackgroundImage = [[UIImage imageNamed:kSReaderBarBackgroundImageName] resizableImageWithCapInsets:kSReaderBarBackgroundImageCapInsets];
    UIImage *readerBarShadowImage = [[UIImage imageNamed:kSReaderBarShadowImageName] resizableImageWithCapInsets:kSReaderBarShadowImageCapInsets];
    self.readerBarPad = [[SReaderBarPad alloc] initWithFrame:CGRectMake(0.0, 0.0, applicationFrame.size.width, 44.0) backgroundImage:readerBarBackgroundImage shadowImage:readerBarShadowImage];
    
    //  View hierachy.
    [self.readerBarPad setLeftBarButtons:@[self.develperButton, self.backButton, self.forwardButton]];
    [self.readerBarPad setRightBarButtons:@[self.outlineButton, self.bookmarkButton, self.fontButton]];
    [self.view addSubview:self.readerBarPad];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.0];
    for (UIButton *button in self.readerBarButtons) {
        button.adjustsImageWhenHighlighted = YES;
        button.showsTouchWhenHighlighted = YES;
    }

    //  Reader bar button's action and gesture attachment
    [self.develperButton addTarget:self action:@selector(developerButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.backButton addTarget:self action:@selector(backButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.forwardButton addTarget:self action:@selector(forwardButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.fontButton addTarget:self action:@selector(fontButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.bookmarkButton addTarget:self action:@selector(bookmarkButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.outlineButton addTarget:self action:@selector(outlineButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];

    // Reader bar's title
    self.readerBarPad.title = @"iOS Human Interface Guideline";
}

- (UIPopoverController *)outlinePopoverController
{
    if (!_outlinePopoverController) {
        UIViewController *viewController = [[UIViewController alloc] init];
        viewController.view.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.0];
        _outlinePopoverController = [[UIPopoverController alloc] initWithContentViewController:viewController];
        _outlinePopoverController.popoverContentSize = CGSizeMake(320.0, 400.0);
        _outlinePopoverController.popoverLayoutMargins = UIEdgeInsetsMake(44.0, 25.0, 44.0, 25.0);
        _outlinePopoverController.popoverBackgroundViewClass = [SPopoverBackgroundView class];
        _outlinePopoverController.delegate = self;
    }
    return _outlinePopoverController;
}

#pragma mark - ReaderBarPad Actions and Gesture Handler

- (void)developerButtonTouchUpInside:(UIButton *)button
{
    NSLog(@"Button been touched!");
}

- (void)backButtonTouchUpInside:(UIButton *)button
{
    NSLog(@"Button been touched!");
}

- (void)forwardButtonTouchUpInside:(UIButton *)button
{
    NSLog(@"Button been touched!");
}

- (void)fontButtonTouchUpInside:(UIButton *)button
{
    NSLog(@"Button been touched!");
}

- (void)bookmarkButtonTouchUpInside:(UIButton *)button
{
    NSLog(@"Button been touched!");
}

- (void)outlineButtonTouchUpInside:(UIButton *)button
{
    if (self.outlinePopoverController.popoverVisible) {
        [self.outlinePopoverController dismissPopoverAnimated:YES];
    }   else {
        CGRect outlineFrame = [self.view convertRect:self.outlineButton.frame fromView:self.readerBarPad];
        [self.outlinePopoverController presentPopoverFromRect:outlineFrame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

#pragma mark - Popover delegate.

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    if (popoverController == self.outlinePopoverController) {
    }
}
@end

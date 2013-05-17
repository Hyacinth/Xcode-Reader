#import "SRevealSideController.h"
#import "SDirectionPanGestureRecognizer.h"

const CGFloat kSRevealSideControllerSideControllerWidth = 320.0;
const CGFloat kSRevealSideControllerSideControllerShadowWidth = 25.0;
const CGFloat kSRevealSideControllerSideControllerDefiniteHideXPosition = -280.0;
const CGFloat kSRevealSideControllerRevealHideAnimationDuration = 0.5;
const CGFloat kSRevealSideControllerDimViewMaximumAlpha = 0.5;
const UIEdgeInsets kSRevealSideControllerSideControllerShadowImageEdgeInsets = {0, 0, 0, 0};
NSString* const kSRevealSideControllerSideControllerShadowImageName = @"SideController-Shadow.png";

NSString* const SRevealSideControllerWillRevealSideControllerNotification = @"SRevealSideControllerWillRevealSideControllerNotification";
NSString* const SRevealSideControllerDidRevealSideControllerNotification = @"SRevealSideControllerDidRevealSideControllerNotification";
NSString* const SRevealSideControllerWillHideSideControllerNotification = @"SRevealSideControllerWillHideSideControllerNotification";
NSString* const SRevealSideControllerDidHideSideControllerNotification = @"SRevealSideControllerDidHideSideControllerNotification";

typedef NS_ENUM(NSInteger, SRevealSideControllerSideControllerState) {
    SRevealSideControllerSideControllerStateHidden,
    SRevealSideControllerSideControllerStateRevealed,
    SRevealSideControllerSideControllerStateMovingFromRevealed,
    SRevealSideControllerSideControllerStateMovingFromHidden
};

@interface SRevealSideController()

//  Controller's root view.
@property (nonatomic, strong) UIView *containerView;

//  Wrapper superview for sideController's view and sideControllerShadowView;
@property (nonatomic, strong) UIView *sideControllerContainerView;

//  Custom view object to fake as a shadow of side controller.
@property (nonatomic, strong) UIView *sideControllerShadowView;

//  Custom view with black color background and alpha 0.0.
//  Positioned below sideControllerContainerView and above central controller's view.
//  Its size is application frame size, same as central controller.
//  And its alpha value will increase along with side controller revealing from left to right.
@property (nonatomic, strong) UIView *centralControllerDimView;

//  Horizontal pan gesture recognizer on containerView.         
@property (nonatomic, strong) SDirectionPanGestureRecognizer *horizontalPan;

// Side controller state
@property (nonatomic, assign) SRevealSideControllerSideControllerState sideControllerState;

@end

@implementation SRevealSideController

#pragma mark - Life Cycle

- (id)initWithSideController:(UIViewController *)sideController centralController:(UIViewController *)centralController
{
    self = [super init];
    if (self) {
        _sideController = sideController;
        _centralController = centralController;
    }
    return self;
}

- (void)loadView
{
    CGSize applicationSize = [[UIScreen mainScreen] applicationFrame].size;
    
    //  Alloc and create all views.
    _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, applicationSize.width, applicationSize.height)];
    _centralController.view.frame = _containerView.frame;
    _sideControllerContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSRevealSideControllerSideControllerWidth, applicationSize.height)];
    _sideController.view.frame = CGRectMake(0, 0, kSRevealSideControllerSideControllerWidth, applicationSize.height);
    //  Shadow view'frame is outside of side controller contrainer view's.
    _sideControllerShadowView = [[UIView alloc] initWithFrame:CGRectMake(kSRevealSideControllerSideControllerWidth, 0, kSRevealSideControllerSideControllerShadowWidth, applicationSize.height)]; 
    _centralControllerDimView = [[UIView alloc] initWithFrame:_containerView.frame];

    //  Setup view's attributes and contents.(Gesture recognizer, autoresizingMask... )
    _containerView.multipleTouchEnabled = YES;
    _sideControllerContainerView.opaque = YES;
    UIImage *shadowImage = [[UIImage imageNamed:kSRevealSideControllerSideControllerShadowImageName] resizableImageWithCapInsets:kSRevealSideControllerSideControllerShadowImageEdgeInsets];
    _sideControllerShadowView.layer.contents = (__bridge id)([shadowImage CGImage]);
    _sideControllerShadowView.alpha = 1.0;
    _centralControllerDimView.backgroundColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1.0];
    _centralControllerDimView.alpha = kSRevealSideControllerDimViewMaximumAlpha;
    //  AutoresizingMask.
    _containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    _sideControllerContainerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    _sideController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    _sideControllerShadowView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    _centralControllerDimView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
    _centralController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;

    //  View Hierachy organization. 
    self.view = _containerView;
    [_sideControllerContainerView addSubview:_sideControllerShadowView];
    [_sideControllerContainerView addSubview:_sideController.view];
//  [_centralController.view addSubview:_centralControllerDimView];
    [_containerView addSubview:_centralController.view];
    [_containerView addSubview:_centralControllerDimView];
    [_containerView addSubview:_sideControllerContainerView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //  Horizontal pan gesture attachment.
    self.horizontalPan = [[SDirectionPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleHorizontalPan:) direction:SDirectionPanGestureRecognizerDirectionHorizontal];
    [self.containerView addGestureRecognizer:self.horizontalPan];

    //  Default side controller state.
    self.sideControllerState = SRevealSideControllerSideControllerStateRevealed;
}

#pragma mark - Side Controller, Central Controller Management and Reveal/ Hide Side Controller.

- (void)handleHorizontalPan:(SDirectionPanGestureRecognizer *)horizontalPan
{
    if (horizontalPan.state == UIGestureRecognizerStateChanged) {
        if (self.sideControllerState == SRevealSideControllerSideControllerStateHidden || self.sideControllerState == SRevealSideControllerSideControllerStateRevealed) {
            if (self.sideControllerState == SRevealSideControllerSideControllerStateHidden && horizontalPan.moveX > 0) {
                self.sideControllerState = SRevealSideControllerSideControllerStateMovingFromHidden;
                [[NSNotificationCenter defaultCenter] postNotificationName:SRevealSideControllerWillRevealSideControllerNotification object:self];
            }   else if (self.sideControllerState == SRevealSideControllerSideControllerStateRevealed && horizontalPan.moveX < 0) {
                self.sideControllerState = SRevealSideControllerSideControllerStateMovingFromRevealed;
                [[NSNotificationCenter defaultCenter] postNotificationName:SRevealSideControllerWillHideSideControllerNotification object:self];
            }   else {
                return;
            }
        }
        CGFloat moveX = horizontalPan.moveX;
        CGFloat originX = self.sideControllerContainerView.frame.origin.x;
        originX +=moveX;
        CGFloat movePercentage = 0.0;
        if (originX > 0) originX = 0;
        if (originX < -kSRevealSideControllerSideControllerWidth) originX = -kSRevealSideControllerSideControllerWidth;
        self.sideControllerContainerView.frame = CGRectMake(originX, 0, self.sideControllerContainerView.frame.size.width, self.sideControllerContainerView.frame.size.height);
        movePercentage = fabs((kSRevealSideControllerSideControllerWidth + originX) / kSRevealSideControllerSideControllerWidth);
        self.sideControllerShadowView.alpha = round(movePercentage * 100.0) / 100.0;
        self.centralControllerDimView.alpha = round(movePercentage * 100.0) / 100.0 * kSRevealSideControllerDimViewMaximumAlpha;
    }   else if (horizontalPan.state == UIGestureRecognizerStateEnded) {
        CGFloat originX = self.sideControllerContainerView.frame.origin.x;
        if (originX == -kSRevealSideControllerSideControllerWidth) {
            self.sideControllerState = SRevealSideControllerSideControllerStateHidden;
            [[NSNotificationCenter defaultCenter] postNotificationName:SRevealSideControllerDidHideSideControllerNotification object:self];
            return;
        }   else if (originX == 0) {
            self.sideControllerState = SRevealSideControllerSideControllerStateRevealed;
            [[NSNotificationCenter defaultCenter] postNotificationName:SRevealSideControllerDidRevealSideControllerNotification object:self];
            return;
        }
        if (horizontalPan.moveX < 0 || originX < kSRevealSideControllerSideControllerDefiniteHideXPosition) {
            [self hideSideController];
        }   else {
            [self revealSideController];
        }
    }
}

- (void)revealSideController
{
    if (self.sideControllerState == SRevealSideControllerSideControllerStateHidden) {
        self.sideControllerState = SRevealSideControllerSideControllerStateMovingFromHidden;
        [[NSNotificationCenter defaultCenter] postNotificationName:SRevealSideControllerWillRevealSideControllerNotification object:self];
    }   else if (self.sideControllerState == SRevealSideControllerSideControllerStateRevealed) {
        return;
    }
    [UIView animateWithDuration:kSRevealSideControllerRevealHideAnimationDuration 
                          delay:0.0 
                        options:UIViewAnimationOptionCurveEaseOut 
                     animations:^{
                         self.sideControllerContainerView.frame = CGRectMake(0, 0, self.sideControllerContainerView.frame.size.width, self.sideControllerContainerView.frame.size.height);
                        self.sideControllerShadowView.alpha = 1.0;
                        self.centralControllerDimView.alpha = kSRevealSideControllerDimViewMaximumAlpha;
                     }
                     completion:^(BOOL finished){
                        self.sideControllerState = SRevealSideControllerSideControllerStateRevealed;
                        [[NSNotificationCenter defaultCenter] postNotificationName:SRevealSideControllerDidRevealSideControllerNotification object:self];
                     }];
}

- (void)hideSideController
{
if (self.sideControllerState == SRevealSideControllerSideControllerStateRevealed) {
        self.sideControllerState = SRevealSideControllerSideControllerStateMovingFromRevealed;
        [[NSNotificationCenter defaultCenter] postNotificationName:SRevealSideControllerWillHideSideControllerNotification object:self];
    }   else if (self.sideControllerState == SRevealSideControllerSideControllerStateHidden) {
        return;
    }
    [UIView animateWithDuration:kSRevealSideControllerRevealHideAnimationDuration 
                          delay:0.0 
                        options:UIViewAnimationOptionCurveEaseOut 
                     animations:^{
                        self.sideControllerContainerView.frame = CGRectMake(-kSRevealSideControllerSideControllerWidth, 0, self.sideControllerContainerView.frame.size.width, self.sideControllerContainerView.frame.size.height);
                        self.sideControllerShadowView.alpha = 0.0;
                        self.centralControllerDimView.alpha = 0.0;
                     } 
                     completion:^(BOOL finished){
                        self.sideControllerState = SRevealSideControllerSideControllerStateHidden;
                        [[NSNotificationCenter defaultCenter] postNotificationName:SRevealSideControllerDidHideSideControllerNotification object:self];
                     }];
}

@end
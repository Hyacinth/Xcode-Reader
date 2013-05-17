#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

UIKIT_EXTERN NSString* const SRevealSideControllerWillRevealSideControllerNotification;
UIKIT_EXTERN NSString* const SRevealSideControllerDidRevealSideControllerNotification;
UIKIT_EXTERN NSString* const SRevealSideControllerWillHideSideControllerNotification;
UIKIT_EXTERN NSString* const SRevealSideControllerDidHideSideControllerNotification;

//  Custom container controller class contain two children view controllers:
//  Side controller, central controller.
//  Central controller will be fixed to fill the entire application frame.(SRevealSideController will normally be a root view controller)
//  Side controller will be hidden on the left side defaulty. And can be revealed and hided by a horizontal pan gesture or programatically.
//  That is to say: side controller will follow a horizontal pan's movement to traverse between its hidden position to fully revealed position.
@interface SRevealSideController : UIViewController<UIGestureRecognizerDelegate>

//  Side Controller.
@property (nonatomic, strong) UIViewController *sideController;

//  Central Controller.
@property (nonatomic, strong) UIViewController *centralController;

//  Designated Initializer.
- (id)initWithSideController:(UIViewController *)sideController centralController:(UIViewController *)centralController;

//  Reveal side controller with an animation.
//  Only valid when side controller being hidden.
- (void)revealSideController;

//  Hide side controller with an animation.
//  Only valid when side controller being fully revealed.
- (void)hideSideController;

@end

@interface UIViewController(SRevealSideController)

//  If a view controller has an ancestor as a SRevealSideController, return one, otherwise return nil.
- (id)revealSideController;

@end
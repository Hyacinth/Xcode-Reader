//
//  SReaderController.h
//  Xcode Reader
//
//  Created by Song Hui on 13-4-23.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SReaderBarPad.h"

@interface SReaderController : UIViewController<UINavigationControllerDelegate, UIPopoverControllerDelegate>

//  Controller's bar.
@property (nonatomic, strong) SReaderBarPad *readerBarPad;

@end

//
//  SReaderBarPad.h
//  Xcode Reader
//
//  Created by Song Hui on 13-4-23.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import <UIKit/UIKit.h>

//  A custom toolbar specifically designed for SReaderController on iPad.
//  It has an unique appearance;
//  Centered title label;
//  Left and right buttons that will be aligned by SReaderBarPad appropriately.

@interface SReaderBarPad : UIToolbar

//  Only need assing a string to the title property, the attributes and display job is upon SReaderBarPad.
@property (nonatomic, strong) NSString *title;

//  In Xcode Reader, there will be 3 left buttons and 3 right buttons.
//  SReaderBar can contain more, but to be symetric please provide left and right buttons with equal numbers.
@property (nonatomic, strong) NSArray *leftBarButtons;
@property (nonatomic, strong) NSArray *rightBarButtons;

//  The Designated Initializier will still be initWithFrame:, this is just a convenient init method.

- (id)initWithFrame:(CGRect)frame backgroundImage:(UIImage *)backgroundImage shadowImage:(UIImage *)shadowImage;

@end

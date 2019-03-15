//
//  YJDCharacterItem.h
//  YJDEffectText
//
//  Created by BURNING on 2019/3/14.
//  Copyright © 2019年 com.yy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    YJDCharacterEditAddState     = 0,
    YJDCharacterEditChangeState  = 1,
    YJDCharacterEditDelState     = 2,
    YJDCharacterEditCancelState  = 3
} YJDCharacterEditState;

typedef enum : NSUInteger {
    YJDCharacterEditClassicsSyle = 0,
    YJDCharacterEditRainbowSyle  = 1,
    YJDCharacterEditShineSyle    = 2,
    YJDCharacterEditOutlineSyle  = 3
} YJDCharacterEditStyle;

@interface YJDCharacterItem : NSObject

@property (nonatomic, assign) BOOL selectedBackgroudColor;
@property (nonatomic, assign) NSInteger colorIndex;
@property (nonatomic, strong) UIColor *selectedColor;
@property (nonatomic, assign) YJDCharacterEditState editState;
@property (nonatomic, assign) YJDCharacterEditStyle editSyle;
@property (nonatomic, strong) NSAttributedString *attributedString;
@property (nonatomic, strong) UIView *editView;
@property (nonatomic, strong) UIView *editSuperView;
@property (nonatomic) CGAffineTransform transform;

@end

NS_ASSUME_NONNULL_END

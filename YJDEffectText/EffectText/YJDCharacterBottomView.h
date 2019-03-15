//
//  YJDCharacterBottomView.h
//  YJDEffectText
//
//  Created by BURNING on 2019/3/14.
//  Copyright © 2019年 com.yy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJDColorPickView.h"
#import "YJDCharacterItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface YJDCharacterBottomView : UIView

@property (nonatomic, strong, readonly) NSArray<NSNumber *> *colorArray;
@property (nonatomic, strong, readonly) UIButton *backColorButton;
@property (nonatomic, strong, readonly) YJDColorPickView *colorPickView;
@property (nonatomic, assign) YJDCharacterEditStyle currentSelectedStyle;
@property (nonatomic, copy) void(^selectColor)(NSUInteger colorNumber);
@property (nonatomic, copy) void(^selectEditStyle)(YJDCharacterEditStyle editStyle);
@property (nonatomic, strong) UIColor *currentSelectedColor;

- (instancetype)initWithColors:(NSArray <NSNumber *> *)colorArray;

@end

NS_ASSUME_NONNULL_END

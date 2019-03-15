//
//  YJDColorInputView.h
//  YJDEffectText
//
//  Created by BURNING on 2019/3/14.
//  Copyright © 2019年 com.yy. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YJDCharacterItem.h"
#import "YYText.h"
@class YJDColorInputView;

NS_ASSUME_NONNULL_BEGIN

@protocol YJDColorInputViewDelegate <NSObject>

//- (void)inputView:(BSColorInputView *)inputView didSelectedUnEditArea:(BSEidtCharacterItem *)editItem;

- (void)inputView:(YJDColorInputView *)inputView textViewValueChange:(YYTextView *)textView;

@end

@interface YJDColorInputView : UIView

@property (nonatomic, strong, readonly) UIView *viewContainer;
@property (nonatomic, strong, readonly) YYTextView *textView;
@property (nonatomic, strong) YJDCharacterItem *editItem;
@property (nonatomic, assign) CGRect maxRect;
@property (nonatomic, weak) id<YJDColorInputViewDelegate> delegate;

- (void)refreshStyle;

@end

NS_ASSUME_NONNULL_END

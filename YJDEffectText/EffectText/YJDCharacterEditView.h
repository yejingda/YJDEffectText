//
//  YJDCharacterEditView.h
//  YJDEffectText
//
//  Created by BURNING on 2019/3/14.
//  Copyright © 2019年 com.yy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YJDCharacterItem.h"


NS_ASSUME_NONNULL_BEGIN

@interface YJDCharacterEditView : UIView

@property (nonatomic, copy) void(^selectString)(YJDCharacterItem *characterItem);

- (void)showAnimationInview:(UIView *)view WithCharacterItem:(YJDCharacterItem *)characterItem;

- (void)dismissAnimation;

@end

NS_ASSUME_NONNULL_END

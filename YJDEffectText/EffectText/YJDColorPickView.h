//
//  YJDColorPickView.h
//  YJDEffectText
//
//  Created by BURNING on 2019/3/14.
//  Copyright © 2019年 com.yy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YJDColorPickView : UIView

- (instancetype)initWithColorArray:(NSArray *)colorArr;
- (void)setCheckWithIndex:(NSUInteger)index;

@property (nonatomic, copy) void(^selectColor)(NSUInteger);

@end

NS_ASSUME_NONNULL_END

//
//  YJDCharacterEditView.m
//  YJDEffectText
//
//  Created by BURNING on 2019/3/14.
//  Copyright © 2019年 com.yy. All rights reserved.
//

#import "YJDCharacterEditView.h"
#import "YJDColorInputView.h"
#import "YJDCharacterBottomView.h"
#import <libextobjc/extobjc.h>
#import "UIColor+YJDColor.h"
#import "UIColor+YJDColor.h"
#import "Masonry.h"

#define BSBottomViewHeight      100
#define BSLeftAndRight          15
#define BSSpacing               20


@interface YJDCharacterEditView ()<YJDColorInputViewDelegate>

@property (nonatomic, strong) UIButton *finshedButton;
@property (nonatomic, strong) YJDColorInputView *colorInputView;
@property (nonatomic, strong) YJDCharacterBottomView *bottomView;
@property (nonatomic, strong) YJDCharacterItem *editCharacterItem;
/**键盘高度*/
@property (nonatomic, assign) BOOL haveOriginalText;
@property (nonatomic, assign) CGFloat keyboardHeight;
@property (nonatomic, strong) NSArray<NSNumber *> *colorArray;

@end


@implementation YJDCharacterEditView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor yjd_colorWithHex:0x000000 alpha:0.2];
        
        [self addSubview:self.finshedButton];
        [self addSubview:self.colorInputView];
        [self addSubview:self.bottomView];
        
        float TopY = 20;
        
        @weakify(self)
        [self.finshedButton mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(@(TopY + 25));
            make.right.equalTo(self.mas_right).with.offset(-15);
            make.height.equalTo(@(30));
            make.width.equalTo(@(30));
        }];
        
        self.bottomView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, BSBottomViewHeight);
        
        [self addNotification];
    }
    return self;
}

- (void)showAnimationInview:(UIView *)view WithCharacterItem:(YJDCharacterItem *)characterItem {
    _editCharacterItem = characterItem;
    NSString *text = characterItem.attributedString.string;
    self.bottomView.currentSelectedStyle = characterItem.editSyle;
    //    self.bottomView.currentSelectedColor = characterItem.selectedColor;
    [self.bottomView.colorPickView setCheckWithIndex:characterItem.colorIndex];
    if (characterItem.editView) {
        _colorInputView = nil;
        //        _colorInputView = (BSColorInputView *)characterItem.editView;
        //        _colorInputView.textView.editable = YES;
    }
    [self showAnimationInview:view WithString:text?text:@""];
}

- (void)showAnimationInview:(UIView *)view WithString:(NSString *)text {
    if (self.superview) {
        [self removeFromSuperview];
    }
    
    if (!view || ![[view class] isSubclassOfClass:[UIView class]]) {
        view = [UIApplication sharedApplication].delegate.window;
    }
    
    self.haveOriginalText = NO;
    if (text && text.length > 0 && ![text isEqualToString:@" "]) {
        self.haveOriginalText = YES;
    }
    
    self.alpha = 0.0;
    [view addSubview:self];
    self.frame = view.bounds;
    
    if (![self.colorInputView superview]) {
        [self addSubview:self.colorInputView];
    }
    
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:.3f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.alpha = 1;
                     }completion:^(BOOL finished) {
                         self.userInteractionEnabled = YES;
                     }];
    
    [self.colorInputView.textView becomeFirstResponder];
    //    [self showCorrectStyle];
}

- (void)dismissAnimation;{
    //    [self.textView resignFirstResponder];
    [UIView animateWithDuration:.3f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.alpha = 0;
                     }completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}


// 添加通知
- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (CGRect)textMaxRect {
    CGRect bottomFrame = self.bottomView.frame;
    CGFloat offY = 64;
    CGFloat bottomOffY = CGRectGetMinY(bottomFrame);
    if (bottomFrame.origin.y == 0) {
        bottomOffY = CGRectGetHeight(self.bounds) - 20;
    }
    
    return  CGRectMake(0, offY, CGRectGetWidth(self.bounds), bottomOffY - offY);
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    if (CGRectContainsPoint(self.colorInputView.frame, touchLocation) && !CGRectContainsPoint(self.colorInputView.textView.frame, touchLocation) && !CGRectContainsPoint(self.bottomView.frame, touchLocation)) {
        [self didSelectedSureButton];
    }
}

#pragma mark keyboardnotification
- (void)keyboardWillShow:(NSNotification *)notification {
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _keyboardHeight = keyboardFrame.size.height;
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    self.bottomView.frame = CGRectMake(0, CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds), BSBottomViewHeight);
    [UIView animateWithDuration:duration animations:^{
        CGFloat top = keyboardFrame.origin.y - BSBottomViewHeight;
        self.bottomView.frame = CGRectMake(0, top, CGRectGetWidth(self.bounds), BSBottomViewHeight);
    }completion:^(BOOL finished) {
        self.colorInputView.maxRect = [self textMaxRect];
        self.colorInputView.editItem = self.editCharacterItem;
    }];
}
- (void)keyboardWillHidden:(NSNotification *)notification {
    CGFloat duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        CGRect frame = self.frame;
        frame.origin.y =  [UIScreen mainScreen].bounds.size.height;
        self.bottomView.frame = frame;
    }];
}


#pragma -mark getter setter

- (NSArray *)colorArray {
    if (!_colorArray) {
        _colorArray = @[@(0xffffff),@(0xffD01f),@(0x30cb6a),@(0x4aacff),@(0xdf424d),@(0x000000)];
    }
    return _colorArray;
}

- (YJDColorInputView *)colorInputView {
    if (!_colorInputView) {
        _colorInputView = [[YJDColorInputView alloc] init];
        _colorInputView.delegate = self;
    }
    return _colorInputView;
}

- (YJDCharacterBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[YJDCharacterBottomView alloc] initWithColors:self.colorArray];
        [_bottomView.backColorButton addTarget:self action:@selector(changeBackgrounColor) forControlEvents:UIControlEventTouchUpInside];
        @weakify(self)
        _bottomView.selectEditStyle = ^(YJDCharacterEditStyle editStyle) {
            @strongify(self);
            self.editCharacterItem.editSyle = editStyle;
            [self.colorInputView refreshStyle];
            self.bottomView.colorPickView.hidden = NO;
            self.bottomView.backColorButton.hidden = NO;
            if (editStyle == YJDCharacterEditRainbowSyle) {
                self.bottomView.colorPickView.hidden = YES;
                self.bottomView.backColorButton.hidden = YES;
            }
            if (editStyle != YJDCharacterEditClassicsSyle) {
                self.bottomView.backColorButton.hidden = YES;
                if (self.editCharacterItem.selectedBackgroudColor) {
                    [self.bottomView.backColorButton setBackgroundImage:[UIImage imageNamed:@"shoot_char_back_nor"] forState:UIControlStateNormal];
                    [UIView animateWithDuration:0.25 animations:^{
                        self.bottomView.backColorButton.frame = CGRectMake(11, 9, 30, 30);
                    }];
                } else {
                    [self.bottomView.backColorButton setBackgroundImage:[UIImage imageNamed:@"shoot_char_back_white"] forState:UIControlStateNormal];
                    [UIView animateWithDuration:0.25 animations:^{
                        self.bottomView.backColorButton.frame = CGRectMake(15, 13, 25, 25);
                    }];
                }
            }
        };
        _bottomView.selectColor = ^(NSUInteger colorInteger) {
            @strongify(self);
            self.editCharacterItem.selectedColor = [UIColor yjd_colorWithHex:colorInteger];
            for (NSNumber *colorNum in self.colorArray) {
                if (colorInteger == [colorNum integerValue]) {
                    self.editCharacterItem.colorIndex = [self.colorArray indexOfObject:colorNum];
                }
            }
            [self.colorInputView refreshStyle];
        };
    }
    return _bottomView;
}

- (UIButton *)finshedButton {
    if (!_finshedButton) {
        _finshedButton = [[UIButton alloc] init];
        [_finshedButton setBackgroundImage:[UIImage imageNamed:@"shoot_ok"] forState:UIControlStateNormal];
        [_finshedButton addTarget:self action:@selector(didSelectedSureButton) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finshedButton;
}

- (void)didSelectedSureButton {
    
    self.editCharacterItem.attributedString = self.colorInputView.textView.attributedText;
    if (self.editCharacterItem.editSyle == YJDCharacterEditRainbowSyle) {
        self.editCharacterItem.editView = self.colorInputView.viewContainer;
    } else {
        self.editCharacterItem.editView = self.colorInputView.textView;
    }
    
    self.colorInputView.textView.editable = NO;
    if (self.selectString) {
        if (self.colorInputView.textView.text.length > 0 && !self.haveOriginalText && ![self.colorInputView.textView.text isEqualToString:@" "]) {
            self.editCharacterItem.editState = YJDCharacterEditAddState;
            self.selectString(self.editCharacterItem);
        } else if(self.colorInputView.textView.text.length > 0 && self.haveOriginalText){
            self.editCharacterItem.editState = YJDCharacterEditChangeState;
            self.selectString(self.editCharacterItem);
        } else {
            if (self.haveOriginalText) {
                self.editCharacterItem.editState = YJDCharacterEditDelState;
                self.selectString(self.editCharacterItem);
            } else {
                self.editCharacterItem.editState = YJDCharacterEditCancelState;
                self.selectString(self.editCharacterItem);
            }
        }
    }
    
    [self dismissAnimation];
}

- (void)changeBackgrounColor {
    self.editCharacterItem.selectedBackgroudColor = !self.editCharacterItem.selectedBackgroudColor;
    [self.colorInputView refreshStyle];
    if (self.editCharacterItem.selectedBackgroudColor) {
        [self.bottomView.backColorButton setBackgroundImage:[UIImage imageNamed:@"shoot_char_back_nor"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.25 animations:^{
            self.bottomView.backColorButton.frame = CGRectMake(11, 9, 30, 30);
        }];
    } else {
        [self.bottomView.backColorButton setBackgroundImage:[UIImage imageNamed:@"shoot_char_back_white"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.25 animations:^{
            self.bottomView.backColorButton.frame = CGRectMake(15, 13, 25, 25);
        }];
    }
}

#pragma - mark  YJDColorInputViewDelegate

- (void)inputView:(YJDColorInputView *)inputView textViewValueChange:(YYTextView *)textView {
    
}

@end

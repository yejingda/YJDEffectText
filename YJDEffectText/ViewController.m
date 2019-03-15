//
//  ViewController.m
//  YJDEffectText
//
//  Created by BURNING on 2019/3/14.
//  Copyright © 2019年 com.yy. All rights reserved.
//

#import "ViewController.h"
#import "YJDColorInputView.h"
#import "YJDCharacterBottomView.h"
#import <libextobjc/extobjc.h>
#import "UIColor+YJDColor.h"
#import "YJDCharacterEditView.h"
#import "YJDCharacterItem.h"

@interface ViewController () 
@property (nonatomic, strong) YJDCharacterEditView *characterEditView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self editTextAction:nil];
}

- (void)editTextAction:(YJDCharacterEditView *)item {
    _characterEditView = nil;
    if (!item) {
        YJDCharacterItem *characterItem = [[YJDCharacterItem alloc] init];
        characterItem.colorIndex = 0;
        characterItem.selectedBackgroudColor = YES;
        characterItem.editState = YJDCharacterEditAddState;
        characterItem.editSyle = YJDCharacterEditClassicsSyle;
        characterItem.selectedColor = [UIColor whiteColor];
        //经测试，需要让字符串有值，才能b一开始把效果设置上去
        characterItem.attributedString = [[NSAttributedString alloc] initWithString:@" "];
        [self.characterEditView showAnimationInview:self.view WithCharacterItem:characterItem];
    } else {
        
        [self.characterEditView showAnimationInview:self.view WithCharacterItem:item];
    }
}

- (YJDCharacterEditView *)characterEditView {
    if (!_characterEditView) {
        _characterEditView = [[YJDCharacterEditView alloc] init];
        @weakify(self)
        _characterEditView.selectString = ^(YJDCharacterItem * _Nonnull characterItem) {
            @strongify(self)
            [characterItem.editView removeFromSuperview];
            if (characterItem.editState == YJDCharacterEditAddState || characterItem.editState == YJDCharacterEditChangeState) {
                //
            }
        };
        
    }
    return _characterEditView;
}

@end

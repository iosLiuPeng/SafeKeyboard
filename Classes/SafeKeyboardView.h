//
//  SafeKeyboardView.h
//  Example
//
//  Created by 刘鹏i on 2019/9/19.
//  Copyright © 2019 liupeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SafeKeyboardView : UIView
@property (nonatomic, assign) NSInteger maxLength;///< 文本字数限制（默认0，则不限制）
@property (nonatomic, assign) BOOL randomSort;  ///< 是否随机排序（默认NO，开启后，每次弹出键盘都是随机排序）
@property (nonatomic, assign) BOOL secureText;  ///< 强制密文显示（默认NO，UITextField自带的会先显示文字再变成点，这个直接显示点，防止输入时被看到密码）
@property (nonatomic, assign) BOOL pureDigital; ///< 强制纯数字输入（默认NO，比如粘贴进来的不是纯数字，会不允许粘贴）

@property (nonatomic, copy) void(^didBeginEditing)(NSString *text);   ///< 输入已经开始
@property (nonatomic, copy) void(^didInputChange)(NSString *text);    ///< 输入已经变化
@property (nonatomic, copy) void(^didEndEditing)(NSString *text);     ///< 输入已经结束

/// 配置安全键盘，传入对应的UITextField
+ (SafeKeyboardView *)keyboardWithTextField:(UITextField *)textField;

@end

NS_ASSUME_NONNULL_END

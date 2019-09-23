//
//  SafeKeyboardView.m
//  Example
//
//  Created by 刘鹏i on 2019/9/19.
//  Copyright © 2019 liupeng. All rights reserved.
//

#import "SafeKeyboardView.h"
#import "UIResponder+FirstResponder.h"

@interface SafeKeyboardView () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIButton *btnNum1;
@property (strong, nonatomic) IBOutlet UIButton *btnNum2;
@property (strong, nonatomic) IBOutlet UIButton *btnNum3;
@property (strong, nonatomic) IBOutlet UIButton *btnNum4;
@property (strong, nonatomic) IBOutlet UIButton *btnNum5;
@property (strong, nonatomic) IBOutlet UIButton *btnNum6;
@property (strong, nonatomic) IBOutlet UIButton *btnNum7;
@property (strong, nonatomic) IBOutlet UIButton *btnNum8;
@property (strong, nonatomic) IBOutlet UIButton *btnNum9;
@property (strong, nonatomic) IBOutlet UIButton *btnNum0;
@property (nonatomic, strong) NSArray<UIButton *> *arrBtn;      ///< 所有数字按钮

@property (nonatomic, strong) NSArray<NSString *> *arrSource;   ///< 所有数字
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *lytBottomH;

@property (nonatomic, copy) NSString *clearText;///< 明文
@end

@implementation SafeKeyboardView
#pragma mark - Public
/// 配置安全键盘，传入对应的UITextField
+ (SafeKeyboardView *)keyboardWithTextField:(UITextField *)textField
{
    if (textField) {
        SafeKeyboardView *view = [SafeKeyboardView keyboardView];
        textField.inputView = view;
        textField.delegate = view;
        // 设置初始状态时的明文
        view.clearText = textField.text;
        return view;
    } else {
        return nil;
    }
}

+ (SafeKeyboardView *)keyboardView
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height * 0.4;
    SafeKeyboardView *view = [[SafeKeyboardView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    return view;
}

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadViewFromXib];
        
        [self viewConfig];
    }
    return self;
}

- (void)loadViewFromXib
{
    UIView *contentView = [[NSBundle bundleForClass:[self class]] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
    contentView.frame = self.bounds;
    contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight;
    [self addSubview:contentView];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
    
    NSLog(@"== 安全键盘被释放 == %@", self);
}

#pragma mark - Subjoin
- (void)viewConfig
{
    _arrBtn = @[_btnNum1, _btnNum2, _btnNum3, _btnNum4, _btnNum5, _btnNum6, _btnNum7, _btnNum8, _btnNum9, _btnNum0];
    
    _clearText = @"";
    
    self.randomSort = NO;
    
    _lytBottomH.constant = [self.class bottomSafeAreaHeight];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide) name:UIKeyboardDidHideNotification object:nil];
}

#pragma mark - Private
/// 当前的输入框
- (UITextField *)currentTextField
{
    UIResponder *firstResponder = [UIApplication currentFirstResponder];
    if ([firstResponder isKindOfClass:UITextField.class]) {
        return (UITextField *)firstResponder;
    } else {
        // 如果存在键盘出来了第一响应者还不是输入框的情况，可以在这里遍历firstResponder.nextResponder查找输入框
        return nil;
    }
}

/// 对数组中元素洗牌
- (NSArray *)shuffledArray:(NSArray *)array
{
    NSArray *arr = [array sortedArrayUsingComparator:^NSComparisonResult(id object1, id object2) {
        int seed = arc4random_uniform(2);
        if (seed) {
            return NSOrderedAscending;
        } else {
            return NSOrderedDescending;
        }
    }];
    return arr;
}

/// 底部安全区高度
+ (CGFloat)bottomSafeAreaHeight
{
    CGFloat height = 0.0;
    if (@available(iOS 11.0, *)) {
        height = [UIApplication sharedApplication].delegate.window.safeAreaInsets.bottom;
    }
    return height;
}

/// 由●构成的字符串
- (NSString *)dotString:(NSInteger)length
{
    NSMutableString *mustr = [[NSMutableString alloc] init];
    for (NSInteger i = 0; i < length; i++) {
        [mustr appendString:@"●"];
    }
    return mustr;
}

#pragma mark - Set
- (void)setArrSource:(NSArray<NSString *> *)arrSource
{
    _arrSource = arrSource;
    
    for (NSInteger i = 0; i < arrSource.count; i++) {
        NSString *title = arrSource[i];
        UIButton *btn = _arrBtn[i];
        [btn setTitle:title forState:UIControlStateNormal];
    }
}

- (void)setRandomSort:(BOOL)randomSort
{
    _randomSort = randomSort;
    
    NSArray *arrStandard = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0"];
    if (_randomSort) {
        self.arrSource = [self shuffledArray:arrStandard];
    } else {
        self.arrSource = arrStandard;
    }
}

#pragma mark - Action
/// 点击数字
- (IBAction)clickedNumber:(UIButton *)sender {
    UITextField *textField = self.currentTextField;
    BOOL canInput = [self textField:textField shouldChangeCharactersInRange:NSMakeRange(textField.text.length, 0) replacementString:sender.titleLabel.text];
    if (canInput) {
        [textField insertText:sender.titleLabel.text];
    }
}

/// 点击删除
- (IBAction)clickedDelete:(id)sender {
    UITextField *textField = self.currentTextField;
    NSRange range = textField.text.length? NSMakeRange(textField.text.length - 1, 1): NSMakeRange(0, 0);
    
    BOOL canInput = [self textField:textField shouldChangeCharactersInRange:range replacementString:@""];
    if (canInput) {
        [textField deleteBackward];
    }
}

/// 点击关闭
- (IBAction)clickedClose:(id)sender {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

/// 是否都为数字
- (BOOL)isNumber:(NSString *)text
{
    NSString *regex = @"[0-9]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [pred evaluateWithObject:text];
}

#pragma mark - Notification
- (void)keyboardDidHide
{
    // 隐藏时重新拍好。这样就避免显示时排序，文字会闪一下
    if (_randomSort == YES) {
        self.randomSort = YES;
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (_didBeginEditing) {
        _didBeginEditing(_clearText);
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // 纯数字模式下，校验是否都为数字
    if (_pureDigital && [self isNumber:string] == NO) {
        return NO;
    }
    
    NSMutableString *text = [_clearText mutableCopy];
    [text replaceCharactersInRange:range withString:string];
    
    // 字数限制
    if (_maxLength > 0 && text.length > _maxLength) {
        return NO;
    }
    
    _clearText = [text copy];
    
    if (_didInputChange) {
        _didInputChange(text);
    }
    
    if (_secureText) {
        textField.text = [self dotString:text.length];
        return NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (_didEndEditing) {
        _didEndEditing(_clearText);
    }
}

@end


#pragma mark - SafeKeyboardButton
IB_DESIGNABLE
@interface SafeKeyboardButton : UIButton
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;   ///< 圆角度数
@property (nonatomic, assign) IBInspectable BOOL adjustsFontSize;   ///< 字体大小自适应
@end

@implementation SafeKeyboardButton
/// 圆角度数
- (void)setCornerRadius:(CGFloat)cornerRadius
{
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = cornerRadius;
}

/// 字体大小自适应
- (void)setAdjustsFontSize:(BOOL)adjustsFontSize
{
    _adjustsFontSize = adjustsFontSize;
    self.titleLabel.adjustsFontSizeToFitWidth = adjustsFontSize;
}

- (void)setHighlighted:(BOOL)highlighted
{
    if (highlighted) {
        self.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0];
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
}

@end


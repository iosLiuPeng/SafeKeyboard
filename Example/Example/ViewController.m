//
//  ViewController.m
//  Example
//
//  Created by 刘鹏i on 2019/9/16.
//  Copyright © 2019 liupeng. All rights reserved.
//

#import "ViewController.h"
#import "SafeKeyboardView.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutlet UITextField *textField;

@property (strong, nonatomic) IBOutlet UITextField *textField2;
@property (strong, nonatomic) IBOutlet UILabel *lbl1;
@property (strong, nonatomic) IBOutlet UILabel *lbl2;
@property (strong, nonatomic) IBOutlet UILabel *lbl3;
@property (strong, nonatomic) IBOutlet UILabel *lbl4;
@property (strong, nonatomic) IBOutlet UILabel *lbl5;
@property (strong, nonatomic) IBOutlet UILabel *lbl6;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self singleTextField];

    [self multipleTextField];
}

- (void)singleTextField
{
    SafeKeyboardView *view = [SafeKeyboardView keyboardWithTextField:_textField];
//    view.secureText = YES;
    
    __weak typeof(self) weakSelf = self;
    // 输入开始
    view.didBeginEditing = ^(NSString * _Nonnull text) {
        NSLog(@"输入开始:%@", text);
    };
    // 输入变化
    view.didInputChange = ^(NSString * _Nonnull text) {
        NSLog(@"输入变化:%@", text);
    };
    // 输入结束
    view.didEndEditing = ^(NSString * _Nonnull text) {
        NSLog(@"输入结束:%@", text);
    };
}

- (void)multipleTextField
{
    SafeKeyboardView *view = [SafeKeyboardView keyboardWithTextField:_textField2];
    view.randomSort = YES;
    view.maxLength = 6;
    
    __weak typeof(self) weakSelf = self;
    // 输入开始
    view.didBeginEditing = ^(NSString * _Nonnull text) {
        NSLog(@"输入开始:%@", text);
    };
    // 输入变化
    view.didInputChange = ^(NSString * _Nonnull text) {
        [weakSelf updatePassword:text];
        NSLog(@"输入变化:%@", text);
    };
    // 输入结束
    view.didEndEditing = ^(NSString * _Nonnull text) {
        NSLog(@"输入结束:%@", text);
    };
}

- (void)updatePassword:(NSString *)string
{
    NSArray *arrLbl = @[_lbl1, _lbl2, _lbl3, _lbl4, _lbl5, _lbl6];
    for (NSInteger i = 0; i < arrLbl.count; i++) {
        UILabel *label = arrLbl[i];
        
        NSString *subStr = @"";
        if (i < string.length) {
            subStr = [string substringWithRange:NSMakeRange(i, 1)];
        }
        label.text = subStr;
    }
}

- (IBAction)clickedButton:(id)sender {
    [_textField2 becomeFirstResponder];
}

@end

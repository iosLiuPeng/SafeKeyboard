//
//  SafeTextField.m
//  Example
//
//  Created by 刘鹏i on 2019/9/20.
//  Copyright © 2019 liupeng. All rights reserved.
//

#import "SafeTextField.h"

@interface SafeTextField ()

@end

@implementation SafeTextField

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    /*
        屏蔽所有操作
        但是长按手势选择、光标移位等暂时还未处理，如果有这样的需求，最好自定义一个视图
     */
    return action == @selector(findFirstResponder:);
}


@end

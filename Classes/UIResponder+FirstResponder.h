//
//  UIResponder+FirstResponder.h
//  Example
//
//  Created by 刘鹏i on 2019/9/19.
//  Copyright © 2019 liupeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIResponder (FirstResponder)
/// 当前第一响应者
+ (id)currentFirstResponder;

@end

NS_ASSUME_NONNULL_END

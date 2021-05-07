//
//  JiaoHuView.h
//  WebUrlProject
//
//  Created by LHWen on 2020/10/15.
//  Copyright © 2020 LHWen. All rights reserved.
//

#import <UIKit/UIKit.h>

// 交互页面，输入交互方法

NS_ASSUME_NONNULL_BEGIN

// 调用传参方法
typedef void(^MakeFunction) (NSString *funcString);

@interface JiaoHuView : UIView

// 回调
@property (nonatomic, copy) MakeFunction makeFunction;

@end

NS_ASSUME_NONNULL_END

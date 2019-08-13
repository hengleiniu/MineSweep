//
//  UIView+Category.h
//  MineSweep
//
//  Created by BLIZZMI on 2019/7/16.
//  Copyright © 2019 BLIZZMI. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Category)
/**
 控件左上角 x 坐标
 */
@property (nonatomic, assign) CGFloat x;

/**
 控件左上角 y 坐标
 */
@property (nonatomic, assign) CGFloat y;

/**
 控件的中心点 x 坐标
 */
@property (nonatomic, assign) CGFloat centerX;

/**
 控件的中心点 y 坐标
 */
@property (nonatomic, assign) CGFloat centerY;

/**
 控件的宽度
 */
@property (nonatomic, assign) CGFloat width;

/**
 控件高度
 */
@property (nonatomic, assign) CGFloat height;

/**
 控件size
 */
@property (nonatomic, assign) CGSize size;


/**
 * 判断一个控件是否真正显示在主窗口
 */
- (BOOL)isShowingOnKeyWindow;

/**
 加载xib 创建的 View
 */
+ (instancetype)viewFromXib;
@end

NS_ASSUME_NONNULL_END

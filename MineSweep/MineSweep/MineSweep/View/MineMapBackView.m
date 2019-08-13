//
//  MineMapBackView.m
//  MineSweep
//
//  Created by BLIZZMI on 2019/7/18.
//  Copyright © 2019 BLIZZMI. All rights reserved.
//

#import "MineMapBackView.h"
#import "Masonry.h"
#import "MineMapView.h"

#define iPhoneMinScreeen  [UIScreen mainScreen].bounds.size.width <= 320

@interface MineMapBackView()<MineMapViewDelegate>{
    NSInteger _mineNUmber;
    NSString *_mapBackImageName;
    NSInteger _row;
    NSInteger _column;
    NSInteger _padding;
    NSMutableArray *inerlAppearacneArray;
}
@property (nonatomic, strong) UILabel *timerLabel;
@property (nonatomic, weak) UIButton *flag;
@property (nonatomic, strong) UIImageView *backMineMapImageView;
@property (nonatomic, copy) NSString *numberPix;
@property (nonatomic, assign) BOOL flagSwitch;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation MineMapBackView

- (instancetype)initWithFrame:(CGRect)frame titleName:(NSString *)titleName mapBackImageName:(NSString *)mapBackImageName row:(NSInteger)row column:(NSInteger)column padding:(NSInteger)padding{
    if (self = [super initWithFrame:frame]) {
        _mapBackImageName = mapBackImageName;
        _row = row;
        _column = column;
        _padding = padding;
        UIImageView *background = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        background.image = [UIImage imageNamed:@"s_cj"];
        [self addSubview:background];
        
        UIImageView *titleImage = [[UIImageView alloc] init];
        titleImage.image = [UIImage imageNamed:titleName];
        [self addSubview:titleImage];
        
        UIImageView *lineView = [[UIImageView alloc] init];
        lineView.image = [UIImage imageNamed:@"s_x"];
        [self addSubview:lineView];
        
        UIImageView *alockImageView = [[UIImageView alloc] init];
        alockImageView.image = [UIImage imageNamed:@"s_djs"];
        [self addSubview:alockImageView];
        
        self.timerLabel = [[UILabel alloc] init];
        self.timerLabel.textColor = [UIColor whiteColor];
        self.timerLabel.backgroundColor = [UIColor clearColor];
        self.timerLabel.font = [UIFont boldSystemFontOfSize:26];
        self.timerLabel.text = @"00:00";
        [self addSubview:_timerLabel];
        
        UILabel *bulletLabel = [[UILabel alloc] init];
        bulletLabel.textColor = [UIColor whiteColor];
        bulletLabel.backgroundColor = [UIColor clearColor];
        bulletLabel.font = [UIFont boldSystemFontOfSize:26];
        bulletLabel.textAlignment = NSTextAlignmentRight;
        bulletLabel.text = [NSString stringWithFormat:@"%ld",(long)_mineNUmber];
        [self addSubview:bulletLabel];
        
        UIButton *flag = [[UIButton alloc] init];
        self.flag = flag;
        self.backMineMapImageView.userInteractionEnabled = YES;
        [flag setImage:[UIImage imageNamed:@"s_hq"] forState:UIControlStateNormal];
        [flag addTarget:self action:@selector(flatStyle) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:flag];
        
        UIImageView *bulletImage = [[UIImageView alloc] init];
        bulletImage.image = [UIImage imageNamed:@"zdan"];
        [self addSubview:bulletImage];
        
        self.backMineMapImageView = [[UIImageView alloc] init];
        self.backMineMapImageView.image = [UIImage imageNamed:_mapBackImageName];
        [self addSubview:self.backMineMapImageView];
        
        [titleImage mas_makeConstraints:^(MASConstraintMaker *make) {
            if (iPhoneMinScreeen) {
                make.top.mas_equalTo(background).equalTo(@20);
            }else{
                make.top.mas_equalTo(background).equalTo(@50);
            }
            make.centerX.mas_equalTo(background.mas_centerX);
            make.width.mas_equalTo(@122);
            make.height.mas_equalTo(@30);
        }];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(titleImage).equalTo(@50);
            make.left.mas_equalTo(self).equalTo(@20);
            make.right.mas_equalTo(self).equalTo(@-20);
            make.height.mas_equalTo(@1.5);
        }];
        [alockImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            if ([self.numberPix isEqualToString:@"c"] || iPhoneMinScreeen) {
                make.top.mas_equalTo(lineView).equalTo(@15);
            }else{
                make.top.mas_equalTo(lineView).equalTo(@45);
            }
            make.left.mas_equalTo(self).equalTo(@30);
            make.width.mas_equalTo(@36);
            make.height.mas_equalTo(@39);
        }];
        [self.timerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).equalTo(@80);
            make.top.mas_equalTo(alockImageView.mas_top).equalTo(@9);
            make.height.mas_equalTo(@25);
            make.width.mas_equalTo(@80);
        }];
        [flag mas_makeConstraints:^(MASConstraintMaker *make) {
            if ([self.numberPix isEqualToString:@"c"] || iPhoneMinScreeen) {
                make.top.mas_equalTo(lineView).equalTo(@10);
            }else{
                make.top.mas_equalTo(lineView).equalTo(@40);
            }
            make.width.mas_equalTo(@45);
            make.height.mas_equalTo(@45);
            make.centerX.mas_equalTo(self.mas_centerX).mas_offset(@20);
        }];
        [bulletLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(alockImageView.mas_top).equalTo(@9);;
            make.right.mas_equalTo(self).equalTo(@-36);
            make.width.mas_equalTo(@50);
            make.height.mas_equalTo(@26);
        }];
        [bulletImage mas_makeConstraints:^(MASConstraintMaker *make) {
            if ([self.numberPix isEqualToString:@"c"] || iPhoneMinScreeen) {
                make.top.mas_equalTo(lineView).equalTo(@8);
            }else{
                make.top.mas_equalTo(lineView).equalTo(@38);
            }
            make.right.mas_equalTo(self).equalTo(@-63);
            make.width.mas_equalTo(@47);
            make.height.mas_equalTo(@48);
        }];
        [self.backMineMapImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            if ([self.numberPix isEqualToString:@"c"]) {
                make.top.mas_equalTo(alockImageView).equalTo(@45);
                make.left.mas_equalTo(self).equalTo(@30);
                make.right.mas_equalTo(self).equalTo(@-30);
                if (iPhoneMinScreeen) {
                    make.bottom.mas_equalTo(self).equalTo(@-8);
                }else{
                    make.bottom.mas_equalTo(self).equalTo(@-15);
                }
            }else{
                make.top.mas_equalTo(alockImageView).equalTo(@60);
                make.left.mas_equalTo(self).equalTo(@0);
                make.right.mas_equalTo(self).equalTo(@0);
                if (iPhoneMinScreeen) {
                    make.height.mas_equalTo(@320);
                }else{
                    make.height.mas_equalTo(@374);
                }
                
            }
        }];
        [self setNeedsLayout];
        [self layoutIfNeeded];
        [self timerInitial];
        [self createMineAppear];
    }
    return self;
}
- (void)createMineAppear{
    inerlAppearacneArray = [NSMutableArray array];
    CGFloat x = 0;
    CGFloat y = 0;
    CGFloat w = (self.backMineMapImageView.frame.size.width - _padding*2)/_row;
    CGFloat h = (self.backMineMapImageView.frame.size.height - _padding*2)/_column;
    for (int i = 0; i < _row; i ++) {
        x = i*w + _padding;
        for (int j = 0; j < _column; j ++) {
            @autoreleasepool {
                y = j*h + _padding;
                MineMapView *buttonView = [[MineMapView alloc] initWithFrame:CGRectMake(x, y, w, h)];
                buttonView.delegate = self;
                buttonView.index = i * _column + j;
                buttonView.numberPix = self.numberPix;
                self.backMineMapImageView.userInteractionEnabled = YES;
                [self.backMineMapImageView addSubview:buttonView];
                [inerlAppearacneArray addObject:buttonView];
            }
        }
    }
}
- (NSMutableArray *)appearacneArray{
    return inerlAppearacneArray;
}
- (void)timerInitial{
    __block NSTimeInterval timeInterval = 0;
    __weak typeof(self) weakSelf = self;
    if (@available(iOS 10.0, *)) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            @autoreleasepool {
                timeInterval ++;
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"mm:ss"];
                NSString *dateString = [formatter stringFromDate:date];
                if ([dateString isEqualToString:@"99:99"]) {
                    timeInterval = 0;
                }
                strongSelf.timerLabel.text = dateString;
            }
        }];
    } else {
        // Fallback on earlier versions
    }
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    
}
- (void)flatStyle{
    _flagSwitch = !_flagSwitch;
    if (_flagSwitch) {
        self.flag.backgroundColor = [UIColor whiteColor];
    }else{
        self.flag.backgroundColor = [UIColor clearColor];
    }
}
- (void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
}
- (void)mineMapView:(nonnull MineMapView *)mineMapView tapViewIndex:(NSInteger)index roundMineNumber:(NSInteger)number {
    if (self.clickedBlcok) {
        self.clickedBlcok(index, number);
    }
}

@end

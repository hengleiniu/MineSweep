//
//  GameStartViewController.m
//  MineSweep
//
//  Created by BLIZZMI on 2019/7/15.
//  Copyright © 2019 BLIZZMI. All rights reserved.
//

#import "GameStartViewController.h"
#import "Masonry.h"
#import "MineMapView.h"
#import "MineMapModel.h"
#import "UIView+TYAlertView.h"
#import "GameCenterHelper.h"

#define Alert(msg,obj) TYAlertView *alertView = [TYAlertView alertViewWithTitle:@"Tips" message:msg];\
        alertView.layer.cornerRadius = 10;\
        [alertView addAction:[TYAlertAction actionWithTitle:@"Cancel" style:TYAlertActionStyleCancel handler:^(TYAlertAction *action) {\
        }]];\
        [alertView addAction:[TYAlertAction actionWithTitle:@"Again" style:TYAlertActionStyleDestructive handler:^(TYAlertAction *action) {\
            obj.flag.enabled = YES;\
            obj->mineMapArray = nil;\
            obj->appearacneArray = nil;\
            obj.turnoverArray = nil;\
            obj.tempWriteMineIndexArray = nil;\
            dispatch_async(dispatch_get_main_queue(), ^{\
                [obj createMineMap];\
                [obj reloadUI];\
                [obj timerInitial];\
            });\
            }]];\
        [alertView showInWindowWithOriginY:[UIScreen mainScreen].bounds.size.height/2 -  alertView.frame.size.height/2 - 64 backgoundTapDismissEnable:YES];\

#define iPhoneMinScreeen  [UIScreen mainScreen].bounds.size.width <= 320

@interface GameStartViewController ()<MineMapViewDelegate>{
    NSMutableArray *mineMapArray;
    NSMutableArray *appearacneArray;
    NSInteger _column;
    NSInteger _row;
    NSInteger _mineNUmber;
    NSInteger _padding;
    NSString *_titleName;
    NSString *_mapBackImageName;
    __block NSTimeInterval timeInterval;
    BOOL _flagSwitch;
}

@property (nonatomic, strong) UIImageView *backMineMapImageView;
@property (nonatomic, strong) NSMutableArray *turnoverArray;
@property (nonatomic, strong) NSMutableArray *tempWriteMineIndexArray;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UILabel *timerLabel;
@property (nonatomic, copy) NSString *numberPix;
@property (nonatomic, weak) UIButton *flag;
@property (nonatomic, assign) GameType gameType;
@property (nonatomic, assign) double achievement;
@property (nonatomic, copy) NSString *identifier;
@end

@implementation GameStartViewController

- (instancetype)initWithGameType:(GameType)gameType{

    if (self = [super init]) {
        self.gameType = gameType;
        _flagSwitch = NO;
        switch (gameType) {
            case 0:
            {
                self.achievement = 25;
                self.identifier = @"cn.com.blizzmi.MineSweep";
                [self setColumn:9 row:9 mineNumber:9 padding:5 titleName:@"s_SIMPLE" mapBackImageName:@"s_di" numberPix:@"s"];
            }
                break;
            case 1:
            {
                self.achievement = 50;
                self.identifier = @"cn.com.blizzmi.MineSweep.MEDIUM";
                [self setColumn:9 row:9 mineNumber:19 padding:5 titleName:@"s_MEDIUM" mapBackImageName:@"s_di" numberPix:@"s"];
            }
                break;
            case 2:
            {
                self.achievement = 75;
                self.identifier = @"cn.com.blizzmi.MineSweep.DIFFICULT";
                [self setColumn:16 row:16 mineNumber:39 padding:2.5 titleName:@"d_DIFFICULT" mapBackImageName:@"d_di" numberPix:@"d"];
            }
                break;
            case 3:
            {
                self.achievement = 100;
                self.identifier = @"cn.com.blizzmi.MineSweep.CHALLENGE";
                if (iPhoneMinScreeen) {
                     [self setColumn:30 row:16 mineNumber:99 padding:2 titleName:@"c_CHALLENGE" mapBackImageName:@"c_di" numberPix:@"c"];
                }else{
                     [self setColumn:30 row:16 mineNumber:99 padding:4 titleName:@"c_CHALLENGE" mapBackImageName:@"c_di" numberPix:@"c"];
                }
            }
               
                break;
            default:
                break;
        }
    }
    return self;
}
- (void)setColumn:(NSInteger)column row:(NSInteger)row mineNumber:(NSInteger)mineNumber padding:(NSInteger)padding titleName:(NSString *)titleName mapBackImageName:(NSString *)mapBackImageName numberPix:(NSString *)numberPix{
    _column = column;
    _row = row;
    _mineNUmber = mineNumber;
    _padding = padding;
    _titleName = titleName;
    _mapBackImageName = mapBackImageName;
    self.numberPix = numberPix;
}
- (NSMutableArray *)turnoverArray{
    if (!_turnoverArray) {
        _turnoverArray = [NSMutableArray array];
    }
    return _turnoverArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setNavigation];
    [self initialUI];
    [self createMineMap];
    //布置ui mineMapArray存储雷图 0-9 9为雷
    [self reloadUI];
    [self timerInitial];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)setNavigation{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"navigationback"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = item;
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
}
- (void)timerInitial{
    timeInterval = 0;
    __weak typeof(self) weakSelf = self;
    if (@available(iOS 10.0, *)) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            @autoreleasepool {
                strongSelf->timeInterval ++;
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:strongSelf->timeInterval];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"mm:ss"];
                NSString *dateString = [formatter stringFromDate:date];
                if ([dateString isEqualToString:@"99:99"]) {
                    strongSelf->timeInterval = 0;
                }
                strongSelf.timerLabel.text = dateString;
            }
        }];
    } else {
        // Fallback on earlier versions
    }
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];

}
- (void)initialUI{
    UIImageView *background = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    background.image = [UIImage imageNamed:@"s_cj"];
    [self.view addSubview:background];
    
    UIImageView *titleImage = [[UIImageView alloc] init];
    titleImage.image = [UIImage imageNamed:_titleName];
    [self.view addSubview:titleImage];
    
    UIImageView *lineView = [[UIImageView alloc] init];
    lineView.image = [UIImage imageNamed:@"s_x"];
    [self.view addSubview:lineView];
    
    UIImageView *alockImageView = [[UIImageView alloc] init];
    alockImageView.image = [UIImage imageNamed:@"s_djs"];
    [self.view addSubview:alockImageView];
    
    self.timerLabel = [[UILabel alloc] init];
    self.timerLabel.textColor = [UIColor whiteColor];
    self.timerLabel.backgroundColor = [UIColor clearColor];
    self.timerLabel.font = [UIFont boldSystemFontOfSize:26];
    self.timerLabel.text = @"00:00";
    [self.view addSubview:_timerLabel];
    
    UILabel *bulletLabel = [[UILabel alloc] init];
    bulletLabel.textColor = [UIColor whiteColor];
    bulletLabel.backgroundColor = [UIColor clearColor];
    bulletLabel.font = [UIFont boldSystemFontOfSize:26];
    bulletLabel.textAlignment = NSTextAlignmentRight;
    bulletLabel.text = [NSString stringWithFormat:@"%ld",(long)_mineNUmber];
    [self.view addSubview:bulletLabel];
    
    UIButton *flag = [[UIButton alloc] init];
    self.flag = flag;
    self.backMineMapImageView.userInteractionEnabled = YES;
    [flag setImage:[UIImage imageNamed:@"s_hq"] forState:UIControlStateNormal];
    [flag addTarget:self action:@selector(flatStyle) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:flag];
    
    UIImageView *bulletImage = [[UIImageView alloc] init];
    bulletImage.image = [UIImage imageNamed:@"zdan"];
    [self.view addSubview:bulletImage];
    
    self.backMineMapImageView = [[UIImageView alloc] init];
    self.backMineMapImageView.image = [UIImage imageNamed:_mapBackImageName];
    [self.view addSubview:self.backMineMapImageView];
    
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
        make.left.mas_equalTo(self.view).equalTo(@20);
        make.right.mas_equalTo(self.view).equalTo(@-20);
        make.height.mas_equalTo(@1.5);
    }];
    [alockImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        if ([self.numberPix isEqualToString:@"c"] || iPhoneMinScreeen) {
            make.top.mas_equalTo(lineView).equalTo(@15);
        }else{
            make.top.mas_equalTo(lineView).equalTo(@45);
        }
        make.left.mas_equalTo(self.view).equalTo(@30);
        make.width.mas_equalTo(@36);
        make.height.mas_equalTo(@39);
    }];
    [self.timerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).equalTo(@80);
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
        make.centerX.mas_equalTo(self.view.mas_centerX).mas_offset(@20);
    }];
    [bulletLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(alockImageView.mas_top).equalTo(@9);;
        make.right.mas_equalTo(self.view).equalTo(@-36);
        make.width.mas_equalTo(@50);
        make.height.mas_equalTo(@26);
    }];
    [bulletImage mas_makeConstraints:^(MASConstraintMaker *make) {
        if ([self.numberPix isEqualToString:@"c"] || iPhoneMinScreeen) {
            make.top.mas_equalTo(lineView).equalTo(@8);
        }else{
            make.top.mas_equalTo(lineView).equalTo(@38);
        }
        make.right.mas_equalTo(self.view).equalTo(@-63);
        make.width.mas_equalTo(@47);
        make.height.mas_equalTo(@48);
    }];
    [self.backMineMapImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        if ([self.numberPix isEqualToString:@"c"]) {
            make.top.mas_equalTo(alockImageView).equalTo(@45);
            make.left.mas_equalTo(self.view).equalTo(@30);
            make.right.mas_equalTo(self.view).equalTo(@-30);
            if (iPhoneMinScreeen) {
                 make.bottom.mas_equalTo(self.view).equalTo(@-8);
            }else{
                 make.bottom.mas_equalTo(self.view).equalTo(@-15);
            }
        }else{
            make.top.mas_equalTo(alockImageView).equalTo(@60);
            make.left.mas_equalTo(self.view).equalTo(@0);
            make.right.mas_equalTo(self.view).equalTo(@0);
            if (iPhoneMinScreeen) {
                make.height.mas_equalTo(@320);
            }else{
                make.height.mas_equalTo(@374);
            }
         
        }
    }];
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}
- (void)flatStyle{
    _flagSwitch = !_flagSwitch;
    if (_flagSwitch) {
        self.flag.backgroundColor = [UIColor whiteColor];
    }else{
        self.flag.backgroundColor = [UIColor clearColor];
    }
}
- (void)reloadUI{
    dispatch_queue_t queue = dispatch_queue_create("cn.com.blizzmi.minesweep", DISPATCH_QUEUE_CONCURRENT);
    dispatch_barrier_async(queue, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            for (int i = 0; i < self->_column * self->_row; i ++) {
                MineMapView *mineButton = [self->appearacneArray objectAtIndex:i];
                mineButton.number = [[self->mineMapArray objectAtIndex:i] integerValue];
            }
        });
    });
}

#pragma mark - 布雷逻辑
- (void)createMineMap{
    dispatch_queue_t queue = dispatch_queue_create("cn.com.blizzmi.minesweep", DISPATCH_QUEUE_CONCURRENT);
    NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:_mineNUmber];
    self.tempWriteMineIndexArray = tempArray;
    mineMapArray = [NSMutableArray arrayWithCapacity:_column*_row];
    appearacneArray = [NSMutableArray arrayWithCapacity:_column*_row];
    dispatch_async(queue, ^{
        for (int i = 0; i < self->_column * self->_row; i ++) {
            [self->mineMapArray addObject:@0];
        }
        // 雷随机分布
        for (int i = 0; i < self->_mineNUmber; i ++) {
            //雷的位置 0-9 9为雷
            NSInteger delIndex = arc4random() % (self->_column * self->_row - 1);
            while ([tempArray containsObject:@(delIndex)]) {
                delIndex = arc4random() % (self->_column * self->_row - 1);
            }
            [self->mineMapArray replaceObjectAtIndex:delIndex withObject:@(9)];
            [tempArray addObject:@(delIndex)];
        }
    });

    for (MineMapView *subMineView in self.backMineMapImageView.subviews) {
        [subMineView removeFromSuperview];
    }
        CGFloat x = 0;
        CGFloat y = 0;
        CGFloat w = (self.backMineMapImageView.frame.size.width - self->_padding*2)/self->_row;
        CGFloat h = (self.backMineMapImageView.frame.size.height - self->_padding*2)/self->_column;
        for (int i = 0; i < self->_row; i ++) {
            x = i*w + self->_padding;
            for (int j = 0; j < self->_column; j ++) {
                @autoreleasepool {
                    y = j*h + self->_padding;
                    MineMapView *buttonView = [[MineMapView alloc] initWithFrame:CGRectMake(x, y, w, h)];
                    buttonView.delegate = self;
                    buttonView.index = i * self->_column + j;
                    buttonView.numberPix = self.numberPix;
                    self.backMineMapImageView.userInteractionEnabled = YES;
                    [self.backMineMapImageView addSubview:buttonView];
                    [self->appearacneArray addObject:buttonView];
                }
            }
        }
    //布置雷层 temp存储地雷位置
    dispatch_barrier_async(queue, ^{
        for (NSNumber *obj in tempArray) {
            @autoreleasepool {
                NSInteger location = [obj integerValue];
                NSInteger aroundLocation;
                
                //上
                aroundLocation = location - self->_column;//上
                if (location / self->_column != 0) {
                    [self locationPlus:aroundLocation];
                }
                
                aroundLocation = location - self->_column + 1;//右上
                if (location / self->_column && location % self->_column != self->_column - 1) {
                    [self locationPlus:aroundLocation];
                }
                
                aroundLocation = location + 1;//右
                if (location % self->_column != self->_column - 1) {
                    [self locationPlus:aroundLocation];
                }
                
                aroundLocation = location + self->_column + 1;//右下
                if (location % self->_column != self->_column - 1 && location / self->_column != self->_row - 1) {
                    [self locationPlus:aroundLocation];
                }
                
                aroundLocation = location + self->_column;//下
                if (location / self->_column != self->_row - 1) {
                    [self locationPlus:aroundLocation];
                }
                
                aroundLocation = location + self->_column - 1;//左下
                if (location / self->_column != self->_row - 1 && location % self->_column != 0) {
                    [self locationPlus:aroundLocation];
                }
                
                aroundLocation = location - 1;//左
                if (location % self->_column != 0) {
                    [self locationPlus:aroundLocation];
                }
                
                aroundLocation = location - self->_column - 1;//左上
                if (location / self->_column != 0 && location % self->_column != 0) {
                    [self locationPlus:aroundLocation];
                }
            }
           
        }
    });
    
}
- (void)locationPlus:(NSInteger)location {
    NSInteger cellMineNums = [[mineMapArray objectAtIndex:location] integerValue];
    if (cellMineNums != 9) {
        cellMineNums++;
    }
    [mineMapArray replaceObjectAtIndex:location withObject:@(cellMineNums)];
}

#pragma mark - delegate
- (void)mineMapView:(MineMapView *)mineMapView tapViewIndex:(NSInteger)index roundMineNumber:(NSInteger)number{
    if (_flagSwitch) {
        MineMapView *view = [appearacneArray objectAtIndex:index];
        view.flagStyle = !view.flagStyle;
    }else{ 
        
        [self willTurnOverImageViewAtLocation:index andRoundNumber:number];
        [self turnOverImageView];
    }
}

#pragma mark 扫雷逻辑
- (void)willTurnOverImageViewAtLocation:(NSInteger)location andRoundNumber:(NSInteger)number{
    if (number == 0) {
        //空
        [self findAllTurnover:location];
    }else if (number == 9) {
        //雷
        if (![self.turnoverArray containsObject:@(location)]) {
            [self.turnoverArray addObjectsFromArray:self.tempWriteMineIndexArray];
        }
        self.backMineMapImageView.userInteractionEnabled = NO;
        [self.timer invalidate];
        self.flag.enabled = NO;
        Alert(@"Sorry, you failed! Challenge again, you can do it!", self);
    }else{
        //数字
        if (![self.turnoverArray containsObject:@(location)]) {
            [self.turnoverArray addObject:@(location)];
        }
    }
}
- (void)findAllTurnover:(NSInteger)location {
    
    if (![self.turnoverArray containsObject:@(location)]) {
        [self.turnoverArray addObject:@(location)];
    }
    if ([mineMapArray[location] integerValue] != 0) {
        return;
    }
    
    NSInteger aroundLocation;
    aroundLocation = location - _column - 1;//左上
    if (location / _column != 0 && location % _column != 0) {
        [self addTurnover:aroundLocation];
    }
    
    aroundLocation = location - _column;//上
    if (location / _column != 0) {
        [self addTurnover:aroundLocation];
    }
    
    aroundLocation = location - _column + 1;//右上
    if (location / _column && location % _column != _column - 1) {
        [self addTurnover:aroundLocation];
    }
    
    aroundLocation = location + 1;//右
    if (location % _column != _column - 1) {
        if (aroundLocation < _column * _row) {
            [self addTurnover:aroundLocation];
        }
    }
    
    aroundLocation = location + _column + 1;//右下
    if (location % _column != _column - 1 && location / _column != _column - 1) {
        if (aroundLocation < _column * _row) {
            [self addTurnover:aroundLocation];
        }
    }
    
    aroundLocation = location + _column;//下
    if (location / _column != _column - 1) {
        if (aroundLocation < _column*_row) {
            [self addTurnover:aroundLocation];
        }
    }
    
    aroundLocation = location + _column - 1;//左下
    if (location / _column != _column - 1 && location % _column != 0) {
        if (aroundLocation < _row * _column) {
            [self addTurnover:aroundLocation];
        }
    }
    
    aroundLocation = location - 1;//左
    if (location % _column != 0) {
        [self addTurnover:aroundLocation];
    }
    
}
- (void)addTurnover:(NSInteger)location {
    if ([self.turnoverArray containsObject:@(location)]) {
        return;
    }
    [self.turnoverArray addObject:@(location)];
    [self findAllTurnover:location];
}
- (void)turnOverImageView{
    [self.turnoverArray enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger index = [obj integerValue];
        MineMapView *view = [self->appearacneArray objectAtIndex:index];
        if (!view.flagStyle) {
            view.appeareImageView.image = nil;
            view.userInteractionEnabled = NO;
        }else{
            [self.turnoverArray removeObjectAtIndex:idx];
        }
    }];

    if (self.turnoverArray.count == _column * _row - _mineNUmber) {
        [self.timer invalidate];
        self.backMineMapImageView.userInteractionEnabled = NO;
        [[GameCenterHelper shareGameCenterHelper] saveHighScore:(int64_t)timeInterval identifier:self.identifier];
        [[GameCenterHelper shareGameCenterHelper] uploadAchievmentWithComplete:self.achievement identifier:self.identifier];
        Alert(@"It's too awesome! Challenge the more difficult ones.", self);
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

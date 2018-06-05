//
//  ShanNianVoiceSetViewController.h
//  CutImageForYou
//
//  Created by chenxi on 2018/6/5.
//  Copyright © 2018 chenxi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SAMultisectorControl.h"
#import "AKPickerView.h"
#import "IFlyMSC/IFlyMSC.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShanNianVoiceSetViewController : UIViewController<AKPickerViewDataSource,AKPickerViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic ,strong)SAMultisectorControl *roundSlider;
@property (nonatomic ,strong)UIScrollView *backScrollView;

@property (strong, nonatomic)  UILabel *recTimeoutLabel;
@property (strong, nonatomic)  UILabel *bosLabel;
@property (strong, nonatomic)  UILabel *eosLabel;

@property (strong, nonatomic)  AKPickerView *accentPicker;

@property (strong, nonatomic)  UISegmentedControl *dotSeg;
@property (strong, nonatomic)  UISegmentedControl *transSeg;
@property (strong, nonatomic)  UISegmentedControl *viewSeg;

@property (strong, nonatomic)  UITableView *tableView;;


@end

NS_ASSUME_NONNULL_END

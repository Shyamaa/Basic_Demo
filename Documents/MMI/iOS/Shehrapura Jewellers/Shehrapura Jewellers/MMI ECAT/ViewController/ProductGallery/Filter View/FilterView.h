//
//  FilterView.h
//  Swiz Gold and Diamonds
//
//  Created by MMI Softwares Pvt Ltd on 16/05/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IARangeSlider.h"
#import "UITextField+PickerWithSearch.h"

@interface FilterView : UIView <UITextFieldDelegate>

@property (nonatomic, copy) void (^onCloseTapped)(NSArray*,Boolean);

@property (strong, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) IBOutlet UITextField *txtGrossWtFrom;
@property (strong, nonatomic) IBOutlet UITextField *txtGrossWtTo;

@property (strong, nonatomic) IBOutlet UITextField *txtNetWtFrom;
@property (strong, nonatomic) IBOutlet UITextField *txtNetWtTo;

@property (strong, nonatomic) IBOutlet UITextField *txtDiaWtFrom;
@property (strong, nonatomic) IBOutlet UITextField *txtDiaWtTo;

@property (strong, nonatomic) IBOutlet UITextField *txtSaleMrpFrom;
@property (strong, nonatomic) IBOutlet UITextField *txtSaleMrpTo;

@property (strong, nonatomic) IBOutlet UITextField *txtStnWtFrom;
@property (strong, nonatomic) IBOutlet UITextField *txtStnWtTo;

@property (strong, nonatomic) IBOutlet UITextField *txtSelectTagNo;
@property (strong, nonatomic) IBOutlet UITextField *txtDesignNo;
@property (strong, nonatomic) IBOutlet UITextField *txtStatus;
@property (strong, nonatomic) IBOutlet UITextField *txtStamp;
@property (strong, nonatomic) IBOutlet UITextField *txtSize;

@property (strong, nonatomic) IBOutlet UITextField *txtKarigar;
@property (strong, nonatomic) IBOutlet UITextField *txtQuality;
@property (strong, nonatomic) IBOutlet UITextField *txtSite;
@property (strong, nonatomic) IBOutlet UITextField *txtGCode;
@property (strong, nonatomic) IBOutlet UITextField *txtTagNo;
@property (strong, nonatomic) IBOutlet UITextField *txtTgStart;
@property (strong, nonatomic) IBOutlet UITextField *txtTgEnd;

@property (strong, nonatomic) IBOutlet UIStackView *stackViewGrossWt;
@property (strong, nonatomic) IBOutlet UIStackView *stackViewNetWt;
@property (strong, nonatomic) IBOutlet UIStackView *stackViewDiaWt;
@property (strong, nonatomic) IBOutlet UIStackView *stackViewSaleMrp;
@property (strong, nonatomic) IBOutlet UIStackView *stackViewStnWt;

@property (strong, nonatomic) IBOutlet UIStackView *stackViewSelectTagNo;
@property (strong, nonatomic) IBOutlet UIStackView *stackViewDesignNo;
@property (strong, nonatomic) IBOutlet UIStackView *stackViewStatus;
@property (strong, nonatomic) IBOutlet UIStackView *stackViewStamp;
@property (strong, nonatomic) IBOutlet UIStackView *stackViewSize;
@property (strong, nonatomic) IBOutlet UIStackView *stackViewKarigar;
@property (strong, nonatomic) IBOutlet UIStackView *stackViewQuality;
@property (strong, nonatomic) IBOutlet UIStackView *stackViewSite;
@property (strong, nonatomic) IBOutlet UIStackView *stackViewGCode;
@property (strong, nonatomic) IBOutlet UIStackView *stackViewTagNo;

@property (strong, nonatomic) IBOutlet UIView *viewGrossWt;
@property (strong, nonatomic) IBOutlet UIView *viewNetWt;
@property (strong, nonatomic) IBOutlet UIView *viewDiaWt;
@property (strong, nonatomic) IBOutlet UIView *viewSaleMrp;
@property (strong, nonatomic) IBOutlet UIView *viewStnWt;

@property (strong, nonatomic) IARangeSlider* rangeSliderGross;
@property (strong, nonatomic) IARangeSlider* rangeSliderNet;
@property (strong, nonatomic) IARangeSlider* rangeSliderDia;
@property (strong, nonatomic) IARangeSlider* rangeSliderSaleMrp;
@property (strong, nonatomic) IARangeSlider* rangeSliderStn;

@property (strong, nonatomic) NSArray *arrayListData;

- (void)setupWithArray:(NSArray *)arrayTagNo design:(NSArray *)arrayDesignNo status:(NSArray *)arrayStatus stamp:(NSArray *)arrayStamp size:(NSArray *)arraySize listData:(NSArray *)arraylistData karigarData:(NSArray *)arrayKarigarList qualityList:(NSArray *)arrayQualityList siteList:(NSArray *)arraySiteList gCodeList:(NSArray *)arrayGCodeList;

@end

//
//  AddDemand.h
//  Jwelly Customer
//
//  Created by mmsoft116 on 10/10/20.
//  Copyright © 2020 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextField.h"
#import "CustomerVisitFormVC.h"
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddDemand : BaseViewController<UITextFieldDelegate,UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CutomerDataDelegate>{
    UIImageView * img_item;
    
    NSMutableArray * array_lbron;
    NSMutableArray * array_stamp;
    NSMutableArray * array_item;
    NSMutableArray * array_KarigarNameList;
    NSMutableArray * array_SalesNameList;

    UIViewController *controller_lbron;
    UITableView *table_lbron;
    UIAlertController *ac_tyep;
    
    UIViewController *controller_stamp;
    UITableView *table_stamp;
    
    UIViewController *controller_item;
    UITableView *table_item;
    NSString * str_cpid;
    NSString * str_cname;
}
@property (strong, nonatomic) UIImageView *selectedImageView;
@property (strong, nonatomic) NSMutableArray *imagesArray;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;;
@property (nonatomic, strong) IBOutlet UICollectionView *bannerCollectionView;
@property (nonatomic, strong) IBOutlet UITextField *txtKarigarName;
@property (nonatomic, strong) IBOutlet UITextField *txtSalesmanName;
@property (nonatomic, strong) IBOutlet UITextField *txtCustomerName;
@property (nonatomic, strong) IBOutlet UITextField *txtItemName;
@property (nonatomic, strong) IBOutlet UITextField *txtOtherName;
@property (nonatomic, strong) IBOutlet UITextField *txtWeight;
@property (nonatomic, strong) IBOutlet UITextField *txtPieces;
@property (nonatomic, strong) IBOutlet UITextField *txtSelectStamp;

@property (nonatomic, strong) IBOutlet UITextField *txtTuch;
@property (nonatomic, strong) IBOutlet UITextField *txtWstg;
@property (nonatomic, strong) IBOutlet UITextField *txtFine;
@property (nonatomic, strong) IBOutlet UITextField *txtRate;
@property (nonatomic, strong) IBOutlet UITextField *txtLBR;
@property (nonatomic, strong) IBOutlet UITextField *txtSelectGrWt;
@property (nonatomic, strong) IBOutlet UITextField *txtSize;
@property (nonatomic, strong) IBOutlet UITextField *txtDueDate;

@property (nonatomic, strong) IBOutlet UITextField *txtAdvanceAmount;
@property (nonatomic, strong) IBOutlet UITextField *txtDescription1;
@property (nonatomic, strong) IBOutlet UITextField *txtDescription2;

@property (nonatomic, strong) IBOutlet UIView *viewCustomerName;
@property (nonatomic, strong) IBOutlet UIView *viewKarigarName;
@property (nonatomic, strong) IBOutlet UIView *viewSalesmanName;
@property (nonatomic, strong) IBOutlet UIView *viewWstg;
@property (nonatomic, strong) IBOutlet UIView *viewLbr;
@property (nonatomic, strong) IBOutlet UIView *viewOption;
@property (nonatomic, strong) IBOutlet UIView *viewOtherName;

@property (nonatomic, strong) IBOutlet UIView *viewDueDate;
@property (nonatomic, strong) IBOutlet UIView *viewAmount;

@property (nonatomic, strong) IBOutlet UILabel *lblCustomerName;

@property (nonatomic, strong) IBOutlet UIButton *btnColour;
@property (nonatomic, strong) IBOutlet UIButton *btnStones;
@property (nonatomic, strong) IBOutlet UIButton *btnMina;

@property (nonatomic, strong) NSString *str_Activity;

@property (nonatomic, strong) NSString *str_orderno;
@property (nonatomic, assign) BOOL isSideMenu;
@end

NS_ASSUME_NONNULL_END

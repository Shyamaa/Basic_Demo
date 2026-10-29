//
//  CustomerVisit.h
//  MMI ECAT
//
//  Created by MMI SOFTWARES PVT LTD on 12/12/20.
//  Copyright © 2020 MMI Softwares. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "CustomerVisitFormVC.h"

NS_ASSUME_NONNULL_BEGIN
@interface CustomerVisit :BaseViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate, CutomerDataDelegate, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    UIScrollView *scroll;
    IBOutlet UITextField *txt_tagno;
    IBOutlet UIButton *btn_Manual;
    IBOutlet UIButton *btn_Automation;
    IBOutlet UIButton *btn_search;
    IBOutlet UILabel *lbl_name;
    IBOutlet UILabel *lbl_mobile;
    IBOutlet UILabel *lbl_item;
    IBOutlet UILabel *lbl_wt;
    IBOutlet UILabel *lbl_pc;
    IBOutlet UILabel *lbl_Gwt;
    IBOutlet UILabel *lbl_Fine;
    IBOutlet UILabel *lbl_mrp;
    NSMutableArray *master_arrayData;
    NSMutableArray *nsarray_data;
    NSMutableArray *nsarray_qty;
    NSMutableArray *array_selectedItemList;
    
    UIView * paintView;
    UITextField *mytext_contact;
    UITextField *mytext_partyname;
    UITextField *mytext_address;
    UITextField *mytext_address2;
    UITextField *mytext_address3;
    UITextField *mytext_location;
    UITextField *mytext_city;
    UITextField *mytext_email;
    UITextField *mytext_contact2;
    NSString *str_cpid;
}

@property(weak,nonatomic)IBOutlet NSString *str_act;

- (IBAction)btn_search:(id)sender;
- (IBAction)btn_placeorder:(id)sender;
- (IBAction)btn_clear:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *txtSearchBar;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end

NS_ASSUME_NONNULL_END

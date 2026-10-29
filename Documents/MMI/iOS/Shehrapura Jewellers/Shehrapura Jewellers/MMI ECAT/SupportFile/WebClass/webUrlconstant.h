//
//  webUrlconstant.h
//  MyWolet
//
//  Created by MMI SOFTWARES on 07/10/14.
//  Copyright (c) 2014 Metanest. All rights reserved.
//

#import <Foundation/Foundation.h>
#define BASEURL_GETCURRENTMARKETRATE @"http://starlinetechno.com/MMISoftwaresPvtLtd/jsonMMISoftwares.aspx"


@interface webUrlconstant : NSObject
@property (nonatomic, strong) NSString *APPTYPE;
@property (nonatomic, strong) NSString *APPTYPE_MCX;

@property (nonatomic, strong) NSString *URL_CHECK_MOBILE_SWID;
@property (nonatomic, strong) NSString *URL_CONFIRM_PIN_SWID;
@property (nonatomic, strong) NSString *URL_CONFIG_UPDATE;
@property (nonatomic, strong) NSString *URL_GET_USERS;
@property (nonatomic, strong) NSString *URL_DELETE_USER;
@property (nonatomic, strong) NSString *URL_GET_DB;
@property (nonatomic, strong) NSString *URL_CHECK_USER;
@property (nonatomic, strong) NSString *URL_USER_PERMISSION;
@property (nonatomic, strong) NSString *URL_REGISTER_DEMO;
@property (nonatomic, strong) NSString *URL_REGISTER_CONFIRM_DEMO;


@property (nonatomic, strong) NSString *URL_SIGNUP;
@property (nonatomic, strong) NSString *URL_CATEGORY;
@property (nonatomic, strong) NSString *URL_GET_ITEM;
@property (nonatomic, strong) NSString *URL_ITEMLIST;
@property (nonatomic, strong) NSString *URL_INSERT_CART;
@property (nonatomic, strong) NSString *URL_CHECK_MOBILE;
@property (nonatomic, strong) NSString *URL_CONFIRM_PIN;
@property (nonatomic, strong) NSString *URL_AGENT_LOGIN;
@property (nonatomic, strong) NSString *URL_USERDETAIL;
@property (nonatomic, strong) NSString *URL_ITEMSHOW;
@property (nonatomic, strong) NSString *URL_MAIN_URL;

@property (nonatomic, strong) NSString *URL_HOME;
@property (nonatomic, strong) NSString *URL_PRODUCT_GALLERY;
@property (nonatomic, strong) NSString *URL_PRODUCT_GALLERY1;
@property (nonatomic, strong) NSString *URL_PRODUCT_GROUP;
@property (nonatomic, strong) NSString *URL_SINGLE_ITEM;
@property (nonatomic, strong) NSString *URL_INSERT_ITEM;
@property (nonatomic, strong) NSString *URL_GET_CART;
@property (nonatomic, strong) NSString *URL_CLEARCART;
@property (nonatomic, strong) NSString *URL_SAVE_CART;
@property (nonatomic, strong) NSString *URL_SHOW_ORDER;
@property (nonatomic, strong) NSString *URL_SHOW_ORDERDETAILS;
@property (nonatomic, strong) NSString *URL_ABOUT;
@property (nonatomic, strong) NSString *URL_DELETE;
@property (nonatomic, strong) NSString *URL_Order_DELETE;
@property (nonatomic, strong) NSString *URL_Delete_CART_Item;
@property (nonatomic, strong) NSString *URL_COUNTER;
@property (nonatomic, strong) NSString *URL_FEEDBACK;
@property (nonatomic, strong) NSString *URL_SETDESIGNDATA;
@property (nonatomic, strong) NSString *URL_STUDD;
@property (nonatomic, strong) NSString *URL_FDEMAND;
@property (nonatomic, strong) NSString *URL_UPDATECTIME;
@property (nonatomic, strong) NSString *myVariable;
@property (nonatomic, strong) NSString *URL_Idemand;
@property (nonatomic, strong) NSString *URL_GET_SelCustomer;
@property (nonatomic, strong) NSString *URL_DITEM;
@property (nonatomic, strong) NSString *URL_GET_CelCategory;
@property (nonatomic, strong) NSString *URL_CONTACTUS;
@property (nonatomic, strong) NSString *URL_REFERENSE;
@property (nonatomic, strong) NSString *URL_NOTIFICATION;
@property (nonatomic, strong) NSString *URL_INSERT_ITEMTAG;
@property (nonatomic, strong) NSString *URL_ORDERSOFTWARES;
@property (nonatomic, strong) NSString *URL_REPAIRSOFTWARES;

@property (nonatomic, strong) NSString *URL_KITTY_LEDGER;
@property (nonatomic, strong) NSString *URL_KITTY_DESC;
@property (nonatomic, strong) NSString *URL_MEMBERPOINT;
@property (nonatomic, strong) NSString *URL_MEMBERS;
@property (nonatomic, strong) NSString *URL_GET_BROCHURES;
@property (nonatomic, strong) NSString *URL_MCX_BADLA;
@property (nonatomic, strong) NSString *URL_COMPANY_DETAIL;
@property (nonatomic, strong) NSString *URL_GET_CATEGORY1;
@property (nonatomic, strong) NSString *URL_SAVE_CATEGORY;
@property (nonatomic, strong) NSString *URL_GET_DESIGN;
@property (nonatomic, strong) NSString *URL_INSERT_MEMBERS;
@property (nonatomic, strong) NSString *URL_GET_MEMBERS;
@property (nonatomic, strong) NSString *URL_GET_TODAYBHAV;
@property (nonatomic, strong) NSString *URL_GET_UNDELIVERED;
@property (nonatomic, strong) NSString *URL_GET_UNDEL_DETAIL;
@property (nonatomic, strong) NSString *URL_INSERT_ITRNDEL;
@property (nonatomic, strong) NSString *URL_SAVE_ITEM;
@property (nonatomic, strong) NSString *URL_OUTSTAND;
@property (nonatomic, strong) NSString *URL_GETOUT;
@property (nonatomic, strong) NSString *URL_INSERT_TODO;
@property (nonatomic, strong) NSString *URL_INSERT_PAY;
@property (nonatomic, strong) NSString *URL_HOMEAPI;
@property (nonatomic, strong) NSString *URL_TODAYRATE;
@property (nonatomic, strong) NSString *URL_KITTY_LIST;
@property (nonatomic, strong) NSString *URL_KITTY_TRAN;
@property (nonatomic, strong) NSString *URL_CHECK_TODAYRATE;
@property (nonatomic, strong) NSString *URL_GET_MEMBERLIST;
@property (nonatomic, strong) NSString *URL_UDPATE_MEMBER;
@property (nonatomic, strong) NSString *URL_SAVE_COMPANY;
@property (nonatomic, strong) NSString *URL_GET_VISIT_ITEM;
@property (nonatomic, strong) NSString *URL_GET_STAMP;
@property (nonatomic, strong) NSString *URL_INSERT_FEED;
@property (nonatomic, strong) NSString *URL_UPDATE_CARTITEM;
@property (nonatomic, strong) NSString *URL_UPDATE_VISITQR;
@property (nonatomic, strong) NSString *URL_GET_CART_VISIT;
@property (nonatomic, strong) NSString *URL_SHARE_PDF;
@property (nonatomic, strong) NSString *URL_GET_CPVDET;
@property (nonatomic, strong) NSString *URL_GET_ACNAME;
@property (nonatomic, strong) NSString *URL_DELETE_ALL_ORDER;
@property (nonatomic, strong) NSString *URL_UPDATE_CART_LBR;
@property (nonatomic, strong) NSString *URL_INSERT_ITEMQR;

@property (nonatomic, strong) NSString *URL_DELETE_TGNO;
@property (nonatomic, strong) NSString *URL_Active_TGNO;
@property (nonatomic, strong) NSString *URL_DELETE_USER1;
@property (nonatomic, strong) NSString *URL_GET_CAT_GROUP;
@property (nonatomic, strong) NSString *URL_DELETE_IDESC;
@property (nonatomic, strong) NSString *URL_SAVE_BANNER_IOS;
@property (nonatomic, strong) NSString *URL_SAVE_DEMAND_IOS;
@property (nonatomic, strong) NSString *URL_FEEDITEM;

@property (nonatomic, strong) NSString *URL_GET_KarigarNames;
@property (nonatomic, strong) NSString *URL_GET_SalesmanNames;
@property (nonatomic, strong) NSString *URL_GET_OrderRegister;

@property (nonatomic, strong) NSString *URL_GET_KittyallList;
@property (nonatomic, strong) NSString *URL_GET_Kittran;
@property (nonatomic, strong) NSString *URL_GET_Kittydet;
@property (nonatomic, strong) NSString *URL_GET_KittyPaymentMode;
@property (nonatomic, strong) NSString *URL_GET_KittyInsertPayment;

@property (nonatomic, strong) NSString *URL_GET_KittyGroupList;
@property (nonatomic, strong) NSString *URL_GET_KittyInstallList;
@property (nonatomic, strong) NSString *URL_GET_KittyCityList;
@property (nonatomic, strong) NSString *URL_Save_Kitty;
@property (nonatomic, strong) NSString *URL_GET_Reason;
@property (nonatomic, strong) NSString *URL_GET_ECATID;
@property (nonatomic, strong) NSString *URL_GET_SITE;
@property (nonatomic, strong) NSString *URL_SAVE_SITEACCESS;

@property (nonatomic, strong) NSString *URL_GET_VISITITEM;
@property (nonatomic, strong) NSString *URL_INSERT_CPVDET;
@property (nonatomic, strong) NSString *URL_GET_All_IDESC;
@property (nonatomic, strong) NSString *URL_UPDATE_CARTTUNCH;
@property (nonatomic, strong) NSString *URL_UpdateRazorPayment;
@property (nonatomic, strong) NSString *URL_ItemFilter;
@property (nonatomic, strong) NSString *URL_ItemFilter4;
@property (nonatomic, strong) NSString *URL_ItemFilterRecord;

@property (nonatomic, strong) NSString *URL_SaveAboutUs;
@property (nonatomic, strong) NSString *URL_SaveCompanyDetails;
@property (nonatomic, strong) NSString *URL_ActiveIdesc;
@property (nonatomic, strong) NSString *URL_UpLoadImage;
@property (nonatomic, strong) NSString *URL_RazorPayOrderId;
@property (nonatomic, strong) NSString *URL_Register_config;
@property (nonatomic, strong) NSString *URL_Upload_Logo;
@property (nonatomic, strong) NSString *URL_Insert_Set_Design;
@property (nonatomic, strong) NSString *URL_Insert_Studd;
@property (nonatomic, strong) NSString *URL_GetSTUDDList;
@property (nonatomic, strong) NSString *URL_GetDESIGNDATAList;
@property (nonatomic, strong) NSString *URL_Get_Separate_Pdf;

@property (nonatomic, strong) NSString *URL_SHOW_LEDGER;
@property (nonatomic, strong) NSString *URL_SHOW_LEDGER_DETAILS;

@property (nonatomic, strong) NSString *URL_GetAlertManagementList;
@property (nonatomic, strong) NSString *URL_GetAreaList;
@property (nonatomic, strong) NSString *URL_SendAlerts;
@property (nonatomic, strong) NSString *URL_Insert_ContactUs;
@property (nonatomic, strong) NSString *URL_Get_physicalstock;
@property (nonatomic, strong) NSString *URL_Get_PScanid;
@property (nonatomic, strong) NSString *URL_Get_CPName;
@property (nonatomic, strong) NSString *URL_Insert_tagcalculator;
@property (nonatomic, strong) NSString *URL_GET_Fillgrid;
@property (nonatomic, strong) NSString *URL_GET_Fcustomer;
@property (nonatomic, strong) NSString *URL_GET_FltCategory;
@property (nonatomic, strong) NSString *URL_SaveTag;
@property (nonatomic, strong) NSString *URL_Get_Feedback;
@property (nonatomic, strong) NSString *URL_Reply_Feedback;
@property (nonatomic, strong) NSString *URL_Delete_Feedback;
@property (nonatomic, strong) NSString *URL_Show_Cart;
@property (nonatomic, strong) NSString *URL_Physical_Item;
@property (nonatomic, strong) NSString *URL_Insert_Physical;
@property (nonatomic, strong) NSString *URL_SHOW_ORDER_COMPLETE;
@property (nonatomic, strong) NSString *URL_SHOW_ORDERD_DELETE;

+ (id)sharedInstance;
- (NSString *)getMainUrl;
+ (void)getAPIWithApiName:(NSString *)apiName
              type:(NSString *)type
               completion:(void (^)(NSDictionary *response, NSError *error))completion;

@end

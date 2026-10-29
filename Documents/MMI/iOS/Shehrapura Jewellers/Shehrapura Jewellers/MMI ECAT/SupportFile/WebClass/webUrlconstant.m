//
//  webUrlconstant.m
//  MyWolet
//
//  Created by Suresh Kumar on 07/10/14.
//  Copyright (c) 2014 MMI. All rights reserved.

#import "webUrlconstant.h"

@implementation webUrlconstant {
    NSString *MainUrl;
    NSString *SERVER_URL_SOFTWAREKEY;
}

+ (id)sharedInstance {
    static webUrlconstant *sharedClassA = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedClassA = [[self alloc] init];
        sharedClassA->MainUrl = @"http://sherpura.theappvisions.com/apps/jwellyecat1/";
        sharedClassA->SERVER_URL_SOFTWAREKEY = @"https://www.mmisoftwares.com/softwarekey/";
        [sharedClassA setAPPTYPE:[NSString stringWithFormat:@"3"]];
        [sharedClassA setAPPTYPE_MCX:[NSString stringWithFormat:@"0"]];
        [sharedClassA setURL_CHECK_MOBILE_SWID:[NSString stringWithFormat:@"%@register_device.php", sharedClassA->SERVER_URL_SOFTWAREKEY]];
        [sharedClassA setURL_CONFIRM_PIN_SWID:[NSString stringWithFormat:@"%@jwellyecat/check_pin.php", sharedClassA->SERVER_URL_SOFTWAREKEY]];
        [sharedClassA setURL_CONFIG_UPDATE:[NSString stringWithFormat:@"%@jwellyecat/update_db.php", sharedClassA->SERVER_URL_SOFTWAREKEY]];
        [sharedClassA setURL_GET_USERS:[NSString stringWithFormat:@"%@jwellyecat/get_users.php", sharedClassA->SERVER_URL_SOFTWAREKEY]];
        [sharedClassA setURL_DELETE_USER:[NSString stringWithFormat:@"%@jwellyecat/delete_user.php", sharedClassA->SERVER_URL_SOFTWAREKEY]];
        [sharedClassA setURL_GET_DB:[NSString stringWithFormat:@"%@jwellyecat/get_db.php", sharedClassA->SERVER_URL_SOFTWAREKEY]];
        [sharedClassA setURL_CHECK_USER:[NSString stringWithFormat:@"%@jwellyecat/check_user.php", sharedClassA->SERVER_URL_SOFTWAREKEY]];
        [sharedClassA setURL_USER_PERMISSION:[NSString stringWithFormat:@"%@jwellyecat/user_permission.php", sharedClassA->SERVER_URL_SOFTWAREKEY]];
        [sharedClassA setURL_REGISTER_DEMO:[NSString stringWithFormat:@"%@jwellyecat/registerdemo.php", sharedClassA->SERVER_URL_SOFTWAREKEY]];
        [sharedClassA setURL_REGISTER_CONFIRM_DEMO:[NSString stringWithFormat:@"%@jwellyecat/check_demo.php", sharedClassA->SERVER_URL_SOFTWAREKEY]];
        [sharedClassA setURL_GET_ECATID:[NSString stringWithFormat:@"%@jwellyecat/get_ecatid.php", sharedClassA->SERVER_URL_SOFTWAREKEY]];
        
        [sharedClassA setURL_SIGNUP:[NSString stringWithFormat:@"%@register.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_CATEGORY:[NSString stringWithFormat:@"%@get_category.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_GET_ITEM:[NSString stringWithFormat:@"%@get_itemlist.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_ITEMLIST:[NSString stringWithFormat:@"%@get_productlist.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_INSERT_CART:[NSString stringWithFormat:@"%@insert_cart.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_CHECK_MOBILE:[NSString stringWithFormat:@"%@check_mobile.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_CONFIRM_PIN:[NSString stringWithFormat:@"%@pin_confirm.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_AGENT_LOGIN:[NSString stringWithFormat:@"%@login_agent.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_USERDETAIL:[NSString stringWithFormat:@"%@get_userdetails.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_ITEMSHOW:[NSString stringWithFormat:@"%@get_itemshow.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_MAIN_URL:[NSString stringWithFormat:@"%@get_main.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_HOME:[NSString stringWithFormat:@"%@get_home.php", sharedClassA->MainUrl]];
        
        [sharedClassA setURL_PRODUCT_GALLERY:[NSString stringWithFormat:@"%@getproductgallery.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_PRODUCT_GALLERY1:[NSString stringWithFormat:@"%@getproductgallery1.php", sharedClassA->MainUrl]];
        
        [sharedClassA setURL_PRODUCT_GROUP:[NSString stringWithFormat:@"%@getpoductgroup.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_SINGLE_ITEM:[NSString stringWithFormat:@"%@get_items_android.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_INSERT_ITEM:[NSString stringWithFormat:@"%@insert_singleitem_android.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_GET_CART:[NSString stringWithFormat:@"%@get_cart_record.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_CLEARCART:[NSString stringWithFormat:@"%@clear_cart.php", sharedClassA->MainUrl]];
        //[sharedClassA setURL_SAVE_CART:[NSString stringWithFormat:@"%@insert_order_ios1.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_SAVE_CART:[NSString stringWithFormat:@"%@insert_order.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_SHOW_ORDER:[NSString stringWithFormat:@"%@show_orderno.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_SHOW_ORDERDETAILS:[NSString stringWithFormat:@"%@show_orderno_item.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_ABOUT:[NSString stringWithFormat:@"%@get_menudetails.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_DELETE:[NSString stringWithFormat:@"%@delete_single_item.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_Order_DELETE:[NSString stringWithFormat:@"%@delete_order_ecat.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_Insert_tagcalculator:[NSString stringWithFormat:@"%@insert_tagcalculator.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_COUNTER:[NSString stringWithFormat:@"%@counter.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_FEEDBACK:[NSString stringWithFormat:@"%@feedback.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_SETDESIGNDATA:[NSString stringWithFormat:@"%@get_setdesigndata.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_STUDD:[NSString stringWithFormat:@"%@get_studddata.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_GetSTUDDList:[NSString stringWithFormat:@"%@get_studd.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_GetDESIGNDATAList:[NSString stringWithFormat:@"%@get_setdesign.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_FDEMAND:[NSString stringWithFormat:@"%@fdemand.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_UPDATECTIME:[NSString stringWithFormat:@"%@update_ctime.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_Idemand:[NSString stringWithFormat:@"%@idemand.php", sharedClassA->MainUrl]];
        
        [sharedClassA setURL_GET_SelCustomer:[NSString stringWithFormat:@"%@selcustomer.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_DITEM:[NSString stringWithFormat:@"%@get_ditem.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_GET_CelCategory:[NSString stringWithFormat:@"%@selcategory.php", sharedClassA->MainUrl]];
        
        [sharedClassA setURL_CONTACTUS:[NSString stringWithFormat:@"%@get_contactus.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_REFERENSE:[NSString stringWithFormat:@"%@reference.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_NOTIFICATION:[NSString stringWithFormat:@"%@get_alerts.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_INSERT_ITEMTAG:[NSString stringWithFormat:@"%@insert_itemtag.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_ORDERSOFTWARES:[NSString stringWithFormat:@"%@order.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_REPAIRSOFTWARES:[NSString stringWithFormat:@"%@repair.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_KITTY_LEDGER:[NSString stringWithFormat:@"%@kittyledger.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_KITTY_DESC:[NSString stringWithFormat:@"%@kittyDesc.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_MEMBERPOINT:[NSString stringWithFormat:@"%@memberpoint.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_MEMBERS:[NSString stringWithFormat:@"%@members.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_GET_BROCHURES:[NSString stringWithFormat:@"%@getbrochures.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_MCX_BADLA:[NSString stringWithFormat:@"%@mcx_badla.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_COMPANY_DETAIL:[NSString stringWithFormat:@"%@get_company_details.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_GET_CATEGORY1:[NSString stringWithFormat:@"%@get_item.php", sharedClassA->MainUrl]];
        //[sharedClassA setURL_SAVE_CATEGORY:[NSString stringWithFormat:@"%@save_category_ios.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_SAVE_CATEGORY:[NSString stringWithFormat:@"%@save_category.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_GET_DESIGN:[NSString stringWithFormat:@"%@get_tgno.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_INSERT_MEMBERS:[NSString stringWithFormat:@"%@insert_members.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_GET_MEMBERS:[NSString stringWithFormat:@"%@get_members.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_GET_TODAYBHAV:[NSString stringWithFormat:@"%@get_todaybhav.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_GET_UNDELIVERED:[NSString stringWithFormat:@"%@get_undeliver.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_GET_UNDEL_DETAIL:[NSString stringWithFormat:@"%@get_undeliverdetail.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_INSERT_ITRNDEL:[NSString stringWithFormat:@"%@insert_itrndel.php", sharedClassA->MainUrl]];
        //[sharedClassA setURL_SAVE_ITEM:[NSString stringWithFormat:@"%@save_item_ios.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_SAVE_ITEM:[NSString stringWithFormat:@"%@save_item.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_OUTSTAND:[NSString stringWithFormat:@"%@outstand1.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_GETOUT:[NSString stringWithFormat:@"%@get_outlog.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_INSERT_TODO:[NSString stringWithFormat:@"%@insert_todolist.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_INSERT_PAY:[NSString stringWithFormat:@"%@insert_payment.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_HOMEAPI:[NSString stringWithFormat:@"%@get_homemmipanel.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_TODAYRATE:[NSString stringWithFormat:@"%@get_todayrate.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_KITTY_LIST:[NSString stringWithFormat:@"%@get_kittylist.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_KITTY_TRAN:[NSString stringWithFormat:@"%@get_kttran.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_CHECK_TODAYRATE:[NSString stringWithFormat:@"%@check_todayrate.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_GET_MEMBERLIST:[NSString stringWithFormat:@"%@get_memberlist.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_UDPATE_MEMBER:[NSString stringWithFormat:@"%@update_userdetails.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_SAVE_COMPANY:[NSString stringWithFormat:@"%@save_company.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_GET_VISIT_ITEM:[NSString stringWithFormat:@"%@get_visit_item.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_GET_STAMP:[NSString stringWithFormat:@"%@get_stamp.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_INSERT_FEED:[NSString stringWithFormat:@"%@insert_feed.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_UPDATE_CARTITEM:[NSString stringWithFormat:@"%@update_cartitem.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_UPDATE_VISITQR:[NSString stringWithFormat:@"%@update_visitqr.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_GET_CART_VISIT:[NSString stringWithFormat:@"%@get_cart_visit2.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_SHARE_PDF:[NSString stringWithFormat:@"%@get_pdfnew.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_GET_CPVDET:[NSString stringWithFormat:@"%@get_cpvdet.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_GET_ACNAME:[NSString stringWithFormat:@"%@get_acname.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_DELETE_ALL_ORDER:[NSString stringWithFormat:@"%@delete_all_order.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_Delete_CART_Item:[NSString stringWithFormat:@"%@delete_cart_item.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_UPDATE_CART_LBR:[NSString stringWithFormat:@"%@update_cartitemlbr.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_UPDATE_CART_LBR:[NSString stringWithFormat:@"%@update_cartitemlbr.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_INSERT_ITEMQR:[NSString stringWithFormat:@"%@insert_itemqr_ios.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_Active_TGNO:[NSString stringWithFormat:@"%@active_tagno.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_DELETE_TGNO:[NSString stringWithFormat:@"%@delete_tagno.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_DELETE_USER1:[NSString stringWithFormat:@"%@delete_user.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_GET_CAT_GROUP:[NSString stringWithFormat:@"%@get_tg_category.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_DELETE_IDESC:[NSString stringWithFormat:@"%@delete_idesc.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_SAVE_BANNER_IOS:[NSString stringWithFormat:@"%@save_banner_ios.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_SAVE_DEMAND_IOS:[NSString stringWithFormat:@"%@insert_demand.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_FEEDITEM:[NSString stringWithFormat:@"%@feeditem.php", sharedClassA->MainUrl]];
        
        [sharedClassA setURL_GET_KarigarNames:[NSString stringWithFormat:@"%@get_cnmview.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_GET_SalesmanNames:[NSString stringWithFormat:@"%@get_salesman.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_GET_OrderRegister:[NSString stringWithFormat:@"%@get_orderregister.php", sharedClassA->MainUrl]];
        
        [sharedClassA setURL_GET_KittyallList:[NSString stringWithFormat:@"%@get_kittyall.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_GET_Kittran:[NSString stringWithFormat:@"%@get_kttran.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_GET_Kittydet:[NSString stringWithFormat:@"%@get_kittydet.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_GET_KittyPaymentMode:[NSString stringWithFormat:@"%@save_ratebook.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_GET_KittyInsertPayment:[NSString stringWithFormat:@"%@pg/insert_payment.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_GET_KittyGroupList:[NSString stringWithFormat:@"%@get_ktgroup.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_GET_KittyInstallList:[NSString stringWithFormat:@"%@get_kinstall.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_GET_KittyCityList:[NSString stringWithFormat:@"%@get_city.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_Save_Kitty:[NSString stringWithFormat:@"%@create_kitty.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_GET_Reason:[NSString stringWithFormat:@"%@get_reason.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_GET_SITE:[NSString stringWithFormat:@"%@get_site.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_SAVE_SITEACCESS:[NSString stringWithFormat:@"%@save_siteaccess.php", sharedClassA->MainUrl]];
        
        [sharedClassA setURL_GET_VISITITEM:[NSString stringWithFormat:@"%@get_visititem.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_INSERT_CPVDET:[NSString stringWithFormat:@"%@insert_cpvdet.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_GET_All_IDESC:[NSString stringWithFormat:@"%@get_all_idesc.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_UPDATE_CARTTUNCH:[NSString stringWithFormat:@"%@update_carttunch.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_UpdateRazorPayment:[NSString stringWithFormat:@"%@pg/response.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_ItemFilter:[NSString stringWithFormat:@"%@get_itemfilter.php", sharedClassA->MainUrl]];
        
        [sharedClassA setURL_ItemFilter4:[NSString stringWithFormat:@"%@get_itemfilter4.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_ItemFilterRecord:[NSString stringWithFormat:@"%@get_filterrecord.php", sharedClassA->MainUrl]];

        [sharedClassA setURL_SaveAboutUs:[NSString stringWithFormat:@"%@save_aboutus.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_ActiveIdesc:[NSString stringWithFormat:@"%@active_idesc.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_UpLoadImage:[NSString stringWithFormat:@"%@upload_image.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_RazorPayOrderId:[NSString stringWithFormat:@"%@panel/razorpay_pg/create_order.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_Register_config:[NSString stringWithFormat:@"%@register_config.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_Upload_Logo:[NSString stringWithFormat:@"%@upload_logo.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_Insert_Set_Design:[NSString stringWithFormat:@"%@insert_set_design.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_Insert_Studd:[NSString stringWithFormat:@"%@insert_studd.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_Get_Separate_Pdf:[NSString stringWithFormat:@"%@get_separate_pdf.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_SHOW_LEDGER:[NSString stringWithFormat:@"%@ledger_accounts.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_SHOW_LEDGER_DETAILS:[NSString stringWithFormat:@"%@ledger_details.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_GetAlertManagementList:[NSString stringWithFormat:@"%@get_adminalertmsg.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_GetAreaList:[NSString stringWithFormat:@"%@get_area.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_SendAlerts:[NSString stringWithFormat:@"%@send_alerts.php", sharedClassA->MainUrl]];
        
        [sharedClassA setURL_Insert_ContactUs:[NSString stringWithFormat:@"%@insert_contactus.php", sharedClassA->MainUrl]];
        
        [sharedClassA setURL_Get_physicalstock:[NSString stringWithFormat:@"%@get_physicalstock.php", sharedClassA->MainUrl]];
        
        //[sharedClassA setURL_Get_physicalstock:[NSString stringWithFormat:@"%@get_pstock.php", sharedClassA->MainUrl]];
        
        [sharedClassA setURL_Get_PScanid:[NSString stringWithFormat:@"%@get_pscanid.php", sharedClassA->MainUrl]];
        
        [sharedClassA setURL_Get_CPName:[NSString stringWithFormat:@"%@get_cp_name.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_GET_Fillgrid:[NSString stringWithFormat:@"%@fillgrid.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_GET_Fcustomer:[NSString stringWithFormat:@"%@fcustomer.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_GET_FltCategory:[NSString stringWithFormat:@"%@fltcategory.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_SaveTag:[NSString stringWithFormat:@"%@savetag.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_Get_Feedback:[NSString stringWithFormat:@"%@get_feedback.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_Delete_Feedback:[NSString stringWithFormat:@"%@delete_feedback.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_Reply_Feedback:[NSString stringWithFormat:@"%@reply_feedback.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_Show_Cart:[NSString stringWithFormat:@"%@show_cart.php", sharedClassA->MainUrl]];
        //[sharedClassA setURL_Show_Cart:[NSString stringWithFormat:@"%@show_cart_k.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_Physical_Item:[NSString stringWithFormat:@"%@get_physicalitem.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_Insert_Physical:[NSString stringWithFormat:@"%@insert_pscan.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_SHOW_ORDER_COMPLETE:[NSString stringWithFormat:@"%@complete_order.php", sharedClassA->MainUrl]];
        [sharedClassA setURL_SHOW_ORDERD_DELETE:[NSString stringWithFormat:@"%@insert_status_delete.php", sharedClassA->MainUrl]];
    });
    return sharedClassA;
}

- (NSString *)getMainUrl {
    return MainUrl;
}

+ (void)getAPIWithApiName:(NSString *)apiName
                     type:str_type
               completion:(void (^)(NSDictionary *response, NSError *error))completion {
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype = ECAT_TYPE;
    NSString *apiType = [str_type lowercaseString];
    NSLog(@"Api type = %@", apiType);
    
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        loginRequest = [NSString stringWithFormat:@"apptype=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@&type=%@",apptype,ip,db,ipusername,pswd,ftppath,str_type];
        URL_API = apiName;
    }else if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        loginRequest = [NSString stringWithFormat:@"apptype=%@&ftppath=%@&type=%@",apptype,ftppath,str_type];
        NSString *apiType = [str_type lowercaseString];
        if([apiType isEqualToString:@"karigarnames"]){
            URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/get_cnmview.php",ip];
        }else if([apiType isEqualToString:@"salesmannames"]){
            URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/get_salesman.php",ip];
        }else if([apiType isEqualToString:@"feeditem"]){
            URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/feeditem.php",ip];
        }else if([apiType isEqualToString:@"stamp"]){
            URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/get_stamp.php",ip];
        }
    }else{
        loginRequest = [NSString stringWithFormat:@"apptype=%@&type=%@",apptype,str_type];
        URL_API = apiName;
    }
    
    NSLog(@"URL Name = %@", URL_API);
    NSLog(@"param = %@", loginRequest);
    
    NSString *urlString = [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api = [NSString stringWithFormat:@"%@",URL_API];
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:60.0];
    [request setHTTPBody:data1];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        if ([data length] >0 && error == nil){
//            dispatch_async(dispatch_get_main_queue(), ^{
//                NSError *jsonError;
//                NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
//                
//            });
        }else if ([data length] == 0 && error == nil){
            NSLog(@"Empty Response, not sure why?");
            completion(nil, error);
            
        }else if (error != nil){
            NSLog(@"Not again, what is the error = %@", error);
            completion(nil, error);
        }
    }] resume];
    // Create a data task to handle the request
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            completion(nil, error);
        } else {
            NSError *jsonError;
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if (jsonError) {
                completion(nil, jsonError);
            } else {
                completion(jsonResponse, nil);
            }
        }
    }];
    // Start the request
    [dataTask resume];
}
@end

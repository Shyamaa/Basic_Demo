//
//  UserListActivity.m
//  Jewel Desk
//
//  Created by App Dev on 18/07/24.
//  Copyright © 2024 MMI Softwares. All rights reserved.
//

#import "UserListActivity.h"
#import "webUrlconstant.h"
#import "UIImageView+WebCache.h"
#import "BusyIndicator.h"
#import "PopupRatebook.h"
#import "PopupViewController.h"
#import "EditProfileVC.h"


#pragma mark - Custom UserList UITableViewCell

@interface UserListCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIView *subView;
@property (nonatomic, strong) IBOutlet UIImageView *userImgView;
@property (nonatomic, strong) IBOutlet UILabel *lblName;
@property (nonatomic, strong) IBOutlet UILabel *lblPhone;
@property (nonatomic, strong) IBOutlet UILabel *lblCategory;
@property (nonatomic, strong) IBOutlet UILabel *lblLoginDate;

@property (nonatomic, strong) IBOutlet UIButton *btnDelete;
@property (nonatomic, strong) IBOutlet UIButton *btnEdit;

@end

@implementation UserListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

@end


#pragma mark - UserListActivity

@interface UserListActivity ()

@end

@implementation UserListActivity

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"User List";
    self.filteredMembers = [NSMutableArray array];
    self.tableView.estimatedRowHeight = 80;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self setUpNavigationBtn];
    self.searchBar.placeholder = @"Search bt user name";
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self fetchMemberData];
}

#pragma mark:- Set Up Navigation and Action Method

-(void)setUpNavigationBtn{
    UIButton *  btnAdd =  [UIButton buttonWithType:UIButtonTypeContactAdd];
    btnAdd.frame = CGRectMake(0,8,30,30);
    [btnAdd addTarget:self action:@selector(addBarBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [[btnAdd imageView] setContentMode: UIViewContentModeScaleAspectFit];
    btnAdd.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    btnAdd.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    UIBarButtonItem *barBtnAdd = [[UIBarButtonItem alloc] initWithCustomView:btnAdd];
    barBtnAdd.tintColor = [UIColor whiteColor];
    
    UIButton * btn_Search =  [UIButton buttonWithType:UIButtonTypeCustom];
    btn_Search.frame = CGRectMake(0,5,30,30);
    [btn_Search setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [[btn_Search imageView] setContentMode: UIViewContentModeScaleAspectFit];
    btn_Search.tintColor = [UIColor whiteColor];
    [btn_Search addTarget:self action:@selector(searchNavigationButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barSearchBtn = [[UIBarButtonItem alloc] initWithCustomView:btn_Search];
    
    UIButton * btn_Filter =  [UIButton buttonWithType:UIButtonTypeCustom];
    btn_Filter.frame = CGRectMake(0,5,30,30);
    [btn_Filter setImage:[UIImage imageNamed:@"filter"] forState:UIControlStateNormal];
    [[btn_Filter imageView] setContentMode: UIViewContentModeScaleAspectFit];
    btn_Filter.tintColor = [UIColor whiteColor];
    [btn_Filter addTarget:self action:@selector(filterNavigationButtonAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barFilterBtn = [[UIBarButtonItem alloc] initWithCustomView:btn_Filter];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                               target:self
                                                                               action:@selector(filterNavigationButtonAction)];
    //self.navigationItem.rightBarButtonItem = addButton;
    
    //self.navigationItem.rightBarButtonItems =[NSArray arrayWithObjects:barFilterBtn, barSearchBtn, nil];
    self.navigationItem.rightBarButtonItems =[NSArray arrayWithObjects:addButton, barSearchBtn, nil];
}

-(void)addBarBtnAction{
    PopupViewController *popupVC = [[PopupViewController alloc] init];
    popupVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    popupVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    popupVC.dropdownItems = uniqueCategoriesList;//@[@"All", @"By Default", @"Not any category", @"Retail", @"Admin"];
    popupVC.completionHandler = ^(NSString *selectedItem) {
        NSLog(@"Select Category: %@", selectedItem);
        if ([@"All" isEqualToString: selectedItem] || [@"By Default" isEqualToString: selectedItem]){
            self.isFiltering = NO;
            [self.filteredMembers removeAllObjects];
        }else{
            self.isFiltering = YES;
            [self.filteredMembers removeAllObjects];
            for (NSDictionary *item in self.members) {
                NSString *value = [item valueForKey: @"category"];
                if ([value isEqualToString: selectedItem]){
                    [self.filteredMembers addObject:item];
                }
            }
        }
        [self.tableView reloadData];
    };
    [self presentViewController:popupVC animated:YES completion:nil];
}

- (void)filterNavigationButtonAction {
    [self addBarBtnAction];
}

- (void)searchNavigationButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected){
        [self.searchBar setHidden:false];
    }else{
        [self.searchBar setHidden:true];
        [self.searchBar resignFirstResponder];
    }
    
}

#pragma mark: Alert Method

- (void)showErrorAlertWithMessage:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    });
}

- (void)showsuccessAlertWithMessage:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Success" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    });
}


#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  UITableViewAutomaticDimension;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.isFiltering ? self.filteredMembers.count : self.members.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserListCell" forIndexPath:indexPath];
    
    Model_Userlist *member = self.isFiltering ? self.filteredMembers[indexPath.row] : self.members[indexPath.row];
    
    [cell.subView.layer setCornerRadius:8.0f];
    [cell.subView.layer setBorderColor:[UIColor blackColor].CGColor];
    [cell.subView.layer setBorderWidth:1.0f];
    
    [cell.userImgView setShowActivityIndicatorView:YES];
    [cell.userImgView sd_setImageWithURL:[NSURL URLWithString: member.imgurl] placeholderImage:[UIImage imageNamed:@"user"] options:indexPath.row == 0 ? SDWebImageRefreshCached : 0];
    
    cell.lblName.text = member.name;
    cell.lblPhone.text = member.mobile;
    cell.lblCategory.text = member.category;
    cell.lblLoginDate.hidden = true;
    if (member.cdate.length > 0) {
        cell.lblLoginDate.text = [NSString stringWithFormat:@"Login Date : %@",  member.cdate];
        cell.lblLoginDate.hidden = false;
    }
    
    cell.btnDelete.tag = indexPath.row;
    [cell.btnDelete addTarget:self action:@selector(btn_delete:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btnEdit.tag = indexPath.row;
    [cell.btnEdit addTarget:self action:@selector(btn_Edit:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Model_Userlist *member = self.isFiltering ? self.filteredMembers[indexPath.row] : self.members[indexPath.row];
    EditProfileVC *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"EditProfileVC"];
    obj.userData = member;
    obj.profileType = @"user";
    [self.navigationController pushViewController:obj animated:YES];
}


#pragma mark:- Table Cell Button Action Method

-(void)btn_delete:(UIButton*)sender{
    NSInteger index_c = [sender tag];
    
    UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Message" message:@"Do you want delete?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                {
        Model_Userlist *selectedMember = self.isFiltering ? self.filteredMembers[index_c] : self.members[index_c];
        
        NSString *mobile = selectedMember.mobile;
        
        NSLog(@"mobile ::::::::: %@",mobile);
        [self URL_ITEM_DELETE:mobile];
    }];
    
    UIAlertAction *noButton = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){}];
    [alert addAction:noButton];
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)btn_Edit:(UIButton*)sender{
    Model_Userlist *selectedMember = self.isFiltering ? self.filteredMembers[sender.tag] : self.members[sender.tag];
    NSLog(@"Selected Member: %@", selectedMember.name);
    PopupViewController *popupVC = [[PopupViewController alloc] init];
    popupVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    popupVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    popupVC.dropdownItems = @[@"Not Any Category", @"By Default", @"Retail", @"Admin"];
    popupVC.completionHandler = ^(NSString *selectedItem) {
        NSLog(@"Select Category: %@", selectedItem);
        [self Update_User:selectedItem withName:selectedMember.name withmobile:selectedMember.mobile];
    };
    [self presentViewController:popupVC animated:YES completion:nil];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        self.isFiltering = NO;
        [self.filteredMembers removeAllObjects];
    } else {
        self.isFiltering = YES;
        [self.filteredMembers removeAllObjects];
        for (Model_Userlist *member in self.members) {
            if ([member.name.lowercaseString containsString:searchText.lowercaseString]) {
                [self.filteredMembers addObject:member];
            }
        }
    }
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    self.isFiltering = NO;
    [self.tableView reloadData];
}

#pragma mark: - Api Method

- (void)fetchMemberData {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    NSString *api = [NSString stringWithFormat:@"%@", [WEB_URL URL_GET_MEMBERLIST]];
    NSURL *url = [NSURL URLWithString:api];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data) {
            NSError *jsonError;
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            NSLog(@"userlist data = %@",jsonDict);
            NSArray *memberlist = jsonDict[@"memberlist"];
            NSArray *categories = [memberlist valueForKey:@"category"];
            NSSet *uniqueCategoriesSet = [NSSet setWithArray:categories];
            self->uniqueCategoriesList = [[uniqueCategoriesSet allObjects] mutableCopy];
            [self->uniqueCategoriesList insertObject:@"All" atIndex:0];  // Add at the beginning
            // [uniqueCategories addObject:@"All"];  // Add at the end
            NSLog(@"Unique Categories: %@", self->uniqueCategoriesList);
            if (jsonDict) {
                self.members = [NSMutableArray array];
                for (NSDictionary *dict in jsonDict[@"memberlist"]) {
                    Model_Userlist *member = [[Model_Userlist alloc] init];
                    member.name = dict[@"username"];
                    member.mobile = dict[@"mobile"];
                    member.imgurl = dict[@"imgurl"];
                    member.category = dict[@"category"];
                    member.cdate = dict[@"cdate"];
                    member.mdob = dict[@"mdob"];
                    member.emailid = dict[@"emailid"];
                    NSString *interested = dict[@"interested"];
                    if ([interested isKindOfClass:[NSNull class]] || interested == nil) {
                            interested = @""; // Assign empty string
                    }else{
                        member.interested = dict[@"interested"];
                    }
                    [self.members addObject:member];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            } else {
                [self showErrorAlertWithMessage:jsonError.localizedDescription];
            }
        } else {
            [self showErrorAlertWithMessage:error.localizedDescription];
        }
    }];
    [task resume];
}

- (void)Update_User:(id)selectedItem withName:(NSString *)username withmobile:(NSString *)mobile {
    NSString *category = @"";
    if ([selectedItem isEqualToString:@"Retail"]) {
        category = @"1";
    } else if ([selectedItem isEqualToString:@"Not Any Category"] || [selectedItem isEqualToString:@"All"]) {
        category = @"0";
    } else if ([selectedItem isEqualToString:@"By Default"]) {
        category = @"-1";
    } else if ([selectedItem isEqualToString:@"Admin"]) {
        category = @"5";
    }
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    NSString *api = [NSString stringWithFormat:@"%@", [WEB_URL URL_UDPATE_MEMBER]];
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *postString = [NSString stringWithFormat:@"mobile=%@&category=%@&username=%@", mobile,category,username];
    request.HTTPBody = [postString dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (data) {
            NSError *jsonError;
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            if (jsonDict) {
                NSString *status = jsonDict[@"success"];
                NSString *message = jsonDict[@"message"];
                if ([status isEqualToString:@"1"]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showsuccessAlertWithMessage:message];
                        [self fetchMemberData];
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self showErrorAlertWithMessage:message];
                    });
                }
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showErrorAlertWithMessage:jsonError.localizedDescription];
                });
            }
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showErrorAlertWithMessage:error.localizedDescription];
            });
        }
    }];
    [task resume];
}

-(void)URL_ITEM_DELETE:(NSString *)mobile {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype=ECAT_TYPE;
    NSString *activity = @"delete";
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        loginRequest = [NSString stringWithFormat:@"mobile=%@&apptype=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@&activity=%@",mobile,apptype,ip,db,ipusername,pswd,ftppath,activity];
        
        URL_API = [WEB_URL URL_DELETE_USER1];
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];

        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/delete_user.php",ip];
        loginRequest = [NSString stringWithFormat:@"mobile=%@&apptype=%@&ftppath=%@&activity=%@",mobile,apptype,ftppath,activity];
    }else{
        loginRequest = [NSString stringWithFormat:@"mobile=%@&apptype=%@&activity=%@",mobile,apptype,activity];
        URL_API = [WEB_URL URL_DELETE_USER1];
    }
    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
    NSString *api = [NSString stringWithFormat:@"%@",URL_API];
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSData *data1 = [urlString dataUsingEncoding:NSUTF8StringEncoding];
    //create the Method "GET" or "POST"
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data1.length] forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //Apply the data to the body
    [request setHTTPBody:data1];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error) {
        if ([data length] >0 && error == nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parse_SINGLE_ITEM:data];
            });
        }else if ([data length] == 0 && error == nil){
            NSLog(@"Empty Response, not sure why?");
            [[BusyIndicator sharedInstance]stopIndicator];
        }else if (error != nil){
            NSLog(@"Not again, what is the error = %@", error);
            [[BusyIndicator sharedInstance]stopIndicator];
        }
    }] resume];
}

- (void)parse_SINGLE_ITEM:(NSData *) data {
    @try {
        NSString *myData = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding];
        NSLog(@"JSON data = %@", myData);
        NSError *error = nil;
        [[BusyIndicator sharedInstance]stopIndicator];
        //parsing the JSON response
        id jsonObject = [NSJSONSerialization
                         JSONObjectWithData:data
                         options:NSJSONReadingAllowFragments
                         error:&error];
        if (jsonObject != nil && error == nil){
            NSLog(@"Successfully deserialized...");
            //check if the country code was valid
            NSMutableDictionary *pDict = [NSJSONSerialization
                                          JSONObjectWithData:data
                                          options:NSJSONReadingAllowFragments
                                          error:&error];
            NSMutableArray *arrayResponse_success = [pDict objectForKey:@"success"];
            NSString *str_success = [arrayResponse_success description];
            NSMutableArray*nsarray_msg = [pDict objectForKey:@"message"];
            NSString *str_msg = [nsarray_msg description];
            if ([str_success isEqualToString:@"1"]) {
                [self fetchMemberData];
            }else{
                UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Message"
                                                                              message:str_msg
                                                                       preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action){
                                            }];
                [alert addAction:yesButton];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}
@end

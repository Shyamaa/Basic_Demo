
#import "RearViewController.h"
#import "SWRevealViewController.h"
#import "FrontViewController.h"
#import "MainActivity.h"
#import "Aboutus.h"
#import "ConfigVC.h"
#import "MMIHOMEPanel.h"
#import "ItemListActivity.h"
#import "CategoryListActivity.h"
#import "UsersECAT.h"
#import "WhatsAppShareVC.h"
#import "AddLogoVC.h"
#import "CompanyDetailsVC.h"
#import "SetDesignVC.h"
#import "SetStuddVC.h"
#import "HomeVC.h"
#import "Suggestion.h"
#import "ProfileVC.h"
#import "Gautom_HomeVC.h"
#import "OrderList.h"
#import "AddDemand.h"
#import "Contactus.h"

@interface RearViewController()
{
    NSInteger _presentedRow;
}

@end

@implementation RearViewController

@synthesize rearTableView = _rearTableView;

NSArray *items;
NSArray *itemsBy;


#pragma mark - View lifecycle
- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = NSLocalizedString(@"", nil);
    [self addHeaderView];
    NSString *strTemplate = [[NSUserDefaults standardUserDefaults]stringForKey:@"template"];
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    if([ECAT_TYPE isEqualToString:@"3"]){
        if([strTemplate isEqualToString:@"2"]){
            items = _menuItemList;
            items = @[
                @{@"itemid": @20, @"caption": @"Home"},
                @{@"itemid": @12, @"caption": @"Product Gallery"},
                @{@"itemid": @112, @"caption": @"Our Bank Details"},
                @{@"itemid": @119, @"caption": @"Whatsapp Config"},
                @{@"itemid": @98, @"caption": @"About us"},
                @{@"itemid": @70, @"caption": @"Update Profile"},
                @{@"itemid": @95, @"caption": @"Suggestion"},
                @{@"itemid": @100, @"caption": @"Share"},
                @{@"itemid": @286, @"caption": @"Brochures"},
                @{@"itemid": @72, @"caption": @"Logout"}
            ];
        }else{
            items = @[
                @{@"itemid": @30, @"caption": @"Home"},
                @{@"itemid": @12, @"caption": @"Product Gallery"},
                @{@"itemid": @119, @"caption": @"Whatsapp Config"},
                @{@"itemid": @70, @"caption": @"Update Profile"},
                @{@"itemid": @95, @"caption": @"Suggestion"},
                @{@"itemid": @100, @"caption": @"Share"},
                @{@"itemid": @24, @"caption": @"Company Details"},
                @{@"itemid": @286, @"caption": @"Brochures"},
                @{@"itemid": @72, @"caption": @"Logout"}
            ];
        }
    }else{
        items = @[
            @{@"itemid": @0, @"caption": @"Home"},
            @{@"itemid": @2, @"caption": @"Update DB"},
            @{@"itemid": @1, @"caption": @"Users"},
            @{@"itemid": @6, @"caption": @"Set Design"},
            @{@"itemid": @7, @"caption": @"Set Studd"},
            @{@"itemid": @5, @"caption": @"Company Config"},
            @{@"itemid": @3, @"caption": @"Add Design"},
            @{@"itemid": @4, @"caption": @"Add Item"},
            //@{@"itemid": @8, @"name": @"Day End"},
            @{@"itemid": @119, @"caption": @"WhatsApp Share"},
            @{@"itemid": @10, @"caption": @"Logo Upload"}
        ];
        itemsBy = @[ @{@"itemid": @0, @"caption": @"MMI Software Pvt. Ltd."},
                     @{@"itemid": @1, @"caption": @"Share"}
        ];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMenu:) name:@"MenuDataNotification" object:nil];
    NSArray *savedMenu = [[NSUserDefaults standardUserDefaults] objectForKey:@"MenuData"];
      if (savedMenu) {
          [self updateMenuWithArray:savedMenu];
      }
}

- (void)updateMenu:(NSNotification *)notification {
    NSArray *menu = notification.userInfo[@"menu"];
    [self updateMenuWithArray:menu];
}

- (void)updateMenuWithArray:(NSArray *)menu {
    NSDictionary *homeItem = @{@"itemid": @20, @"caption": @"Home", @"type" : @"home"};
    NSMutableArray *finalMenuArray = [NSMutableArray arrayWithObject:homeItem];
    [finalMenuArray addObjectsFromArray:menu];
    items = finalMenuArray;
    [self.rearTableView reloadData];
}

-(void)addHeaderView{
    // Create a header view
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.rearTableView.frame.size.width, 150)];
    headerView.backgroundColor = [UIColor colorNamed:@"appRed_Color"];
    
    // Add a label to the header
    UIImageView *headerIcon = [[UIImageView alloc] initWithFrame:CGRectMake(60, 15, headerView.frame.size.height - 30, headerView.frame.size.height - 30)];
    headerIcon.image = [UIImage imageNamed:@"banner_Default.png"];
    headerIcon.contentMode = UIViewContentModeScaleAspectFit;
    headerIcon.layer.cornerRadius = 20;
    headerIcon.clipsToBounds = YES;
    [headerView addSubview:headerIcon];
    // Assign header view to tableView
    self.rearTableView.tableHeaderView = headerView;
}

#pragma mark - Section Header Customization

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (itemsBy.count > 0){
        return 2;
    }else{
        return 1;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1){
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
        headerView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0]; // light gray background
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 5, tableView.frame.size.width - 32, 34)];
        titleLabel.text = @"Developer By"; //[NSString stringWithFormat:@"Section %ld", section];
        titleLabel.textColor = [UIColor darkGrayColor]; // change text color here
        titleLabel.font = [UIFont boldSystemFontOfSize:18]; // change font here
        [headerView addSubview:titleLabel];
        //headerView.backgroundColor = [UIColor redColor];
        return headerView;
    }else{
        return  nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1){
        return 44.0; // height of the custom section header
    }else{
        return  1;
    }
}

#pragma mark: - UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 1){
        return itemsBy.count;
    }else{
        return items.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    if(indexPath.section == 1){
        cell.textLabel.text = [[itemsBy valueForKey:@"caption"] objectAtIndex: indexPath.row];
    }else{
        cell.textLabel.text = [[items valueForKey:@"caption"] objectAtIndex: indexPath.row];
    }
    //cell.backgroundColor = [UIColor greenColor];
    return cell;
}

#pragma mark: - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SWRevealViewController *revealController = self.revealViewController;
    NSInteger row = indexPath.row;
    if (indexPath.section == 1){
        if (row == 0){
            NSURL *url = [NSURL URLWithString:@"https://www.mmsoftwares.com"];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            }
        }else if (row == 1){
            [self shareApp];
        }
    }else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UINavigationController *navigationController = [UINavigationController alloc];
        int index = [[[items valueForKey:@"itemid"] objectAtIndex: indexPath.row] intValue];
        NSString *softid = [[NSUserDefaults standardUserDefaults]stringForKey:@"softid"];
        if (![softid isEqualToString:@"SQLECAT"] && softid.length > 0 && index > 0 && index < 9){//&& ![softid isEqualToString:@"SQLQR"]) {
            if (index == 1){
                UsersECAT *newFrontController = nil;
                newFrontController = [storyboard instantiateViewControllerWithIdentifier:@"UsersECAT"];
                navigationController = [navigationController initWithRootViewController:newFrontController];
            }else if (index == 2){
                ConfigVC *newFrontController = nil;
                newFrontController = [storyboard instantiateViewControllerWithIdentifier:@"ConfigVC"];
                navigationController = [navigationController initWithRootViewController:newFrontController];
            }else if (index == 3){
                ItemListActivity *newFrontController = nil;
                newFrontController = [storyboard instantiateViewControllerWithIdentifier:@"ItemListActivity"];
                newFrontController.openWithSidMenu = true;
                navigationController = [navigationController initWithRootViewController:newFrontController];
            }else if (index == 4){
                CategoryListActivity *newFrontController = nil;
                newFrontController = [storyboard instantiateViewControllerWithIdentifier:@"CategoryListActivity"];
                newFrontController.openWithSidMenu = true;
                navigationController = [navigationController initWithRootViewController:newFrontController];
            }else if (index == 5){
                CompanyDetailsVC *newFrontController = nil;
                newFrontController = [storyboard instantiateViewControllerWithIdentifier:@"CompanyDetailsVC"];
                navigationController = [navigationController initWithRootViewController:newFrontController];
                
            }else if (index == 6){
                SetDesignVC *newFrontController = nil;
                newFrontController = [storyboard instantiateViewControllerWithIdentifier:@"SetDesignVC"];
                newFrontController.openWithSidMenu = true;
                navigationController = [navigationController initWithRootViewController:newFrontController];
            }else if (index == 7){
                SetStuddVC *newFrontController = nil;
                newFrontController = [storyboard instantiateViewControllerWithIdentifier:@"SetStuddVC"];
                newFrontController.openWithSidMenu = true;
                navigationController = [navigationController initWithRootViewController:newFrontController];
            }else if (index == 8){
                //End Day
            }
            [revealController pushFrontViewController:navigationController animated:YES];
            _presentedRow = row;  // <- store the presented row
        }else  if (index == 0){
            MMIHOMEPanel *newFrontController = nil;
            newFrontController = [storyboard instantiateViewControllerWithIdentifier:@"MMIHOMEPanel"];
            navigationController = [navigationController initWithRootViewController:newFrontController];
            [revealController pushFrontViewController:navigationController animated:YES];
            _presentedRow = row;  // <- store the presented row
        }else if (index == 119){
            WhatsAppShareVC *newFrontController = nil;
            newFrontController = [storyboard instantiateViewControllerWithIdentifier:@"WhatsAppShareVC"];
            navigationController = [navigationController initWithRootViewController:newFrontController];
            [revealController pushFrontViewController:navigationController animated:YES];
            _presentedRow = row;  // <- store the presented row
        }else if (index == 10){
            AddLogoVC *newFrontController = nil;
            newFrontController = [storyboard instantiateViewControllerWithIdentifier:@"AddLogoVC"];
            navigationController = [navigationController initWithRootViewController:newFrontController];
            [revealController pushFrontViewController:navigationController animated:YES];
            _presentedRow = row;
        }else if (index == 12){
            ProductGallery *newFrontController = nil;
            newFrontController = [storyboard instantiateViewControllerWithIdentifier:@"ProductGallery"];
            newFrontController.str_igroup = @"";
            newFrontController.openWithSidMenu = true;
            navigationController = [navigationController initWithRootViewController:newFrontController];
            [revealController pushFrontViewController:navigationController animated:YES];
            _presentedRow = row;
        }else if (index == 112){
            BankDetail *newFrontController = nil;
            newFrontController = [storyboard instantiateViewControllerWithIdentifier:@"BankDetail"];
            navigationController = [navigationController initWithRootViewController:newFrontController];
            newFrontController.isSideMenu = true;
            [revealController pushFrontViewController:navigationController animated:YES];
            _presentedRow = row;
        }else if (index == 98 || index == 102 || index == 97){
            Aboutus *newFrontController = nil;
            newFrontController = [storyboard instantiateViewControllerWithIdentifier:@"Aboutus"];
            newFrontController.str_type = @"About us";
            newFrontController.isSideMenu = true;
            navigationController = [navigationController initWithRootViewController:newFrontController];
            [revealController pushFrontViewController:navigationController animated:YES];
            _presentedRow = row;
        }else if (index == 70 || index == 127){
            ProfileVC *newFrontController = nil;
            newFrontController = [storyboard instantiateViewControllerWithIdentifier:@"ProfileVC"];
            newFrontController.isSideMenu = true;
            navigationController = [navigationController initWithRootViewController:newFrontController];
            [revealController pushFrontViewController:navigationController animated:YES];
            _presentedRow = row;
        }else if (index == 95){
            Suggestion *newFrontController = nil;
            newFrontController = [storyboard instantiateViewControllerWithIdentifier:@"Suggestion"];
            newFrontController.str_type = @"Suggestion";
            newFrontController.openWithSidMenu = true;
            navigationController = [navigationController initWithRootViewController:newFrontController];
            [revealController pushFrontViewController:navigationController animated:YES];
            _presentedRow = row;
        }else if (index == 286 || index == 121 || index == 292){
            Brochures *newFrontController = nil;
            newFrontController = [storyboard instantiateViewControllerWithIdentifier:@"Brochures"];
            navigationController = [navigationController initWithRootViewController:newFrontController];
            newFrontController.openWithSidMenu = true;
            [revealController pushFrontViewController:navigationController animated:YES];
            _presentedRow = row;
        }else if (index == 100){
            [self shareApp];
        }else if (index == 72 || index == 54 || index == 66){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Do you want logout?" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self logoutApp];
            }];
            [alertController addAction:confirmAction];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"Canelled");
            }];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
            _presentedRow = row;
        }else if (index == 20){
            Gautom_HomeVC *newFrontController = nil;
            newFrontController = [storyboard instantiateViewControllerWithIdentifier:@"Gautom_HomeVC"];
            navigationController = [navigationController initWithRootViewController:newFrontController];
            [revealController pushFrontViewController:navigationController animated:YES];
            _presentedRow = row;
        }else if (index == 287 || index == 92){
            OrderList *newFrontController = nil;
            newFrontController = [storyboard instantiateViewControllerWithIdentifier:@"OrderList"];
            newFrontController.isSideMenu = true;
            navigationController = [navigationController initWithRootViewController:newFrontController];
            [revealController pushFrontViewController:navigationController animated:YES];
            _presentedRow = row;
        }else if (index == 84){
            AddDemand *newFrontController = nil;
            newFrontController = [storyboard instantiateViewControllerWithIdentifier:@"AddDemand"];
            newFrontController.isSideMenu = true;
            navigationController = [navigationController initWithRootViewController:newFrontController];
            [revealController pushFrontViewController:navigationController animated:YES];
            _presentedRow = row;
        }else if (index == 90){
            Contactus *newFrontController = nil;
            newFrontController = [storyboard instantiateViewControllerWithIdentifier:@"Contactus"];
            newFrontController.isSideMenu = true;
            navigationController = [navigationController initWithRootViewController:newFrontController];
            [revealController pushFrontViewController:navigationController animated:YES];
            _presentedRow = row;
        }else if (index == 24){
            CompanyDetailsVC *newFrontController = nil;
            newFrontController = [storyboard instantiateViewControllerWithIdentifier:@"CompanyDetailsVC"];
            newFrontController.isSideMenu = true;
            navigationController = [navigationController initWithRootViewController:newFrontController];
            [revealController pushFrontViewController:navigationController animated:YES];
            _presentedRow = row;
        }else if (index == 30){
            MainActivity *newFrontController = nil;
            newFrontController = [storyboard instantiateViewControllerWithIdentifier:@"MainActivity"];
            navigationController = [navigationController initWithRootViewController:newFrontController];
            [revealController pushFrontViewController:navigationController animated:YES];
            _presentedRow = row;
        }else{
            [self alertMsg:@"Sorry! you are not permissions to use. Please contact to MMI SUPPORT"];
        }
    }
}

-(void)shareApp{
    NSString *strAppId = @"6468902523";
    NSString *appLink = [NSString stringWithFormat:@"https://apps.apple.com/app/id%@", strAppId];
    NSString *message = [NSString stringWithFormat:@"Check out Sherpura Jewellers app: %@\n", appLink];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[message] applicationActivities:nil];
    // For iPad support
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        activityVC.popoverPresentationController.sourceView = self.view;
        activityVC.popoverPresentationController.sourceRect = CGRectMake(100, 100, 200, 50);
    }
    
    [self presentViewController:activityVC animated:YES completion:nil];
    //[self shareOnWhatsApp:message phone:@""];
}

@end

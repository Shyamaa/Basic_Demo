//
//  HelpVC.m
//  Jewel Desk
//
//  Created by MMI Softwares Pvt Ltd on 16/07/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "HelpVC.h"

@interface HelpVC ()
{
    NSArray *tblList;
}
@end

@implementation HelpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Voice Search Guide";
    tblList = @[ @{@"index": @1, @"titel": @"🛍️  Product Gallery", @"subTitle" : @"Say: Product Ring"},
                 @{@"index": @2, @"titel": @"🔖  Tag Query", @"subTitle" : @"Say: Query R1"},
                 @{@"index": @3, @"titel": @"📝  Estimate", @"subTitle" : @"Say: Estimate R1+R2+R3"},
                 @{@"index": @4, @"titel": @"💰  Outstanding", @"subTitle" : @"Say: Outstanding John"},
                 @{@"index": @5, @"titel": @"📒  Ledger", @"subTitle" : @"Say: Ledger John"},
                 @{@"index": @6, @"titel": @"🔍  Product Search", @"subTitle" : @"Say: Say: R1"}
                 //@{@"index": @6, @"titel": @"📦 Product Search", @"subTitle" : @"Say: Say: R1"}
    ];
}

#pragma mark - Table View Data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [tblList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *myIdentifier = @"MyIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:myIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView *subContainView = [[UIView alloc] init];
    subContainView.frame = CGRectMake(10,5, tableView.frame.size.width - 20, 70);
    subContainView.backgroundColor = UIColor.whiteColor;
    subContainView.layer.cornerRadius = 10;
    subContainView.layer.borderColor = UIColor.lightGrayColor.CGColor;
    subContainView.layer.borderWidth = 1;
    subContainView.clipsToBounds = true;
    [cell.contentView addSubview:subContainView];
    
    UILabel *lbl_itemname = [[UILabel alloc] init];
    lbl_itemname.frame = CGRectMake(15,10, subContainView.frame.size.width-30, 25);
    [lbl_itemname setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    lbl_itemname.text = [NSString stringWithFormat:@"%@",[[tblList valueForKey:@"titel"] objectAtIndex:indexPath.row]];
    lbl_itemname.textAlignment = NSTextAlignmentLeft;
    lbl_itemname.textColor=[UIColor blackColor];
    [subContainView addSubview:lbl_itemname];
    
    UILabel *lbl_item01 = [[UILabel alloc] init];
    lbl_item01.frame = CGRectMake(15,40, subContainView.frame.size.width-30, 20);
    [lbl_item01 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
    lbl_item01.text = [NSString stringWithFormat:@"%@",[[tblList valueForKey:@"subTitle"] objectAtIndex:indexPath.row]];
    lbl_item01.textAlignment = NSTextAlignmentLeft;
    lbl_item01.textColor=[UIColor darkGrayColor];
    [subContainView addSubview:lbl_item01];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

@end

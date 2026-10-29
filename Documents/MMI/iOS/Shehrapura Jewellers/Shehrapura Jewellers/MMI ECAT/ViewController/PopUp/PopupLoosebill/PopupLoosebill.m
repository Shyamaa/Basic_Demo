//
//  PopupLoosebill.m
//  Jewel Desk
//
//  Created by App Dev on 06/08/24.
//  Copyright © 2024 MMI Softwares. All rights reserved.
//

#import "PopupLoosebill.h"
@interface PopupLoosebill ()
{
    NSString *str_fineback_s;
    NSString *str_fineback_g;
    NSString *str_fineback;
    NSString *str_itype;
    NSString *str_vrval;
    NSString *str_rate;
    NSString *str_rtunch;
    CGRect frame_fine;
    CGRect frame_gst;

}

@property (nonatomic, strong) UITextField *remarkButton;
@property (nonatomic, strong) UITextField *amountButton;
@property (nonatomic, strong) UITextField *goldtext;
@property (nonatomic, strong) UITextField *silvertext;
@property (nonatomic, strong) UIButton *btn_acname;
@property (nonatomic, strong) UIView *view_rec;
@property (nonatomic, strong) UIView *view_tran;
@property (nonatomic, strong) UIView *view_gpb;
@property (nonatomic, strong) UIView *view_metal;

@property (nonatomic, strong) UITextField *txt_gwt_gpb;
@property (nonatomic, strong) UITextField *txt_tunc_gpbh;
@property (nonatomic, strong) UITextField *txt_rate_gpb;
@property (nonatomic, strong) UITextField *txt_rtunch_gpb;
@property (nonatomic, strong) UILabel *txt_fine_gpb;

@property (nonatomic, strong) UIButton *btn_item_metal;

@property (nonatomic, strong) UITextField *txt_tgno_metal;
@property (nonatomic, strong) UITextField *txt_gwt_metal;
@property (nonatomic, strong) UITextField *txt_nwt_metal;
@property (nonatomic, strong) UITextField *txt_tunch_metal;
@property (nonatomic, strong) UITextField *txt_wstg_metal;
@property (nonatomic, strong) UITextField *txt_mrate_metal;
@property (nonatomic, strong) UILabel *txt_fine_metal;
@property (nonatomic, strong) UITextField *txt_amount_metal;

@property (nonatomic, strong) NSMutableArray<UIButton *> *radioButtons;
@property (nonatomic, strong) NSMutableArray<UILabel *> *radioButtonLabels;

@end

@implementation PopupLoosebill

@synthesize visid;

#pragma mark: - Class Method

- (void)viewDidLoad {
    [super viewDidLoad];
    str_vrval =@"1";
    checkgst = 0;
    
    [scrollview setScrollEnabled:YES];
    CGSize contentSize = CGSizeMake(scrollview.frame.size.width, 900);
    scrollview.contentSize = contentSize;
    
    [txt_remark addTarget:self action:@selector(text_remark:) forControlEvents:UIControlEventEditingChanged];
    [txt_pc addTarget:self action:@selector(text_pc:) forControlEvents:UIControlEventEditingChanged];
    [txt_gwt addTarget:self action:@selector(text_gwt:) forControlEvents:UIControlEventEditingChanged];
    [txt_lwt addTarget:self action:@selector(text_lwt:) forControlEvents:UIControlEventEditingChanged];
    [txt_nwt addTarget:self action:@selector(text_nwt:) forControlEvents:UIControlEventEditingChanged];
    [txt_tunch addTarget:self action:@selector(text_tunch:) forControlEvents:UIControlEventEditingChanged];
    [txt_wstg addTarget:self action:@selector(text_wstg:) forControlEvents:UIControlEventEditingChanged];
    [txt_mrate addTarget:self action:@selector(text_mrate:) forControlEvents:UIControlEventEditingChanged];
    [txt_lbr addTarget:self action:@selector(text_lbr:) forControlEvents:UIControlEventEditingChanged];
    // [txt_rtunch addTarget:self action:@selector(text_rtunch:) forControlEvents:UIControlEventEditingChanged];
    // [txt_rate addTarget:self action:@selector(text_rate:) forControlEvents:UIControlEventEditingChanged];
    frame_fine = view_fine.frame;
    frame_gst = view_gst.frame;
    
//    btn_type.layer.borderWidth=1.0f;
    btn_type.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    btn_item.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    btn_stamp.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    btn_lbron.layer.borderColor=[[UIColor lightGrayColor] CGColor];
//    btn_type.layer.cornerRadius = 10;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == txt_remark) {
        [txt_pc becomeFirstResponder];
    }  else if (textField == txt_pc) {
        [txt_gwt becomeFirstResponder];
    }  else if (textField == txt_gwt) {
        [txt_lwt becomeFirstResponder];
    } else if (textField == txt_lwt) {
        [txt_nwt becomeFirstResponder];
    } else if (textField == txt_nwt) {
        [txt_tunch becomeFirstResponder];
    } else if (textField == txt_tunch) {
        [txt_wstg becomeFirstResponder];
    }else if (textField == txt_wstg) {
        [txt_mrate becomeFirstResponder];
    }else if (textField == txt_mrate) {
        [txt_lbr resignFirstResponder];
    }else if (textField == txt_lbr) {
        [txt_tunch becomeFirstResponder];
    }else if (textField == txt_tunch) {
        [txt_rtunch becomeFirstResponder];
    }else if (textField == txt_rate) {
        [txt_rate becomeFirstResponder];
    }else if (textField == txt_rtunch) {
        [txt_rtunch resignFirstResponder];
    }else if (textField == txt_tagNo) {
        [txt_tagNo resignFirstResponder];
    } else{
        [textField resignFirstResponder];
    }
    return YES;
}

-(void)text_remark:(UITextField *)textField{
    NSLog(@"textfield text_remark %@ ",textField.text);
}

-(void)text_pc:(UITextField *)textField{
    NSLog(@"textfield text_pc %@ ",textField.text);
}

-(void)text_gwt:(UITextField *)textField{
    NSLog(@"textfield text_gwt %@ ",textField.text);
    str_gwt = textField.text;
    NSString *str_lbron = btn_lbron.titleLabel.text;
    [self CalValueWithGwt:str_gwt lwt:str_lwt tunch:str_tunch wstg:str_wstg mrate:str_mrate lbr:str_lbr str_lbron:str_lbron];
}

-(void)text_lwt:(UITextField *)textField{
    NSLog(@"textfield text_lwt %@ ",textField.text);
    str_lwt = textField.text;
    NSString *str_lbron = btn_lbron.titleLabel.text;
    [self CalValueWithGwt:str_gwt lwt:str_lwt tunch:str_tunch wstg:str_wstg mrate:str_mrate lbr:str_lbr str_lbron:str_lbron];
}

-(void)text_nwt:(UITextField *)textField{
    NSLog(@"textfield text_nwt %@ ",textField.text);
}

-(void)text_tunch:(UITextField *)textField{
    NSLog(@"textfield text_tunch %@ ",textField.text);
    str_tunch = textField.text;
    NSString *str_lbron = btn_lbron.titleLabel.text;
    [self CalValueWithGwt:str_gwt lwt:str_lwt tunch:str_tunch wstg:str_wstg mrate:str_mrate lbr:str_lbr str_lbron:str_lbron];
}

-(void)text_wstg:(UITextField *)textField{
    NSLog(@"textfield text_wstg %@ ",textField.text);
    str_wstg = textField.text;
    NSString *str_lbron = btn_lbron.titleLabel.text;
    [self CalValueWithGwt:str_gwt lwt:str_lwt tunch:str_tunch wstg:str_wstg mrate:str_mrate lbr:str_lbr str_lbron:str_lbron];
}

-(void)text_mrate:(UITextField *)textField{
    NSLog(@"textfield text_mrate %@ ",textField.text);
    str_mrate = textField.text;
    NSString *str_lbron = btn_lbron.titleLabel.text;
    [self CalValueWithGwt:str_gwt lwt:str_lwt tunch:str_tunch wstg:str_wstg mrate:str_mrate lbr:str_lbr str_lbron:str_lbron];
}

-(void)text_lbr:(UITextField *)textField{
    NSLog(@"textfield text_lbr %@ ",textField.text);
    str_lbr = textField.text;
    NSString *str_lbron = btn_lbron.titleLabel.text;
    [self CalValueWithGwt:str_gwt lwt:str_lwt tunch:str_tunch wstg:str_wstg mrate:str_mrate lbr:str_lbr str_lbron:str_lbron];
}

- (void)CalValueWithmetal:(NSString *)str_gwt lwt:(NSString *)str_lwt tunch:(NSString *)str_tunch wstg:(NSString *)str_wstg mrate:(NSString *)str_mrate lbr:(NSString *)str_lbr str_lbron:(NSString *)str_lbron {
    NSString *finedecimal = [[NSUserDefaults standardUserDefaults]stringForKey:@"finedecimal"];
    NSString *sill_lbr = [[NSUserDefaults standardUserDefaults]stringForKey:@"vrval"];
    NSString *type = btn_type.titleLabel.text;
    NSString *str_type = type;
    if ([type isEqualToString:@"Sale"]) {
        str_type = @"S";
    } else if ([type isEqualToString:@"Purchase"]) {
        str_type = @"P";
    } else if ([type isEqualToString:@"Sale Return"]) {
        str_type = @"SR";
    } else if ([type isEqualToString:@"Metal Receipt"]) {
        str_type = @"MR";
    } else if ([type isEqualToString:@"Metal Payment"]) {
        str_type = @"MP";
    } else if ([type isEqualToString:@"Receipt"]) {
        str_type = @"REC";
    } else if ([type isEqualToString:@"Payment"]) {
        str_type = @"PAY";
    } else if ([type isEqualToString:@"Gold Purchase Bhav"]) {
        str_type = @"GPB";
    } else if ([type isEqualToString:@"Gold Sale Bhav"]) {
        str_type = @"GSB";
    } else if ([type isEqualToString:@"Silver Purchase Bhav"]) {
        str_type = @"SPB";
    } else if ([type isEqualToString:@"Silver Sale Bhav"]) {
        str_type = @"SSB";
    } else if ([type isEqualToString:@"Transfer"]) {
        str_type = @"TRN";
    }

    double f_grwt = [str_gwt doubleValue];
    double f_nrwt = f_grwt;
    _txt_nwt_metal.text = [NSString stringWithFormat:@"%.3f", f_nrwt];
    
    double f_tunch = [str_tunch doubleValue];
    double f_wstg = [str_wstg doubleValue];
    double f_lbr = 0.00;
    
    double f_fine = f_nrwt*(f_tunch+f_wstg)/100;
    double f_amount;
    double f_mrate;

    NSString *str_pc = @"1";
    
    double f_pc = [str_pc doubleValue];
    if (str_mrate.length != 0)
    {
        _txt_fine_metal.text = @"0";
        float f_mrate = [str_mrate floatValue];
        f_mrate = f_mrate / [str_vrval intValue];
        if (str_lbr.length !=0) {
            if ([str_lbron isEqualToString:@"Gr.Wt"]) {
                if (([str_itype isEqualToString:@"3"] || [str_itype isEqualToString:@"4"]) && [sill_lbr isEqualToString:@"1"]) {
                    f_lbr /= 1000;
                }
                
                if (str_tunch.length !=0) {
                    f_amount = (f_lbr * f_grwt) + (f_fine * f_mrate);
                } else {
                    f_amount = (f_lbr * f_grwt) + (f_nrwt * f_mrate);
                }
            } else if ([str_lbron isEqualToString:@"N.Wt"]) {
                if (([str_itype isEqualToString:@"3"] || [str_itype isEqualToString:@"4"]) && [sill_lbr isEqualToString:@"1"]) {
                    f_lbr /= 1000;
                }
                
                f_grwt = f_nrwt;
                if (str_tunch.length !=0) {
                    f_amount = (f_lbr * f_grwt) + (f_fine * f_mrate);
                } else {
                    f_amount = (f_lbr * f_grwt) + (f_nrwt * f_mrate);
                }
            } else if ([str_lbron isEqualToString:@"Rs"]) {
                if (str_tunch.length != 0) {
                    f_amount = f_lbr + (f_fine * f_mrate);
                } else {
                    f_amount = f_lbr + (f_nrwt * f_mrate);
                }
            } else if ([str_lbron isEqualToString:@"%"]) {
                if (str_tunch.length !=0) {
                    f_amount = (f_fine * f_mrate) + ((f_fine * f_mrate) * f_lbr / 100);
                } else {
                    f_amount = (f_nrwt * f_mrate) + ((f_nrwt * f_mrate) * f_lbr / 100);
                }
            } else {
                f_grwt = f_pc;
                if (str_tunch.length !=0) {
                    f_amount = (f_lbr * f_grwt) + (f_fine * f_mrate);
                } else {
                    f_amount = (f_lbr * f_grwt) + (f_nrwt * f_mrate);
                }
            }
        } else {
            if (str_tunch.length !=0) {
                f_amount = f_fine * f_mrate;
            } else {
                f_amount = f_nrwt * f_mrate;
            }
        }
        
        if (f_amount == 0.0 || f_amount == 0) {
            NSString *amt = [NSString stringWithFormat:@"%f", f_pc * f_mrate];
            NSString *formattedValue = [amt stringByReplacingOccurrencesOfString:@"\\.\\d+" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [amt length])];
            int intValue = [formattedValue intValue];
            NSString *str_totalamt = [NSString stringWithFormat:@"%d", intValue];
            _txt_amount_metal.text = str_totalamt;
        } else {
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
            [formatter setMaximumFractionDigits:0];
            NSString *formattedValue = [formatter stringFromNumber:[NSNumber numberWithFloat:f_amount]];
            int intValue = [formattedValue intValue];
            NSString *str_totalamt = [NSString stringWithFormat:@"%d", intValue];
            _txt_amount_metal.text = str_totalamt;
        }
    }else{
        NSString *str_totalfine = @"";
        if ([finedecimal isEqualToString:@"0"]) {
            NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
            [decimalFormatter setNumberStyle:NSNumberFormatterNoStyle];
            NSString *formattedValue = [decimalFormatter stringFromNumber:@(f_fine)];
            int intValue = formattedValue.intValue;
            str_totalfine = [NSString stringWithFormat:@"%d", intValue];
        } else if ([finedecimal isEqualToString:@"1"]) {
            str_totalfine = [NSString stringWithFormat:@"%.1f", f_fine];
        } else if ([finedecimal isEqualToString:@"2"]) {
            str_totalfine = [NSString stringWithFormat:@"%.2f", f_fine];
        } else {
            str_totalfine = [NSString stringWithFormat:@"%.3f", f_fine];
        }
        _txt_fine_metal.text = str_totalfine;
        if (str_lbr.length == 0) {
            f_amount = 0;
        } else {
            if ([str_lbron isEqualToString:@"Gr.Wt"]) {
                if (([str_itype isEqualToString:@"3"] || [str_itype isEqualToString:@"4"]) && [sill_lbr isEqualToString:@"1"]) {
                    f_lbr = f_lbr / 1000;
                }
                f_amount = f_grwt * f_lbr;
            } else if ([str_lbron isEqualToString:@"N.Wt"]) {
                if (([str_itype isEqualToString:@"3"] || [str_itype isEqualToString:@"4"]) && [sill_lbr isEqualToString:@"1"]) {
                    f_lbr = f_lbr / 1000;
                }
                f_grwt = f_nrwt;
                f_amount = f_grwt * f_lbr;
            } else if ([str_lbron isEqualToString:@"Rs"]) {
                f_amount = f_lbr;
            } else {
                f_grwt = f_pc;
                f_amount = f_grwt * f_lbr;
            }
        }
        f_mrate = 0;
        NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
        [decimalFormatter setNumberStyle:NSNumberFormatterNoStyle];
        NSString *formattedValue = [decimalFormatter stringFromNumber:@(f_amount)];
        int intValue = formattedValue.intValue;
        NSString *str_totalamt = [NSString stringWithFormat:@"%d", intValue];
        _txt_amount_metal.text = str_totalamt;
    }
}

- (void)CalValueWithGwt_bhav {
    NSString *str_type = btn_type.titleLabel.text;
    NSString *type = btn_type.titleLabel.text;
    if ([type isEqualToString:@"Sale"]) {
        str_type = @"S";
    } else if ([type isEqualToString:@"Purchase"]) {
        str_type = @"P";
    } else if ([type isEqualToString:@"Sale Return"]) {
        str_type = @"SR";
    } else if ([type isEqualToString:@"Metal Receipt"]) {
        str_type = @"MR";
    } else if ([type isEqualToString:@"Metal Payment"]) {
        str_type = @"MP";
    } else if ([type isEqualToString:@"Receipt"]) {
        str_type = @"REC";
    } else if ([type isEqualToString:@"Payment"]) {
        str_type = @"PAY";
    } else if ([type isEqualToString:@"Gold Purchase Bhav"]) {
        str_type = @"GPB";
    } else if ([type isEqualToString:@"Gold Sale Bhav"]) {
        str_type = @"GSB";
    } else if ([type isEqualToString:@"Silver Purchase Bhav"]) {
        str_type = @"SPB";
    } else if ([type isEqualToString:@"Silver Sale Bhav"]) {
        str_type = @"SSB";
    } else if ([type isEqualToString:@"Transfer"]) {
        str_type = @"TRN";
    }
    NSString * str_b_wet = str_gwt;
    NSString *str_b_tunch = str_tunch;
    NSString *str_b_rate = str_rate;
    NSString *str_b_rtunch = str_rtunch;
    NSString * str_b_amt = _amountButton.text;
    double f_b_amt;
    float f_b_wet, f_b_tunch, f_b_rate, f_b_rtunch, f_b_fine;

    if ([str_b_wet isEqualToString:@""] || [str_b_wet isEqualToString:@"."] || [str_b_wet isEqualToString:@".00"]) {
        f_b_wet = 0;
    } else {
        f_b_wet = [str_b_wet floatValue];
    }

    if ([str_b_tunch isEqualToString:@""] || [str_b_tunch isEqualToString:@"."] || [str_b_tunch isEqualToString:@".00"] || str_b_tunch.length ==0) {
        f_b_tunch = 100;
    } else {
        f_b_tunch = [str_b_tunch floatValue];
    }

    f_b_fine = (f_b_wet * f_b_tunch) / 100;
    _txt_fine_gpb.text = [NSString stringWithFormat:@"%f",f_b_fine];

    if ([str_b_rate isEqualToString:@""] || [str_b_rate isEqualToString:@"."] || [str_b_rate isEqualToString:@".00"] || str_b_rate.length ==0) {
        f_b_rate = 0;
    } else {
        f_b_rate = [str_b_rate floatValue];
    }

    if ([str_b_rtunch isEqualToString:@""] || [str_b_rtunch isEqualToString:@"."] || [str_b_rtunch isEqualToString:@".00"] || str_b_rtunch.length == 0) {
        f_b_rtunch = 100;
    } else {
        f_b_rtunch = [str_b_rtunch floatValue];
    }

    if ([str_b_amt isEqualToString:@""] || [str_b_amt isEqualToString:@"."] || [str_b_amt isEqualToString:@".00"]) {
        f_b_amt = 0;
    } else {
        f_b_amt = [str_b_amt floatValue];
    }

    f_b_amt = (f_b_fine * (f_b_rate * 100 / f_b_rtunch));
    NSLog(@"***************** Procedure_gpb: f_b_amt %f", f_b_amt);

    int gbhav_vrval = 0, sbhav_vrval = 0;
    NSString *str_sbhav = [[NSUserDefaults standardUserDefaults]stringForKey:@"sbhav_vrval"];
    NSString *str_gbhav = [[NSUserDefaults standardUserDefaults]stringForKey:@"gbhav_vrval"];
    
    if (str_gbhav.length !=0) {
        gbhav_vrval = [str_gbhav intValue];
    }
    if (str_sbhav.length !=0) {
        sbhav_vrval = [str_sbhav intValue];
    }

    if ([type isEqualToString:@"Gold Purchase Bhav"] || [type isEqualToString:@"Gold Sale Bhav"]) {
        f_b_amt = f_b_amt / gbhav_vrval;
    } else if ([type isEqualToString:@"Silver Purchase Bhav"] || [type isEqualToString:@"Silver Sale Bhav"]) {
        f_b_amt = f_b_amt / sbhav_vrval;
    }

    NSString *str_f_amount = [NSString stringWithFormat:@"%.2f", f_b_amt];
    NSLog(@"***************** Procedure_gpb: %@", str_f_amount);

    _amountButton.text = str_f_amount;
}

- (void)CalValueWithGwt:(NSString *)str_gwt lwt:(NSString *)str_lwt tunch:(NSString *)str_tunch wstg:(NSString *)str_wstg mrate:(NSString *)str_mrate lbr:(NSString *)str_lbr str_lbron:(NSString *)str_lbron {
   
    NSString *finedecimal = [[NSUserDefaults standardUserDefaults]stringForKey:@"finedecimal"];
    NSString *sill_lbr = [[NSUserDefaults standardUserDefaults]stringForKey:@"vrval"];
    NSString * str_amount1 = @"";
    
    NSString *type = btn_type.titleLabel.text;


    NSString *str_type = type;
    if ([type isEqualToString:@"Sale"]) {
        str_type = @"S";
    } else if ([type isEqualToString:@"Purchase"]) {
        str_type = @"P";
    } else if ([type isEqualToString:@"Sale Return"]) {
        str_type = @"SR";
    } else if ([type isEqualToString:@"Metal Receipt"]) {
        str_type = @"MR";
    } else if ([type isEqualToString:@"Metal Payment"]) {
        str_type = @"MP";
    } else if ([type isEqualToString:@"Receipt"]) {
        str_type = @"REC";
    } else if ([type isEqualToString:@"Payment"]) {
        str_type = @"PAY";
    } else if ([type isEqualToString:@"Gold Purchase Bhav"]) {
        str_type = @"GPB";
    } else if ([type isEqualToString:@"Gold Sale Bhav"]) {
        str_type = @"GSB";
    } else if ([type isEqualToString:@"Silver Purchase Bhav"]) {
        str_type = @"SPB";
    } else if ([type isEqualToString:@"Silver Sale Bhav"]) {
        str_type = @"SSB";
    } else if ([type isEqualToString:@"Transfer"]) {
        str_type = @"TRN";
    }

    
    double f_grwt = [str_gwt doubleValue];
    double f_lrwt = [str_lwt doubleValue];
    double f_nrwt = f_grwt-f_lrwt;
    txt_nwt.text = [NSString stringWithFormat:@"%.3f", f_nrwt];
    
    double f_tunch = [str_tunch doubleValue];
    double f_wstg = [str_wstg doubleValue];
    double f_lbr = [str_lbr doubleValue];
    
    double f_fine = f_nrwt*(f_tunch+f_wstg)/100;
    double f_amount;
    double f_mrate;

    NSString *str_pc = txt_pc.text;
    if (str_pc.length == 0) {
        str_pc = @"0";
    }
    
    double f_pc = [str_pc doubleValue];
    if (str_mrate.length != 0)
    {
        if ([str_type isEqualToString:@"REC"] || [str_type isEqualToString:@"PAY"]) 
        {
            float f_mrate = [str_mrate floatValue];
            float f_amount1 = [str_amount1 floatValue];
            
            float totalfine = f_amount1 / f_mrate;
            NSString *str_totalfine = @"";
            if ([finedecimal isEqualToString:@"0"]) {
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                [formatter setMaximumFractionDigits:0];
                NSString *formattedValue = [formatter stringFromNumber:[NSNumber numberWithFloat:totalfine]];
                int intValue = [formattedValue intValue];
                str_totalfine = [NSString stringWithFormat:@"%d", intValue];
            } else if ([finedecimal isEqualToString:@"1"]) {
                str_totalfine = [NSString stringWithFormat:@"%.1f", totalfine];
            } else if ([finedecimal isEqualToString:@"2"]) {
                str_totalfine = [NSString stringWithFormat:@"%.2f", totalfine];
            } else {
                str_totalfine = [NSString stringWithFormat:@"%.3f", totalfine];
            }
            
            txt_fine.text = str_totalfine;
            txt_amt.text = @"0";
            [self CheckGST];
        } else {
            
            if ([str_itype isEqualToString:@"3"] || [str_itype isEqualToString:@"4"]) {
                str_fineback_s = [NSString stringWithFormat:@"%f", f_fine];
            } else {
                str_fineback_g = [NSString stringWithFormat:@"%f", f_fine];
            }
            
            str_fineback = [NSString stringWithFormat:@"%f", f_fine];
            txt_fine.text = @"0";
            float f_mrate = [str_mrate floatValue];
            f_mrate = f_mrate / [str_vrval intValue];
            if (str_lbr.length !=0) {
                if ([str_lbron isEqualToString:@"Gr.Wt"]) {
                    if (([str_itype isEqualToString:@"3"] || [str_itype isEqualToString:@"4"]) && [sill_lbr isEqualToString:@"1"]) {
                        f_lbr /= 1000;
                    }
                    
                    if (str_tunch.length !=0) {
                        f_amount = (f_lbr * f_grwt) + (f_fine * f_mrate);
                    } else {
                        f_amount = (f_lbr * f_grwt) + (f_nrwt * f_mrate);
                    }
                } else if ([str_lbron isEqualToString:@"N.Wt"]) {
                    if (([str_itype isEqualToString:@"3"] || [str_itype isEqualToString:@"4"]) && [sill_lbr isEqualToString:@"1"]) {
                        f_lbr /= 1000;
                    }
                    
                    f_grwt = f_nrwt;
                    if (str_tunch.length !=0) {
                        f_amount = (f_lbr * f_grwt) + (f_fine * f_mrate);
                    } else {
                        f_amount = (f_lbr * f_grwt) + (f_nrwt * f_mrate);
                    }
                } else if ([str_lbron isEqualToString:@"Rs"]) {
                    if (str_tunch.length != 0) {
                        f_amount = f_lbr + (f_fine * f_mrate);
                    } else {
                        f_amount = f_lbr + (f_nrwt * f_mrate);
                    }
                } else if ([str_lbron isEqualToString:@"%"]) {
                    if (str_tunch.length !=0) {
                        f_amount = (f_fine * f_mrate) + ((f_fine * f_mrate) * f_lbr / 100);
                    } else {
                        f_amount = (f_nrwt * f_mrate) + ((f_nrwt * f_mrate) * f_lbr / 100);
                    }
                } else {
                    f_grwt = f_pc;
                    if (str_tunch.length !=0) {
                        f_amount = (f_lbr * f_grwt) + (f_fine * f_mrate);
                    } else {
                        f_amount = (f_lbr * f_grwt) + (f_nrwt * f_mrate);
                    }
                }
            } else {
                if (str_tunch.length !=0) {
                    f_amount = f_fine * f_mrate;
                } else {
                    f_amount = f_nrwt * f_mrate;
                }
            }
            
            if (f_amount == 0.0 || f_amount == 0) {
                NSString *amt = [NSString stringWithFormat:@"%f", f_pc * f_mrate];
                NSString *formattedValue = [amt stringByReplacingOccurrencesOfString:@"\\.\\d+" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [amt length])];
                int intValue = [formattedValue intValue];
                NSString *str_totalamt = [NSString stringWithFormat:@"%d", intValue];
                txt_amt.text = str_totalamt;
            } else {
                NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
                [formatter setMaximumFractionDigits:0];
                NSString *formattedValue = [formatter stringFromNumber:[NSNumber numberWithFloat:f_amount]];
                int intValue = [formattedValue intValue];
                NSString *str_totalamt = [NSString stringWithFormat:@"%d", intValue];
                txt_amt.text = str_totalamt;
            }
            
            [self CheckGST];
        }

        
    }else{
        
        if ([str_type isEqualToString:@"REC"] || [str_type isEqualToString:@"PAY"]) {
            if ([str_itype isEqualToString:@"3"] || [str_itype isEqualToString:@"4"]) {
                str_fineback_s = [NSString stringWithFormat:@"%.3f", f_fine];
            } else {
                str_fineback_g = [NSString stringWithFormat:@"%.3f", f_fine];
            }
            str_fineback = [NSString stringWithFormat:@"%.3f", f_fine];
            NSString *str_f_fine = [NSString stringWithFormat:@"%.3f", f_fine];
            NSString *str_totalfine = @"";
            
            if ([finedecimal isEqualToString:@"0"])
            {
                NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
                [decimalFormatter setNumberStyle:NSNumberFormatterNoStyle];
                NSString *formattedValue = [decimalFormatter stringFromNumber:@(str_f_fine.doubleValue)];
                int intValue = formattedValue.intValue;
                str_totalfine = [NSString stringWithFormat:@"%d", intValue];
            } else if ([finedecimal isEqualToString:@"1"]) {
                str_totalfine = [NSString stringWithFormat:@"%.1f", str_f_fine.doubleValue];
            } else if ([finedecimal isEqualToString:@"2"]) {
                str_totalfine = [NSString stringWithFormat:@"%.2f", str_f_fine.doubleValue];
            } else {
                str_totalfine = [NSString stringWithFormat:@"%.3f", str_f_fine.doubleValue];
            }
            txt_fine.text = str_totalfine;
            
            NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
            [decimalFormatter setNumberStyle:NSNumberFormatterNoStyle];
            NSString *formattedValue = [decimalFormatter stringFromNumber:@(str_amount1.doubleValue)];
            int intValue = formattedValue.intValue;
            
            if (([str_itype isEqualToString:@"3"] || [str_itype isEqualToString:@"4"]) && [sill_lbr isEqualToString:@"1"])
            {
                intValue = intValue / 1000;
            }
            
            NSString *str_totalamt = [NSString stringWithFormat:@"%d", intValue];
            txt_amt.text = str_totalamt;
            [self CheckGST];
            
        } else {
            if ([str_itype isEqualToString:@"3"] || [str_itype isEqualToString:@"4"]) {
                str_fineback_s = [NSString stringWithFormat:@"%.3f", f_fine];
            } else {
                str_fineback_g = [NSString stringWithFormat:@"%.3f", f_fine];
            }
            str_fineback = [NSString stringWithFormat:@"%.3f", f_fine];
            
            NSString *str_totalfine = @"";
            
            if ([finedecimal isEqualToString:@"0"]) {
                NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
                [decimalFormatter setNumberStyle:NSNumberFormatterNoStyle];
                NSString *formattedValue = [decimalFormatter stringFromNumber:@(f_fine)];
                int intValue = formattedValue.intValue;
                str_totalfine = [NSString stringWithFormat:@"%d", intValue];
            } else if ([finedecimal isEqualToString:@"1"]) {
                str_totalfine = [NSString stringWithFormat:@"%.1f", f_fine];
            } else if ([finedecimal isEqualToString:@"2"]) {
                str_totalfine = [NSString stringWithFormat:@"%.2f", f_fine];
            } else {
                str_totalfine = [NSString stringWithFormat:@"%.3f", f_fine];
            }
            txt_fine.text = str_totalfine;
            
            if (str_lbr.length == 0) {
                f_amount = 0;
            } else {
                if ([str_lbron isEqualToString:@"Gr.Wt"]) {
                    if (([str_itype isEqualToString:@"3"] || [str_itype isEqualToString:@"4"]) && [sill_lbr isEqualToString:@"1"]) {
                        f_lbr = f_lbr / 1000;
                    }
                    f_amount = f_grwt * f_lbr;
                } else if ([str_lbron isEqualToString:@"N.Wt"]) {
                    if (([str_itype isEqualToString:@"3"] || [str_itype isEqualToString:@"4"]) && [sill_lbr isEqualToString:@"1"]) {
                        f_lbr = f_lbr / 1000;
                    }
                    f_grwt = f_nrwt;
                    f_amount = f_grwt * f_lbr;
                } else if ([str_lbron isEqualToString:@"Rs"]) {
                    f_amount = f_lbr;
                } else {
                    f_grwt = f_pc;
                    f_amount = f_grwt * f_lbr;
                }
                
            }
            
            f_mrate = 0;
            NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
            [decimalFormatter setNumberStyle:NSNumberFormatterNoStyle];
            NSString *formattedValue = [decimalFormatter stringFromNumber:@(f_amount)];
            int intValue = formattedValue.intValue;
            NSString *str_totalamt = [NSString stringWithFormat:@"%d", intValue];
            txt_amt.text = str_totalamt;
            [self CheckGST];
        }
    }
}

- (void)CheckGST{
    txt_gstvalue.text =@"3";
    if (checkgst) {
        double int_gst = 3.0;
        double int_amt = [txt_amt.text doubleValue];
        double total_amount = int_amt + ((int_amt * int_gst) / 100);
        txt_gstamt.text = [NSString stringWithFormat:@"%f", total_amount];
    } else {
        double int_amt = [txt_amt.text doubleValue];
        txt_gstamt.text = [NSString stringWithFormat:@"%f", int_amt];
    }
}

- (IBAction)btn_lbron:(id)sender {
    [self Alert_lbron];
}

- (IBAction)btn_cancel:(id)sender {
    if (self.completionHandler) {
       self.completionHandler(@"",@"", @"",@"Cancel");
   }
   [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btn_save:(id)sender {
    NSString * str_type = btn_type.titleLabel.text;
    NSString * str_item = btn_item.titleLabel.text;

    if ([str_type isEqualToString:@"Select Type"]) {
        NSString * str_msg = @"Please select type";
        [self showAlertWithMessage:str_msg];

    }else{
        NSArray *mandatoryTypes = @[@"Sale", @"Sale Return", @"Purchase", @"ORD"];
        if ([mandatoryTypes containsObject:str_type]) {
            if (([str_item isEqualToString:@"Select item"]) || (txt_gwt.text.length == 0)) {
                NSString *str_msg = @"Please enter gross wt and item";
                [self showAlertWithMessage:str_msg];
            } else {
                [self InsertFeed];
            }
        } else if ([str_type isEqualToString:@"Metal Receipt"] || [str_type isEqualToString:@"Metal Payment"]) {
            NSString * str_item = _btn_item_metal.titleLabel.text;

            if (([str_item isEqualToString:@"Select item"]) || (_txt_gwt_metal.text.length == 0)) {
                NSString *str_msg = @"Please enter gross wt and item";
                [self showAlertWithMessage:str_msg];
            } else {
                [self InsertFeed];
            }
        } else if ([str_type isEqualToString:@"Receipt"] || [str_type isEqualToString:@"Payment"]) {
            NSString * from_acc = _btn_acname.titleLabel.text;
            if ([from_acc isEqualToString:@"A/C Name"]) {
                NSString *str_msg = @"Please select ac name";
                [self showAlertWithMessage:str_msg];
            } else if (_amountButton.text.length == 0) {
                NSString *str_msg = @"Please enter amount";
                [self showAlertWithMessage:str_msg];
            } else {
                [self InsertFeed];
            }
        }else if ([str_type isEqualToString:@"Transfer"]) {
            NSString * from_acc = _btn_acname.titleLabel.text;
            if ([from_acc isEqualToString:@"A/C Name"]) {
                NSString *str_msg = @"Please select ac name";
                [self showAlertWithMessage:str_msg];
            } else if (_goldtext.text.length == 0 && _silvertext.text.length == 0 && _amountButton.text.length == 0) {
                NSString *str_msg = @"Please enter gold silver and amount";
                [self showAlertWithMessage:str_msg];
            } else {
                [self InsertFeed];
            }
        }else if ([str_type isEqualToString:@"Gold Purchase Bhav"] || [str_type isEqualToString:@"Gold Sale Bhav"] || [str_type isEqualToString:@"Silver Purchase Bhav"] || [str_type isEqualToString:@"Silver Sale Bhav"]) {
           
            if (_txt_gwt_gpb.text.length == 0) {
               NSString *str_msg = @"Please enter gold silver and amount";
               [self showAlertWithMessage:str_msg];
           } else {
               [self InsertFeed];
           }
            
        } else{
            [self InsertFeed];
        }
    }
}
- (void)showAlertWithMessage:(NSString *)message {
    // Create an UIAlertController
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Message"
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                     }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (IBAction)btn_stamp:(id)sender {
    [self Alert_stamp];
}

- (IBAction)btn_item:(id)sender {
    [self Alert_item];
}

- (IBAction)btn_type:(id)sender {
    [self Alert_Type];
}

-(void)Alert_lbron {
    array_lbron = [[NSMutableArray alloc]init];
    [array_lbron addObject:@"Gr.Wt"];
    [array_lbron addObject:@"N.Wt"];
    [array_lbron addObject:@"Pc"];
    [array_lbron addObject:@"Rs"];
    [array_lbron addObject:@"%"];

    controller_lbron = [[UIViewController alloc]init];
    CGRect rect;
    
    rect = CGRectMake(0, 0, self.view.frame.size.width, 40*[array_lbron count]);
    [controller_lbron setPreferredContentSize:rect.size];
    
    [table_lbron reloadData];
    table_lbron = [[UITableView alloc]initWithFrame:rect];
    table_lbron.delegate = self;
    table_lbron.dataSource = self;
    table_lbron.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [table_lbron setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [table_lbron setTag:1000];
    [controller_lbron.view addSubview:table_lbron];
    [controller_lbron.view bringSubviewToFront:table_lbron];
    [controller_lbron.view setUserInteractionEnabled:YES];
    [table_lbron setUserInteractionEnabled:YES];
    [table_lbron setAllowsSelection:YES];
    [table_lbron reloadData];
    ac_tyep = [UIAlertController alertControllerWithTitle:NULL message:nil preferredStyle:UIAlertControllerStyleAlert];
    [ac_tyep setValue:controller_lbron forKey:@"contentViewController"];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSLog(@"000000000000");
        [self->btn_lbron setTitle:@"" forState:UIControlStateNormal];
    }];
    
    [ac_tyep addAction:cancelAction];
    [self presentViewController:ac_tyep animated:YES completion:nil];
}

-(void)Alert_Type {
    array_type = [[NSMutableArray alloc]init];
    [array_type addObject:@"ORD"];
    [array_type addObject:@"Sale"];
    [array_type addObject:@"Sale Return"];
    [array_type addObject:@"Purchase"];
    [array_type addObject:@"Metal Receipt"];
    [array_type addObject:@"Metal Payment"];
    [array_type addObject:@"Receipt"];
    [array_type addObject:@"Payment"];
    [array_type addObject:@"Gold Purchase Bhav"];
    [array_type addObject:@"Gold Sale Bhav"];
    [array_type addObject:@"Silver Purchase Bhav"];
    [array_type addObject:@"Silver Sale Bhav"];
    [array_type addObject:@"Transfer"];

    controller_type = [[UIViewController alloc]init];
    CGRect rect;
    
    rect = CGRectMake(0, 0, self.view.frame.size.width, 40*[array_type count]);
    [controller_type setPreferredContentSize:rect.size];
    
    [table_type reloadData];
    table_type  = [[UITableView alloc]initWithFrame:rect];
    table_type.delegate = self;
    table_type.dataSource = self;
    table_type.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [table_type setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [table_type setTag:1000];
    [controller_type.view addSubview:table_type];
    [controller_type.view bringSubviewToFront:table_type];
    [controller_type.view setUserInteractionEnabled:YES];
    [table_type setUserInteractionEnabled:YES];
    [table_type setAllowsSelection:YES];
    [table_type reloadData];
    ac_tyep = [UIAlertController alertControllerWithTitle:NULL message:nil preferredStyle:UIAlertControllerStyleAlert];
    [ac_tyep setValue:controller_type forKey:@"contentViewController"];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSLog(@"000000000000");
        [self->btn_type setTitle:@"Select Type" forState:UIControlStateNormal];
    }];
    [ac_tyep addAction:cancelAction];
    [self presentViewController:ac_tyep animated:YES completion:nil];
}

-(void)Alert_item {
    controller_item = [[UIViewController alloc]init];
    CGRect rect;
    
    rect = CGRectMake(0, 0, self.view.frame.size.width, 40*[array_item count]);
    [controller_item setPreferredContentSize:rect.size];
    
    [table_item reloadData];
    table_item  = [[UITableView alloc]initWithFrame:rect];
    table_item.delegate = self;
    table_item.dataSource = self;
    table_item.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [table_item setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [table_item setTag:1000];
    [controller_item.view addSubview:table_item];
    [controller_item.view bringSubviewToFront:table_item];
    [controller_item.view setUserInteractionEnabled:YES];
    [table_item setUserInteractionEnabled:YES];
    [table_item setAllowsSelection:YES];
    [table_item reloadData];
    ac_tyep = [UIAlertController alertControllerWithTitle:NULL message:nil preferredStyle:UIAlertControllerStyleAlert];
    [ac_tyep setValue:controller_item forKey:@"contentViewController"];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSLog(@"000000000000");
        [self->btn_item setTitle:@"Select Item" forState:UIControlStateNormal];
    }];
    [ac_tyep addAction:cancelAction];
    [self presentViewController:ac_tyep animated:YES completion:nil];
}

-(void)Alert_stamp {
    controller_stamp = [[UIViewController alloc]init];
    CGRect rect;
    
    rect = CGRectMake(0, 0, self.view.frame.size.width, 40*[array_stamp count]);
    [controller_stamp setPreferredContentSize:rect.size];
    
    [table_stamp reloadData];
    table_stamp  = [[UITableView alloc]initWithFrame:rect];
    table_stamp.delegate = self;
    table_stamp.dataSource = self;
    table_stamp.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [table_stamp setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [table_stamp setTag:1000];
    [controller_stamp.view addSubview:table_stamp];
    [controller_stamp.view bringSubviewToFront:table_stamp];
    [controller_stamp.view setUserInteractionEnabled:YES];
    [table_stamp setUserInteractionEnabled:YES];
    [table_stamp setAllowsSelection:YES];
    [table_stamp reloadData];
    ac_tyep = [UIAlertController alertControllerWithTitle:NULL message:nil preferredStyle:UIAlertControllerStyleAlert];
    [ac_tyep setValue:controller_stamp forKey:@"contentViewController"];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSLog(@"000000000000");
        [self->btn_stamp setTitle:@"Select Stamp" forState:UIControlStateNormal];
    }];
    [ac_tyep addAction:cancelAction];
    [self presentViewController:ac_tyep animated:YES completion:nil];
}

-(void)Alert_acname{
    [table_acname reloadData];
    controller_acname = [[UIViewController alloc]init];
    CGRect rect;
    rect = CGRectMake(0, 0, self.view.frame.size.width, 40*[array_acclist count]);
    [controller_acname setPreferredContentSize:rect.size];
     [table_acname reloadData];
     table_acname = [[UITableView alloc]initWithFrame:rect];
     table_acname.delegate = self;
     table_acname.dataSource = self;
     table_acname.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [table_acname setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [table_acname setTag:1000];
    [controller_acname.view addSubview:table_acname];
    [controller_acname.view bringSubviewToFront:table_acname];
    [controller_acname.view setUserInteractionEnabled:YES];
    [table_acname setUserInteractionEnabled:YES];
    [table_acname setAllowsSelection:YES];
    [table_acname reloadData];
     ac_acname = [UIAlertController alertControllerWithTitle:NULL message:nil preferredStyle:UIAlertControllerStyleAlert];
    [ac_acname setValue:controller_acname forKey:@"contentViewController"];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSLog(@"000000000000");
        self->str_pay_acno = @"";
        [self->_btn_acname setTitle:@"" forState:UIControlStateNormal];
    }];
    
    [ac_acname addAction:cancelAction];
    [self presentViewController:ac_acname animated:YES completion:nil];
}

#pragma mark: - TableView Delegate Datasource Method

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == table_item) {
        return [array_item count];
    }else if (tableView == table_stamp) {
        return [array_stamp count];
    }else if (tableView == table_lbron) {
        return [array_lbron count];
    }else if (tableView == table_acname) {
        return [array_acclist count];
    }else{
        return [array_type count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *myIdentifier = @"MyIdentifier";
    UITableViewCell *cell;
    
    if (tableView == table_item) {
        cell = [table_item dequeueReusableCellWithIdentifier:myIdentifier];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        if (!cell) {
            cell = [[UITableViewCell alloc]init];
        }

        UILabel *lbl_date = [[UILabel alloc] init];
        lbl_date.frame = CGRectMake(10,2, self.view.frame.size.width-20, 36);
        lbl_date.font = [UIFont fontWithName:@"Eras Demi ITC" size:13];
        lbl_date.text = [[array_item valueForKey:@"idesc"] objectAtIndex:indexPath.row];
        lbl_date.textColor=[UIColor blackColor];
        [cell.contentView addSubview:lbl_date];
    }else if (tableView == table_stamp) {
        cell = [table_stamp dequeueReusableCellWithIdentifier:myIdentifier];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        if (!cell) {
            cell = [[UITableViewCell alloc]init];
        }

        UILabel *lbl_date = [[UILabel alloc] init];
        lbl_date.frame = CGRectMake(10,2, self.view.frame.size.width-20, 36);
        lbl_date.font = [UIFont fontWithName:@"Eras Demi ITC" size:13];
        lbl_date.text = [[array_stamp valueForKey:@"stamp"] objectAtIndex:indexPath.row];
        lbl_date.textColor=[UIColor blackColor];
        [cell.contentView addSubview:lbl_date];
    }else if (tableView == table_lbron) {
        cell = [table_lbron dequeueReusableCellWithIdentifier:myIdentifier];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        if (!cell) {
            cell = [[UITableViewCell alloc]init];
        }

        UILabel *lbl_date = [[UILabel alloc] init];
        lbl_date.frame = CGRectMake(10,2, self.view.frame.size.width-20, 36);
        lbl_date.font = [UIFont fontWithName:@"Eras Demi ITC" size:13];
        lbl_date.text = [array_lbron objectAtIndex:indexPath.row];
        lbl_date.textColor=[UIColor blackColor];
        [cell.contentView addSubview:lbl_date];
    }else if (tableView == table_acname) {
        cell = [table_acname dequeueReusableCellWithIdentifier:myIdentifier];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        if (!cell) {
            cell = [[UITableViewCell alloc]init];
        }

        UILabel *lbl_date = [[UILabel alloc] init];
        lbl_date.frame = CGRectMake(10,2, self.view.frame.size.width-20, 36);
        lbl_date.font = [UIFont fontWithName:@"Eras Demi ITC" size:13];
        lbl_date.text = [[array_acclist valueForKey:@"cname"] objectAtIndex:indexPath.row];
        lbl_date.textColor=[UIColor blackColor];
        [cell.contentView addSubview:lbl_date];
        
    }else{
        cell = [table_type dequeueReusableCellWithIdentifier:myIdentifier];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        if (!cell) {
            cell = [[UITableViewCell alloc]init];
        }

        UILabel *lbl_date = [[UILabel alloc] init];
        lbl_date.frame = CGRectMake(10,2, self.view.frame.size.width-20, 36);
        lbl_date.font = [UIFont fontWithName:@"Eras Demi ITC" size:13];
        lbl_date.text = [array_type objectAtIndex:indexPath.row];
        lbl_date.textColor=[UIColor blackColor];
        [cell.contentView addSubview:lbl_date];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == table_item) {
        NSString *str_type = btn_type.titleLabel.text;
        [controller_item dismissViewControllerAnimated:YES completion:nil];
        NSString *str_item = [[array_item valueForKey:@"idesc"] objectAtIndex:indexPath.row];
        if ([str_type isEqualToString:@"Metal Receipt"] || [str_type isEqualToString:@"Metal Payment"]) {
            [_btn_item_metal setTitle:str_item forState:UIControlStateNormal];
            [self->btn_item setTitle:str_item forState:UIControlStateNormal];
        }else{
            [self->btn_item setTitle:str_item forState:UIControlStateNormal];
        }
        NSString *str_itype = [[array_item valueForKey:@"itype"] objectAtIndex:indexPath.row];
        [self scrollData_stamp:str_itype];
    }else if (tableView == table_stamp){
        [controller_stamp dismissViewControllerAnimated:YES completion:nil];
        NSString *str_stamp = [[array_stamp valueForKey:@"stamp"] objectAtIndex:indexPath.row];
        [self->btn_stamp setTitle:str_stamp forState:UIControlStateNormal];

    }else if (tableView == table_lbron){
        [controller_lbron dismissViewControllerAnimated:YES completion:nil];
        NSString *str_lbron = [array_lbron objectAtIndex:indexPath.row];
        [self->btn_lbron setTitle:str_lbron forState:UIControlStateNormal];
        [self CalValueWithGwt:str_gwt lwt:str_lwt tunch:str_tunch wstg:str_wstg mrate:str_mrate lbr:str_lbr str_lbron:str_lbron];
    }else if (tableView == table_acname){
        [controller_acname dismissViewControllerAnimated:YES completion:nil];
        NSString *str_acname = [[array_acclist valueForKey:@"cname"] objectAtIndex:indexPath.row];
        [self->_btn_acname setTitle:str_acname forState:UIControlStateNormal];
        str_pay_acno = [[array_acclist valueForKey:@"acno"] objectAtIndex:indexPath.row];
    }else{
        [controller_type dismissViewControllerAnimated:YES completion:nil];
        NSString *str_type = [array_type objectAtIndex:indexPath.row];
        [self->btn_type setTitle:str_type forState:UIControlStateNormal];
        [self scrollData_item:str_type];
        if ([str_type isEqualToString:@"Transfer"]){
            view_payment.hidden = NO;
            view_sale.hidden = YES;
            [self setupUI:@"TRAN"];
        }else if ([str_type isEqualToString:@"Receipt"] || [str_type isEqualToString:@"Payment"]){
            view_payment.hidden = NO;
            view_sale.hidden = YES;
            [self setupUI:@"REC"];
        }else if ([str_type isEqualToString:@"Metal Receipt"] || [str_type isEqualToString:@"Metal Payment"]){
            view_payment.hidden = NO;
            view_sale.hidden = YES;
            [self setupUI:@"Metal"];
            
//            lbl_pc.hidden = YES;
//            txt_pc.hidden = YES;
//            view_lbr.hidden = YES;
//            view_rate.hidden = YES;
//            lbl_lwt.hidden = YES;
//            txt_lwt.hidden = YES;
//            lbl_wstg.hidden = NO;
//            txt_wstg.hidden = NO;
//            lbl_mrate.hidden = NO;
//            txt_mrate.hidden = NO;
//            view_nwt.hidden = NO;
//            btn_stamp.hidden = YES;
//            lbl_s_stamp.hidden = YES;
//            view_gst.hidden = YES;
//            btn_item.hidden = NO;
//            lbl_s_item.hidden = NO;
//            view_payment.hidden = YES;
//            view_sale.hidden = NO;
            
        }else if ([str_type isEqualToString:@"Gold Purchase Bhav"] || [str_type isEqualToString:@"Gold Sale Bhav"] || [str_type isEqualToString:@"Silver Purchase Bhav"] || [str_type isEqualToString:@"Silver Sale Bhav"]){
            view_payment.hidden = NO;
            view_sale.hidden = YES;
            [self setupUI:@"GPB"];
        }else{
            lbl_pc.hidden = NO;
            txt_pc.hidden = NO;
            view_lbr.hidden = NO;
            view_rate.hidden = YES;
            lbl_lwt.hidden = NO;
            txt_lwt.hidden = NO;
            lbl_wstg.hidden = NO;
            txt_wstg.hidden = NO;
            lbl_mrate.hidden = NO;
            txt_mrate.hidden = NO;
            view_nwt.hidden = NO;
            btn_stamp.hidden = NO;
            lbl_s_stamp.hidden = NO;
            view_gst.hidden = NO;
            btn_item.hidden = NO;
            lbl_s_item.hidden = NO;
            view_payment.hidden = YES;
            view_sale.hidden = NO;
            view_gwt.hidden = NO;
            view_nwt.hidden = NO;
            view_tunch.hidden = NO;
            view_fine.hidden = NO;
            view_lbr.hidden = NO;
            view_gst.hidden = NO;
        }
    }
}

-(void)setupUI:(NSString *)type_form {
    
    self.view_rec = [[UIView alloc] initWithFrame:self.view.bounds];
    self.view_rec.backgroundColor = [UIColor whiteColor];
    [view_payment addSubview:self.view_rec];

    // Create and set up view_tran (TRAN form container view)
    self.view_tran = [[UIView alloc] initWithFrame:self.view.bounds];
    self.view_tran.backgroundColor = [UIColor whiteColor];
    self.view_tran.hidden = YES;  // Initially hide the TRAN view
    [view_payment addSubview:self.view_tran];
    
    self.view_gpb = [[UIView alloc] initWithFrame:self.view.bounds];
    self.view_gpb.backgroundColor = [UIColor whiteColor];
    self.view_gpb.hidden = YES;  // Initially hide the TRAN view
    [view_payment addSubview:self.view_gpb];
    self.view_metal = [[UIView alloc] initWithFrame:self.view.bounds];
    self.view_metal.backgroundColor = [UIColor whiteColor];
    self.view_metal.hidden = YES;  // Initially hide the TRAN view
    [view_payment addSubview:self.view_metal];
    [self clearPreviousUI];
    
    if ([type_form isEqualToString:@"REC"]){
        [self.view_tran setHidden:YES];  // Hide TRAN view
        [self.view_rec setHidden:NO];    // Show REC view
        [self.view_gpb setHidden:YES];
        [self setupRecForm];
    }else if ([type_form isEqualToString:@"TRAN"]) {
        [self.view_rec setHidden:YES];   // Hide REC view
        [self.view_tran setHidden:NO];   // Show TRAN view
        [self.view_gpb setHidden:YES];
        [self setupTranForm];
    }else if ([type_form isEqualToString:@"GPB"]) {
        [self.view_rec setHidden:YES];
        [self.view_tran setHidden:YES];
        [self.view_gpb setHidden:NO];
        [self setupGPBForm];
    }else if ([type_form isEqualToString:@"Metal"]) {
        [self.view_rec setHidden:YES];
        [self.view_tran setHidden:YES];
        [self.view_gpb setHidden:YES];
        [self.view_metal setHidden:NO];
        [self setupMetal];
    }
}

// Helper method to clear previous UI
-(void)clearPreviousUI {
    for (UIButton *radioButton in self.radioButtons) {
        [radioButton removeFromSuperview];
    }
    for (UILabel *label in self.radioButtonLabels) {
        [label removeFromSuperview];
    }

    [self.radioButtons removeAllObjects];
    [self.radioButtonLabels removeAllObjects];
    
    [self.remarkButton removeFromSuperview];
    [self.amountButton removeFromSuperview];
    [self.btn_acname removeFromSuperview];
    [self.goldtext removeFromSuperview];
    [self.silvertext removeFromSuperview];
}

- (void)setupMetal {
    CGFloat padding = 10; // Padding between fields
    CGFloat startX = 20; // Starting X position
    CGFloat totalWidth = view_payment.frame.size.width - 40;
    CGFloat textFieldHeight = 40; // Uniform height
    CGFloat yPosition = 20; // Initial Y position

    // Select Item Button
    self.btn_item_metal = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.btn_item_metal setTitle:@"Select Item" forState:UIControlStateNormal];
    [self.btn_item_metal setTintColor: [UIColor blackColor]];
    self.btn_item_metal.frame = CGRectMake(startX, yPosition, totalWidth, textFieldHeight);
    self.btn_item_metal.layer.borderColor = [UIColor grayColor].CGColor;
    self.btn_item_metal.layer.borderWidth = 1.0;
    self.btn_item_metal.layer.cornerRadius = 5.0;
    self.btn_item_metal.clipsToBounds = YES;
    [self.btn_item_metal addTarget:self action:@selector(btn_item_metal1) forControlEvents:UIControlEventTouchUpInside];
    [_view_metal addSubview:self.btn_item_metal];

    yPosition += textFieldHeight + padding; // Move to next row

    // Remark TextField
    self.remarkButton = [[UITextField alloc] initWithFrame:CGRectMake(startX, yPosition, totalWidth, textFieldHeight)];
    self.remarkButton.placeholder = @"Remark";
    self.remarkButton.borderStyle = UITextBorderStyleRoundedRect;
    [_view_metal addSubview:self.remarkButton];

    yPosition += textFieldHeight + padding;

    // Enter Tgno
    self.txt_tgno_metal = [[UITextField alloc] initWithFrame:CGRectMake(startX, yPosition, totalWidth / 2 - padding, textFieldHeight)];
    self.txt_tgno_metal.placeholder = @"Enter Tgno";
    self.txt_tgno_metal.borderStyle = UITextBorderStyleRoundedRect;
    [_view_metal addSubview:self.txt_tgno_metal];

    // Gross Wt
    self.txt_gwt_metal = [[UITextField alloc] initWithFrame:CGRectMake(startX + totalWidth / 2 + padding, yPosition, totalWidth / 2 - padding, textFieldHeight)];
    self.txt_gwt_metal.placeholder = @"Gross Wt";
    self.txt_gwt_metal.borderStyle = UITextBorderStyleRoundedRect;
    [self.txt_gwt_metal addTarget:self action:@selector(txt_gwt_metal:) forControlEvents:UIControlEventEditingChanged];
    self.txt_gwt_metal.keyboardType = UIKeyboardTypeDecimalPad;
    [_view_metal addSubview:self.txt_gwt_metal];

    yPosition += textFieldHeight + padding;

    // Net Wt
    self.txt_nwt_metal = [[UITextField alloc] initWithFrame:CGRectMake(startX, yPosition, totalWidth, textFieldHeight)];
    self.txt_nwt_metal.placeholder = @"Net Wt.";
    self.txt_nwt_metal.borderStyle = UITextBorderStyleRoundedRect;
    [_view_metal addSubview:self.txt_nwt_metal];

    yPosition += textFieldHeight + padding;

    // Tunch, WSTG, MRate in one row
    CGFloat smallTextFieldWidth = (totalWidth - 2 * padding) / 3;

    // Tunch
    self.txt_tunch_metal = [[UITextField alloc] initWithFrame:CGRectMake(startX, yPosition, smallTextFieldWidth, textFieldHeight)];
    self.txt_tunch_metal.placeholder = @"Tunch";
    self.txt_tunch_metal.borderStyle = UITextBorderStyleRoundedRect;
    [self.txt_tunch_metal addTarget:self action:@selector(txt_tunch_metal:) forControlEvents:UIControlEventEditingChanged];
    self.txt_tunch_metal.keyboardType = UIKeyboardTypeDecimalPad;
    [_view_metal addSubview:self.txt_tunch_metal];

    // WSTG
    self.txt_wstg_metal = [[UITextField alloc] initWithFrame:CGRectMake(startX + smallTextFieldWidth + padding, yPosition, smallTextFieldWidth, textFieldHeight)];
    self.txt_wstg_metal.placeholder = @"WSTG";
    self.txt_wstg_metal.borderStyle = UITextBorderStyleRoundedRect;
    [self.txt_wstg_metal addTarget:self action:@selector(txt_wstg_metal:) forControlEvents:UIControlEventEditingChanged];
    self.txt_wstg_metal.keyboardType = UIKeyboardTypeDecimalPad;
    [_view_metal addSubview:self.txt_wstg_metal];

    // MRate
    self.txt_mrate_metal = [[UITextField alloc] initWithFrame:CGRectMake(startX + 2 * (smallTextFieldWidth + padding), yPosition, smallTextFieldWidth, textFieldHeight)];
    self.txt_mrate_metal.placeholder = @"MRate";
    self.txt_mrate_metal.borderStyle = UITextBorderStyleRoundedRect;
    [self.txt_mrate_metal addTarget:self action:@selector(txt_mrate_metal:) forControlEvents:UIControlEventEditingChanged];
    self.txt_mrate_metal.keyboardType = UIKeyboardTypeDecimalPad;
    [_view_metal addSubview:self.txt_mrate_metal];

    yPosition += textFieldHeight + padding;

    // Fine Metal Label
    self.txt_fine_metal = [[UILabel alloc] initWithFrame:CGRectMake(startX, yPosition, totalWidth, textFieldHeight)];
    self.txt_fine_metal.text = @"";
    self.txt_fine_metal.layer.borderColor = [UIColor blackColor].CGColor;
    self.txt_fine_metal.layer.borderWidth = 1.0;
    self.txt_fine_metal.layer.cornerRadius = 5.0;
    [_view_metal addSubview:self.txt_fine_metal];

    yPosition += textFieldHeight + padding;

    // Amount TextField
    self.txt_amount_metal = [[UITextField alloc] initWithFrame:CGRectMake(startX, yPosition, totalWidth, textFieldHeight)];
    self.txt_amount_metal.placeholder = @"Amount";
    self.txt_amount_metal.borderStyle = UITextBorderStyleRoundedRect;
    self.txt_amount_metal.keyboardType = UIKeyboardTypeDecimalPad;
    [_view_metal addSubview:self.txt_amount_metal];

}

-(void)txt_gwt_metal:(UITextField *)textField{
    NSLog(@"textfield text_gwt %@ ",textField.text);
    str_gwt = textField.text;
    [self CalValueWithmetal:str_gwt lwt:@"" tunch:str_tunch wstg:str_wstg mrate:str_mrate lbr:@"" str_lbron:@""];
}

-(void)txt_tunch_metal:(UITextField *)textField{
    NSLog(@"textfield text_gwt %@ ",textField.text);
    str_tunch = textField.text;
    [self CalValueWithmetal:str_gwt lwt:@"" tunch:str_tunch wstg:str_wstg mrate:str_mrate lbr:@"" str_lbron:@""];
}

-(void)txt_wstg_metal:(UITextField *)textField{
    NSLog(@"textfield text_gwt %@ ",textField.text);
    str_wstg = textField.text;
    [self CalValueWithmetal:str_gwt lwt:@"" tunch:str_tunch wstg:str_wstg mrate:str_mrate lbr:@"" str_lbron:@""];
}

-(void)txt_mrate_metal:(UITextField *)textField{
    NSLog(@"textfield text_gwt %@ ",textField.text);
    str_mrate = textField.text;
    [self CalValueWithmetal:str_gwt lwt:@"" tunch:str_tunch wstg:str_wstg mrate:str_mrate lbr:@"" str_lbron:@""];
}

- (void)setupGPBForm {
    // Create Remark TextField
    self.remarkButton = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, view_payment.frame.size.width-40, 40)];
    self.remarkButton.placeholder = @"Remark";
    self.remarkButton.borderStyle = UITextBorderStyleRoundedRect;
    [_view_gpb addSubview:self.remarkButton];
    
    self.txt_gwt_gpb = [[UITextField alloc] initWithFrame:CGRectMake(20, 70, (view_payment.frame.size.width-40)/2, 40)];
    self.txt_gwt_gpb.placeholder = @"Gross Wt";
    self.txt_gwt_gpb.borderStyle = UITextBorderStyleRoundedRect;
    [self.txt_gwt_gpb addTarget:self action:@selector(text_gwt_gpb:) forControlEvents:UIControlEventEditingChanged];
    self.txt_gwt_gpb.keyboardType = UIKeyboardTypeDecimalPad;

    [_view_gpb addSubview:self.txt_gwt_gpb];
    
    self.txt_tunc_gpbh = [[UITextField alloc] initWithFrame:CGRectMake(((view_payment.frame.size.width-50)/2)+30, 70, (view_payment.frame.size.width-40)/2, 40)];
    self.txt_tunc_gpbh.placeholder = @"Tunch";
    self.txt_tunc_gpbh.borderStyle = UITextBorderStyleRoundedRect;
    [self.txt_tunc_gpbh addTarget:self action:@selector(text_tunch_gpb:) forControlEvents:UIControlEventEditingChanged];
    self.txt_tunc_gpbh.keyboardType = UIKeyboardTypeDecimalPad;

    [_view_gpb addSubview:self.txt_tunc_gpbh];
    
    self.txt_rate_gpb = [[UITextField alloc] initWithFrame:CGRectMake(20, 120, (view_payment.frame.size.width-40)/2, 40)];
    self.txt_rate_gpb.placeholder = @"Rate";
    self.txt_rate_gpb.borderStyle = UITextBorderStyleRoundedRect;
    [self.txt_rate_gpb addTarget:self action:@selector(text_rate_gpb:) forControlEvents:UIControlEventEditingChanged];
    self.txt_rate_gpb.keyboardType = UIKeyboardTypeDecimalPad;

    [_view_gpb addSubview:self.txt_rate_gpb];
    
    self.txt_rtunch_gpb = [[UITextField alloc] initWithFrame:CGRectMake(((self.view.frame.size.width-50)/2)+30, 120, (view_payment.frame.size.width-40)/2, 40)];
    self.txt_rtunch_gpb.placeholder = @"R.Tunch";
    self.txt_rtunch_gpb.borderStyle = UITextBorderStyleRoundedRect;
    [self.txt_rtunch_gpb addTarget:self action:@selector(text_rtunch_gpb:) forControlEvents:UIControlEventEditingChanged];
    self.txt_rtunch_gpb.keyboardType = UIKeyboardTypeDecimalPad;

    [_view_gpb addSubview:self.txt_rtunch_gpb];
    
    self.txt_fine_gpb = [[UILabel alloc] initWithFrame:CGRectMake(20, 170, view_payment.frame.size.width-40, 40)];
    self.txt_fine_gpb.text = @"";
    // Set the border properties
    self.txt_fine_gpb.layer.borderColor = [UIColor lightGrayColor].CGColor; // Border color
    self.txt_fine_gpb.layer.borderWidth = 1.0; // Border width
    self.txt_fine_gpb.layer.cornerRadius = 5.0; // Optional: round corners
    
    [_view_gpb addSubview:self.txt_fine_gpb];
    
    // Create Amount TextField
    self.amountButton = [[UITextField alloc] initWithFrame:CGRectMake(20, 220, view_payment.frame.size.width-40, 40)];
    self.amountButton.placeholder = @"Amount";
    self.amountButton.borderStyle = UITextBorderStyleRoundedRect;
    self.amountButton.keyboardType = UIKeyboardTypeDecimalPad;
    [self.amountButton addTarget:self action:@selector(text_amount_gpb:) forControlEvents:UIControlEventEditingChanged];
    [_view_gpb addSubview:self.amountButton];
}

-(void)text_gwt_gpb:(UITextField *)textField{
    NSLog(@"textfield text_gwt %@ ",textField.text);
    str_gwt = textField.text;
    [self CalValueWithGwt_bhav];
}

-(void)text_tunch_gpb:(UITextField *)textField{
    NSLog(@"textfield text_gwt %@ ",textField.text);
    str_tunch = textField.text;
    [self CalValueWithGwt_bhav];
}

-(void)text_rate_gpb:(UITextField *)textField{
    NSLog(@"textfield text_gwt %@ ",textField.text);
    str_rate = textField.text;
    [self CalValueWithGwt_bhav];
}

-(void)text_rtunch_gpb:(UITextField *)textField{
    NSLog(@"textfield text_gwt %@ ",textField.text);
    str_rtunch = textField.text;
    [self CalValueWithGwt_bhav];
}

-(void)text_amount_gpb:(UITextField *)textField{
    NSLog(@"textfield text_gwt %@ ",textField.text);
    str_mrate = textField.text;
    [self CalValueWithGwt_bhav];
}

- (void)setupRecForm {
    CGFloat radioButtonXPosition = 10; // Starting X position for radio buttons
    CGFloat radioButtonSpacing = 90;   // Space between radio buttons (horizontal spacing)
    NSArray *paymentMethods = @[@"Cash", @"Card", @"Cheque", @"Other"];
    // Initialize arrays for storing buttons and labels
    self.radioButtons = [NSMutableArray array]; // Array to hold radio buttons
    self.radioButtonLabels = [NSMutableArray array]; // Array to hold labels
    // Add radio buttons and labels for payment methods
    for (int i = 0; i < paymentMethods.count; i++) {
        UIButton *radioButton = [UIButton buttonWithType:UIButtonTypeCustom];
        radioButton.frame = CGRectMake(radioButtonXPosition + (i * radioButtonSpacing), 20, 25, 25);
        [radioButton setBackgroundImage:[UIImage imageNamed:@"uncheckcircle.png"] forState:UIControlStateNormal];
        [radioButton setBackgroundImage:[UIImage imageNamed:@"checkcircle.png"] forState:UIControlStateSelected];
        radioButton.tag = i;
        [radioButton addTarget:self action:@selector(didTapRadioButton:) forControlEvents:UIControlEventTouchUpInside];
        [view_payment addSubview:radioButton];
        [self.radioButtons addObject:radioButton];
        // Create and add labels
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(radioButton.frame.origin.x + radioButton.frame.size.width, 20, 60, 25)];
        label.text = paymentMethods[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        [view_payment addSubview:label];
        [self.radioButtonLabels addObject:label];
    }
    
    // Create the "A/C Name" button
    self.btn_acname = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.btn_acname setTitle:@"A/C Name" forState:UIControlStateNormal];
    [self.btn_acname setTintColor: [UIColor blackColor]];
    self.btn_acname.frame = CGRectMake(10, 80, view_payment.frame.size.width - 20, 40);
    self.btn_acname.layer.borderColor = [UIColor grayColor].CGColor;
    self.btn_acname.layer.borderWidth = 1.0;
    self.btn_acname.layer.cornerRadius = 5.0;
    self.btn_acname.clipsToBounds = YES;
    [self.btn_acname addTarget:self action:@selector(btn_acnames) forControlEvents:UIControlEventTouchUpInside];
    [view_payment addSubview:self.btn_acname];
    
    // Create Remark TextField
    self.remarkButton = [[UITextField alloc] initWithFrame:CGRectMake(10, 140, view_payment.frame.size.width-20, 40)];
    self.remarkButton.placeholder = @"Remark";
    self.remarkButton.borderStyle = UITextBorderStyleRoundedRect;
    [view_payment addSubview:self.remarkButton];
    
    // Create Amount TextField
    self.amountButton = [[UITextField alloc] initWithFrame:CGRectMake(10, 200, view_payment.frame.size.width-20, 40)];
    self.amountButton.placeholder = @"Amount";
    self.amountButton.borderStyle = UITextBorderStyleRoundedRect;
    self.amountButton.keyboardType = UIKeyboardTypeDecimalPad;
    [view_payment addSubview:self.amountButton];
}

// Setup for TRAN form
-(void)setupTranForm {
    CGFloat radioButtonXPosition = 10; // Starting X position for radio buttons
    CGFloat radioButtonSpacing = 90;   // Space between radio buttons (horizontal spacing)
    NSArray *paymentMethods = @[@"Naam", @"Jama"];
    self.radioButtons = [NSMutableArray array]; // Array to hold radio buttons
    self.radioButtonLabels = [NSMutableArray array]; // Array to hold labels
    // Add radio buttons and labels for payment methods
    for (int i = 0; i < paymentMethods.count; i++) {
        UIButton *radioButton = [UIButton buttonWithType:UIButtonTypeCustom];
        radioButton.frame = CGRectMake(radioButtonXPosition + (i * radioButtonSpacing), 20, 25, 25);
        [radioButton setBackgroundImage:[UIImage imageNamed:@"uncheckcircle.png"] forState:UIControlStateNormal];
        [radioButton setBackgroundImage:[UIImage imageNamed:@"checkcircle.png"] forState:UIControlStateSelected];
        radioButton.tag = i;
        [radioButton addTarget:self action:@selector(didTapRadioButton1:) forControlEvents:UIControlEventTouchUpInside];
        [view_payment addSubview:radioButton];
        [self.radioButtons addObject:radioButton];
        // Create and add labels
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(radioButton.frame.origin.x + radioButton.frame.size.width + 5, 20, 60, 25)];
        label.text = paymentMethods[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        [view_payment addSubview:label];
        [self.radioButtonLabels addObject:label];
    }
    // Create the "A/C Name" button
    self.btn_acname = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.btn_acname setTitle:@"A/C Name" forState:UIControlStateNormal];
    [self.btn_acname setTintColor: [UIColor blackColor]];
    self.btn_acname.frame = CGRectMake(20, 80, view_payment.frame.size.width-40, 40);
    self.btn_acname.layer.borderColor = [UIColor grayColor].CGColor;
    self.btn_acname.layer.borderWidth = 1.0;
    self.btn_acname.layer.cornerRadius = 5.0;
    self.btn_acname.clipsToBounds = YES;
    [self.btn_acname addTarget:self action:@selector(btn_acnames) forControlEvents:UIControlEventTouchUpInside];
    [self.view_tran addSubview:self.btn_acname];
    
    // Create Remark TextField
    self.remarkButton = [[UITextField alloc] initWithFrame:CGRectMake(20, 140, view_payment.frame.size.width-40, 40)];
    self.remarkButton.placeholder = @"Remark";
    self.remarkButton.borderStyle = UITextBorderStyleRoundedRect;
    [self.view_tran addSubview:self.remarkButton];
    
    // Create additional fields for "TRAN" type
    self.goldtext = [[UITextField alloc] initWithFrame:CGRectMake(20, 200, view_payment.frame.size.width-40, 40)];
    self.goldtext.placeholder = @"Gold";
    self.goldtext.borderStyle = UITextBorderStyleRoundedRect;
    self.goldtext.keyboardType = UIKeyboardTypeDecimalPad;
    [self.view_tran addSubview:self.goldtext];
    
    self.silvertext = [[UITextField alloc] initWithFrame:CGRectMake(20, 260, view_payment.frame.size.width-40, 40)];
    self.silvertext.placeholder = @"Silver";
    self.silvertext.borderStyle = UITextBorderStyleRoundedRect;
    self.silvertext.keyboardType = UIKeyboardTypeDecimalPad;
    [self.view_tran addSubview:self.silvertext];
    
    self.amountButton = [[UITextField alloc] initWithFrame:CGRectMake(20, 320, view_payment.frame.size.width-40, 40)];
    self.amountButton.placeholder = @"Amount";
    self.amountButton.borderStyle = UITextBorderStyleRoundedRect;
    self.amountButton.keyboardType = UIKeyboardTypeDecimalPad;
    [self.view_tran addSubview:self.amountButton];
}

// Action for Remark Button
- (void)btn_item_metal1 {
    NSLog(@"btn_item_metal button tapped");
//     [self Alert_acname];
    [self scrollData_item:@"Metal Receipt"];
    [self Alert_item];
}

// Action for Remark Button
- (void)btn_acnames {
    NSLog(@"btn_acnames button tapped");
//    [self scrollData_grp:str_pay_type];
     [self Alert_acname];
}

// Action for Amount Button
- (void)didTapAmountButton {
    NSLog(@"Amount button tapped");
}

- (void)didTapRadioButton:(UIButton *)sender {
    for (UIButton *radioButton in self.radioButtons) {
        radioButton.selected = NO;  // Deselect each radio button
    }
    sender.selected = YES;
    NSInteger selectedIndex = sender.tag;
    str_pay_type = [@[@"Cash", @"Card", @"cheque", @"other"] objectAtIndex:selectedIndex];
    NSLog(@"str_pay_type method selected: %@", str_pay_type);
    [self scrollData_grp:str_pay_type];
}

- (void)didTapRadioButton1:(UIButton *)sender {
    for (UIButton *radioButton in self.radioButtons) {
        radioButton.selected = NO;  // Deselect each radio button
    }
    sender.selected = YES;
    
    NSInteger selectedIndex = sender.tag;
    str_pay_type = [@[@"Naam", @"Jama"] objectAtIndex:selectedIndex];
    NSLog(@"str_pay_type method selected: %@", str_pay_type);
    [self scrollData_grp:@"other"];
}

-(void)scrollData_item:(NSString*)free_str {
    NSString *str_type = free_str;

    if ([free_str isEqualToString:@"Sale"]) {
        str_type = @"S";
    } else if ([free_str isEqualToString:@"Purchase"]) {
        str_type = @"P";
    } else if ([free_str isEqualToString:@"Sale Return"]) {
        str_type = @"SR";
    } else if ([free_str isEqualToString:@"Metal Receipt"]) {
        str_type = @"MR";
    } else if ([free_str isEqualToString:@"Metal Payment"]) {
        str_type = @"MP";
    } else if ([free_str isEqualToString:@"Receipt"]) {
        str_type = @"REC";
    } else if ([free_str isEqualToString:@"Payment"]) {
        str_type = @"PAY";
    } else if ([free_str isEqualToString:@"Gold Purchase Bhav"]) {
        str_type = @"GPB";
    } else if ([free_str isEqualToString:@"Gold Sale Bhav"]) {
        str_type = @"GSB";
    } else if ([free_str isEqualToString:@"Silver Purchase Bhav"]) {
        str_type = @"SPB";
    } else if ([free_str isEqualToString:@"Silver Sale Bhav"]) {
        str_type = @"SSB";
    } else if ([free_str isEqualToString:@"Transfer"]) {
        str_type = @"TRN";
    }

    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype = ECAT_TYPE;

    if ([ECAT_TYPE isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];

        loginRequest = [NSString stringWithFormat:@"apptype=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@&type=%@",apptype,ip,db,ipusername,pswd,ftppath,str_type];
        URL_API = [WEB_URL URL_GET_VISIT_ITEM];
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];

        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/get_visit_item.php",ip];
        loginRequest = [NSString stringWithFormat:@"apptype=%@&ftppath=%@&type=%@",apptype,ftppath,str_type];
    }else{
        loginRequest = [NSString stringWithFormat:@"apptype=%@&type=%@",apptype,str_type];
        URL_API =[WEB_URL URL_GET_VISIT_ITEM];
    }
    
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
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parseResponse_category:data];
            });
        }
        else if ([data length] == 0 && error == nil){
            NSLog(@"Empty Response, not sure why?");
            [[BusyIndicator sharedInstance]stopIndicator];
        }
        else if (error != nil){
            NSLog(@"Not again, what is the error = %@", error);
            [[BusyIndicator sharedInstance]stopIndicator];
        }
    }] resume];
}


- (void) parseResponse_category:(NSData *) data {
    @try {
        NSString *myData = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding];
        NSLog(@"JSON data = %@", myData);
        [[BusyIndicator sharedInstance]stopIndicator];
        NSError *error = nil;
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
            
            array_item = [[NSMutableArray alloc]init];
            array_item = [pDict objectForKey:@"itemlist"];
            NSLog(@"nsarray_product :: %@",array_item);
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}


-(void)scrollData_stamp:(NSString *)str_item {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype = ECAT_TYPE;
    
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];

        loginRequest = [NSString stringWithFormat:@"apptype=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@&itype=%@",apptype,ip,db,ipusername,pswd,ftppath,str_item];
        URL_API = [WEB_URL URL_GET_STAMP];
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];

        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/get_stamp.php",ip];
        loginRequest = [NSString stringWithFormat:@"apptype=%@&ftppath=%@&itype=%@",apptype,ftppath,str_item];
    }else{
        loginRequest = [NSString stringWithFormat:@"apptype=%@&itype=%@",apptype,str_item];
        URL_API =[WEB_URL URL_GET_STAMP];
    }
    
    NSLog(@"URL_GET_STAMP : %@",URL_API);
    NSLog(@"loginRequest : %@",loginRequest);

    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
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
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parseResponse_stamp:data];
            });
        }
        else if ([data length] == 0 && error == nil){
            NSLog(@"Empty Response, not sure why?");
            [[BusyIndicator sharedInstance]stopIndicator];
        }
        else if (error != nil){
            NSLog(@"Not again, what is the error = %@", error);
            [[BusyIndicator sharedInstance]stopIndicator];
        }
    }] resume];
}


- (void) parseResponse_stamp:(NSData *) data {
    @try {
        NSString *myData = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding];
        NSLog(@"JSON data = %@", myData);
        [[BusyIndicator sharedInstance]stopIndicator];
        NSError *error = nil;
        id jsonObject = [NSJSONSerialization
                         JSONObjectWithData:data
                         options:NSJSONReadingAllowFragments
                         error:&error];
        if (jsonObject != nil && error == nil){
            NSLog(@"Successfully deserialized...");
            NSMutableDictionary *pDict = [NSJSONSerialization
                                          JSONObjectWithData:data
                                          options:NSJSONReadingAllowFragments
                                          error:&error];
            array_stamp = [[NSMutableArray alloc]init];
            array_stamp = [pDict objectForKey:@"stamplist"];
            NSLog(@"nsarray_product :: %@",array_stamp);
            
        }
    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}

- (IBAction)btn_checkgst:(id)sender {
    double int_amt = [txt_amt.text doubleValue];
    if (int_amt > 0){
        if (checkgst) {
            checkgst = 0;
            [_btn_gstinclude setImage:[UIImage imageNamed:@"uncheckcircle.png"] forState:UIControlStateNormal];
        }else{
            checkgst = 1;
            [_btn_gstinclude setImage:[UIImage imageNamed:@"checkcircle.png"] forState:UIControlStateNormal];
        }
        NSString *str_lbron = btn_lbron.titleLabel.text;
        [self CalValueWithGwt:str_gwt lwt:str_lwt tunch:str_tunch wstg:str_wstg mrate:str_mrate lbr:str_lbr str_lbron:str_lbron];
    }
}

-(void)InsertFeed{
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
   
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *ECAT_TYPE_NEW = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE_NEW"];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype = ECAT_TYPE;
    NSString *free_str = btn_type.titleLabel.text;
    NSString *type = free_str;
    
    NSString * item_idesc = btn_item.titleLabel.text;
    NSString * ino = @"";
    NSString * stamp = btn_stamp.titleLabel.text;
    NSString * stampid = @"";
    NSString * remarks = txt_remark.text;
    NSString * item_qty = txt_pc.text;
    NSString * item_gwt = txt_gwt.text;
    NSString * wt = txt_nwt.text;
    NSString * tunch = txt_tunch.text;
    NSString * wstg = txt_wstg.text;
    NSString * rate = @"";
    NSString * lbr = txt_lbr.text;
    NSString * lbron = btn_lbron.titleLabel.text;
    NSString * salemrp = txt_amt.text;
    NSString * item_other = @"";
    NSString * pgst = @"";
    NSString * gst_amt = txt_gstamt.text;
    NSString * rtunch = @"";
    NSString * naam = @"";
    NSString * fine1 = txt_fine.text;
    NSString * fine2 = @"";
    NSString * itype = str_itype;
    NSString * groupname = @"";
    NSString * adjacno = @"";
    
    if ([item_qty isEqualToString:@"0"] || item_qty.length == 0)
    {
        item_qty = @"1";
    }
    
    if (![salemrp isEqualToString:gst_amt] && salemrp.length !=0) {
       double dgst_amt = [gst_amt doubleValue] - [salemrp doubleValue];
       gst_amt = [NSString stringWithFormat:@"%.3f", dgst_amt];
    }

    if ([free_str isEqualToString:@"Sale"]) {
        type = @"S";
    } else if ([free_str isEqualToString:@"Purchase"]) {
        type = @"P";
    } else if ([free_str isEqualToString:@"Sale Return"]) {
        type = @"SR";
    } else if ([free_str isEqualToString:@"Metal Receipt"]) {
        type = @"MR";
        item_idesc = _btn_item_metal.titleLabel.text;
        item_gwt = _txt_gwt_metal.text;
        wt = _txt_nwt_metal.text;
        tunch = _txt_tunch_metal.text;
        wstg = _txt_wstg_metal.text;
        salemrp = _txt_amount_metal.text;
        gst_amt = @"";

    } else if ([free_str isEqualToString:@"Metal Payment"]) {
        type = @"MP";
        item_idesc = _btn_item_metal.titleLabel.text;
        item_gwt = _txt_gwt_metal.text;
        wt = _txt_nwt_metal.text;
        tunch = _txt_tunch_metal.text;
        wstg = _txt_wstg_metal.text;
        salemrp = _txt_amount_metal.text;
        gst_amt = @"";
    } else if ([free_str isEqualToString:@"Receipt"]) {
        type = [self.btn_acname.titleLabel text];
        remarks = _remarkButton.text;
        salemrp = _amountButton.text;
        if ([str_pay_type isEqualToString:@"Cash"]) {
            groupname = @"1";
        }else if ([str_pay_type isEqualToString:@"Card"]) {
            groupname = @"2";
        }else if ([str_pay_type isEqualToString:@"Cheque"]) {
            groupname = @"3";
        }else if ([str_pay_type isEqualToString:@"Other"]) {
            groupname = @"4";
        }
        adjacno = str_pay_acno;
        item_idesc = str_pay_type;
    }else if ([free_str isEqualToString:@"Payment"]) {
        type = [self.btn_acname.titleLabel text];
        remarks = _remarkButton.text;
        salemrp = _amountButton.text;
        if ([str_pay_type isEqualToString:@"Cash"]) {
            groupname = @"1";
        }else if ([str_pay_type isEqualToString:@"Card"]) {
            groupname = @"2";
        }else if ([str_pay_type isEqualToString:@"Cheque"]) {
            groupname = @"3";
        }else if ([str_pay_type isEqualToString:@"Other"]) {
            groupname = @"4";
        }
        adjacno = str_pay_acno;
        item_idesc = str_pay_type;

    } else if ([free_str isEqualToString:@"Gold Purchase Bhav"] || [free_str isEqualToString:@"Gold Sale Bhav"] || [free_str isEqualToString:@"Silver Purchase Bhav"] || [free_str isEqualToString:@"Silver Sale Bhav"]) {
        
       if ([free_str isEqualToString:@"Gold Purchase Bhav"]) {
            type = @"GPB";
       } else if ([free_str isEqualToString:@"Gold Sale Bhav"]) {
           type = @"GSB";
       } else if ([free_str isEqualToString:@"Silver Purchase Bhav"]) {
           type = @"SPB";
       } else if ([free_str isEqualToString:@"Silver Sale Bhav"]) {
           type = @"SSB";
       }
        item_idesc = type;
        salemrp = _amountButton.text;
        item_gwt = _txt_gwt_gpb.text;
        tunch = _txt_tunc_gpbh.text;
        rate = _txt_rate_gpb.text;
        rtunch = _txt_rtunch_gpb.text;
        fine1 = _txt_fine_gpb.text;

    } else if ([free_str isEqualToString:@"Transfer"]) {
        type = [self.btn_acname.titleLabel text];
        fine1 = _goldtext.text;
        fine2 = _silvertext.text;
        remarks = _remarkButton.text;
        salemrp = _amountButton.text;
        if ([str_pay_type isEqualToString:@"Naam"]) {
            groupname = @"1";
        }else if ([str_pay_type isEqualToString:@"Jama"]) {
            groupname = @"2";
        }
        adjacno = str_pay_acno;
        item_idesc = str_pay_type;
    }
    
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];

        loginRequest = [NSString stringWithFormat:@"ECAT_TYPE_NEW=%@&apptype=%@&mobile=%@&visid=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@&type=%@&item_idesc=%@&ino=%@&stamp=%@&stampid=%@&remarks=%@&item_qty=%@&item_gwt=%@&wt=%@&tunch=%@&wstg=%@&rate=%@&lbr=%@&lbron=%@&salemrp=%@&item_other=%@&pgst=%@&gst_amt=%@&rtunch=%@&naam=%@&fine1=%@&fine2=%@&naam=%@&groupname=%@&adjacno=%@&fine1=%@&fine2=%@",ECAT_TYPE_NEW,apptype,mobile,visid,ip,db,ipusername,pswd,ftppath,type,item_idesc,ino,stamp,stampid,remarks,item_qty,item_gwt,wt,tunch,wstg,rate,lbr,lbron,salemrp,item_other,pgst,gst_amt,rtunch,naam,fine1,fine2,itype,groupname,adjacno,fine1,fine2];

        URL_API = [WEB_URL URL_INSERT_FEED];
    }else  if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/insert_feed.php",ip];
        loginRequest = [NSString stringWithFormat:@"ECAT_TYPE_NEW=%@&apptype=%@&mobile=%@&visid=%@&ftppath=%@&type=%@&item_idesc=%@&ino=%@&stamp=%@&stampid=%@&remarks=%@&item_qty=%@&item_gwt=%@&wt=%@&tunch=%@&wstg=%@&rate=%@&lbr=%@&lbron=%@&salemrp=%@&item_other=%@&pgst=%@&gst_amt=%@&rtunch=%@&naam=%@&fine1=%@&fine2=%@&naam=%@&groupname=%@&adjacno=%@&fine1=%@&fine2=%@",ECAT_TYPE_NEW,apptype,mobile,visid,ftppath,type,item_idesc,ino,stamp,stampid,remarks,item_qty,item_gwt,wt,tunch,wstg,rate,lbr,lbron,salemrp,item_other,pgst,gst_amt,rtunch,naam,fine1,fine2,itype,groupname,adjacno,fine1,fine2];
    }else{
        loginRequest = [NSString stringWithFormat:@"ECAT_TYPE_NEW=%@&apptype=%@&mobile=%@&visid=%@&type=%@&item_idesc=%@&ino=%@&stamp=%@&stampid=%@&remarks=%@&item_qty=%@&item_gwt=%@&wt=%@&tunch=%@&wstg=%@&rate=%@&lbr=%@&lbron=%@&salemrp=%@&item_other=%@&pgst=%@&gst_amt=%@&rtunch=%@&naam=%@&fine1=%@&fine2=%@&naam=%@&groupname=%@&adjacno=%@&fine1=%@&fine2=%@",ECAT_TYPE_NEW,apptype,mobile,visid,type,item_idesc,ino,stamp,stampid,remarks,item_qty,item_gwt,wt,tunch,wstg,rate,lbr,lbron,salemrp,item_other,pgst,gst_amt,rtunch,naam,fine1,fine2,itype,groupname,adjacno,fine1,fine2];
        URL_API = [WEB_URL URL_INSERT_FEED];
    }
    
    NSLog(@"URL_API ***************** %@",URL_API);
    NSLog(@"loginRequest ***************** %@",loginRequest);

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
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parseResponse_Save:data];
            });
        }
        else if ([data length] == 0 && error == nil){
            NSLog(@"Empty Response, not sure why?");
            [[BusyIndicator sharedInstance]stopIndicator];
        }
        else if (error != nil){
            NSLog(@"Not again, what is the error = %@", error);
            [[BusyIndicator sharedInstance]stopIndicator];
        }
    }] resume];
}


- (void)parseResponse_Save:(NSData *) data {
    @try {
        NSString *myData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"JSON data = %@", myData);
        NSError *error = nil;
        [[BusyIndicator sharedInstance]stopIndicator];
        id jsonObject = [NSJSONSerialization
                         JSONObjectWithData:data
                         options:NSJSONReadingAllowFragments
                         error:&error];
        if (jsonObject != nil && error == nil){
            NSLog(@"Successfully deserialized...");
            NSMutableDictionary *pDict = [NSJSONSerialization
                                          JSONObjectWithData:data
                                          options:NSJSONReadingAllowFragments
                                          error:&error];
            
            NSMutableArray *arrayResponse_success = [pDict objectForKey:@"success"];
            NSString *str_success = [arrayResponse_success description];
            NSMutableArray*nsarray_msg = [pDict objectForKey:@"message"];
            NSString *str_msg = [nsarray_msg description];
            if ([str_success isEqualToString:@"1"]){
                if (self.completionHandler) {
                   self.completionHandler(@"",@"", @"",@"Save");
               }
               [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Message" message:str_msg preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                            {}];
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



-(void)scrollData_grp:(NSString *)groupname {
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];

    [[BusyIndicator sharedInstance]startIndicator];
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype = ECAT_TYPE;
    
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];

        loginRequest = [NSString stringWithFormat:@"apptype=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@&groupname=%@",apptype,ip,db,ipusername,pswd,ftppath,groupname];
        URL_API = [WEB_URL URL_GET_ACNAME];
    }else if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];

        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/get_acname.php",ip];
        loginRequest = [NSString stringWithFormat:@"apptype=%@&ftppath=%@&groupname=%@",apptype,ftppath,groupname];
    }else{
        loginRequest = [NSString stringWithFormat:@"apptype=%@&groupname=%@",apptype,groupname];
        URL_API =[WEB_URL URL_GET_ACNAME];
    }
    NSLog(@"URL_API ::::::: :%@",URL_API);
    NSLog(@"loginRequest ::::::: :%@",loginRequest);

    NSString *urlString= [NSString stringWithFormat:@"%@",loginRequest];
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
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parseResponse_grp:data groupname:groupname];
            });
        }
        else if ([data length] == 0 && error == nil){
            NSLog(@"Empty Response, not sure why?");
            [[BusyIndicator sharedInstance]stopIndicator];
        }
        else if (error != nil){
            NSLog(@"Not again, what is the error = %@", error);
            [[BusyIndicator sharedInstance]stopIndicator];
        }
    }] resume];
}

- (void)parseResponse_grp:(NSData *) data groupname:(NSString *)groupname {
    @try {
        array_acclist = [[NSMutableArray alloc]init];
        NSString *myData = [[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding];
        NSLog(@"JSON data = %@", myData);
        [[BusyIndicator sharedInstance]stopIndicator];
        NSError *error = nil;
        id jsonObject = [NSJSONSerialization
                         JSONObjectWithData:data
                         options:NSJSONReadingAllowFragments
                         error:&error];
        if (jsonObject != nil && error == nil){
            NSLog(@"Successfully deserialized...");
            NSMutableDictionary *pDict = [NSJSONSerialization
                                          JSONObjectWithData:data
                                          options:NSJSONReadingAllowFragments
                                          error:&error];
            
            array_acclist = [pDict objectForKey:@"acclist"];
            NSLog(@"array_acclist :: %@",array_acclist);
        }
        [self->_btn_acname setTitle:[[array_acclist valueForKey:@"cname"]objectAtIndex:0] forState:UIControlStateNormal];
        str_pay_acno = [[array_acclist valueForKey:@"acno"] objectAtIndex:0];
        
//        if ([groupname isEqualToString:@"Cash"]) {
//        }else{
//            [self Alert_acname];
//        }

    }
    @catch (NSException *exception) {
    }
    @finally {
    }
}


@end

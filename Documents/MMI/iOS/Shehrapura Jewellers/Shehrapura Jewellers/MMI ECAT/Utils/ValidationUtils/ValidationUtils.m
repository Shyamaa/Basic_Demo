//
//  ValidationUtils.m
//  Jwelly Ecat
//
//  Created by MMI Softwares Pvt Ltd on 16/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import "ValidationUtils.h"

@implementation ValidationResult

+ (instancetype)valid {
    ValidationResult *result = [[ValidationResult alloc] init];
    result.isValid = YES;
    result.errorMessage = nil;
    return result;
}

+ (instancetype)invalidWithMessage:(NSString *)message {
    ValidationResult *result = [[ValidationResult alloc] init];
    result.isValid = NO;
    result.errorMessage = message;
    return result;
}

@end

@implementation ValidationUtils

#pragma mark - Basic Validation

+ (ValidationResult *)validateRequired:(NSString *)text {
    return [self validateRequired:text fieldName:@"This field"];
}

+ (ValidationResult *)validateRequired:(NSString *)text fieldName:(NSString *)fieldName {
    if (!text || text.length == 0 || [[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        return [ValidationResult invalidWithMessage:[NSString stringWithFormat:@"%@ is required", fieldName]];
    }
    return [ValidationResult valid];
}

+ (ValidationResult *)validateEmail:(NSString *)email {
    if (!email || email.length == 0) {
        return [ValidationResult invalidWithMessage:@"Email is required"];
    }
    
    // Basic email validation regex
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}";
    NSPredicate *emailPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    if (![emailPredicate evaluateWithObject:email]) {
        return [ValidationResult invalidWithMessage:@"Please enter a valid email address"];
    }
    
    return [ValidationResult valid];
}

+ (ValidationResult *)validatePhone:(NSString *)phone {
    if (!phone || phone.length == 0) {
        return [ValidationResult invalidWithMessage:@"Phone number is required"];
    }
    
    // Remove all non-numeric characters
    NSString *cleanPhone = [[phone componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
    
    // Check if it's a valid Indian mobile number (10 digits starting with 6-9)
    if (cleanPhone.length == 10) {
        NSString *firstDigit = [cleanPhone substringToIndex:1];
        if ([firstDigit isEqualToString:@"6"] || 
            [firstDigit isEqualToString:@"7"] || 
            [firstDigit isEqualToString:@"8"] || 
            [firstDigit isEqualToString:@"9"]) {
            return [ValidationResult valid];
        }
    }
    
    return [ValidationResult invalidWithMessage:@"Please enter a valid 10-digit mobile number"];
}

+ (ValidationResult *)validatePassword:(NSString *)password {
    if (!password || password.length == 0) {
        return [ValidationResult invalidWithMessage:@"Password is required"];
    }
    
    if (password.length < 6) {
        return [ValidationResult invalidWithMessage:@"Password must be at least 6 characters long"];
    }
    
    // Check for at least one letter and one number
    BOOL hasLetter = [password rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]].location != NSNotFound;
    BOOL hasNumber = [password rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location != NSNotFound;
    
    if (!hasLetter || !hasNumber) {
        return [ValidationResult invalidWithMessage:@"Password must contain at least one letter and one number"];
    }
    
    return [ValidationResult valid];
}

+ (ValidationResult *)validateNumeric:(NSString *)text {
    if (!text || text.length == 0) {
        return [ValidationResult invalidWithMessage:@"This field is required"];
    }
    
    NSCharacterSet *nonNumericSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    if ([text rangeOfCharacterFromSet:nonNumericSet].location != NSNotFound) {
        return [ValidationResult invalidWithMessage:@"Please enter numbers only"];
    }
    
    return [ValidationResult valid];
}

+ (ValidationResult *)validateDecimal:(NSString *)text {
    if (!text || text.length == 0) {
        return [ValidationResult invalidWithMessage:@"This field is required"];
    }
    
    // Allow decimal numbers with optional decimal point
    NSString *decimalRegex = @"^[0-9]+(\\.[0-9]+)?$";
    NSPredicate *decimalPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", decimalRegex];
    
    if (![decimalPredicate evaluateWithObject:text]) {
        return [ValidationResult invalidWithMessage:@"Please enter a valid number"];
    }
    
    return [ValidationResult valid];
}

#pragma mark - Advanced Validation

+ (ValidationResult *)validateLength:(NSString *)text 
                           minLength:(NSInteger)minLength 
                           maxLength:(NSInteger)maxLength {
    if (!text) {
        return [ValidationResult invalidWithMessage:@"This field is required"];
    }
    
    NSInteger length = text.length;
    
    if (length < minLength) {
        return [ValidationResult invalidWithMessage:[NSString stringWithFormat:@"Must be at least %ld characters", (long)minLength]];
    }
    
    if (length > maxLength) {
        return [ValidationResult invalidWithMessage:[NSString stringWithFormat:@"Must be no more than %ld characters", (long)maxLength]];
    }
    
    return [ValidationResult valid];
}

+ (ValidationResult *)validatePattern:(NSString *)text 
                              pattern:(NSString *)pattern 
                         errorMessage:(NSString *)errorMessage {
    if (!text || text.length == 0) {
        return [ValidationResult invalidWithMessage:@"This field is required"];
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    
    if (![predicate evaluateWithObject:text]) {
        return [ValidationResult invalidWithMessage:errorMessage];
    }
    
    return [ValidationResult valid];
}

+ (ValidationResult *)validateDate:(NSString *)dateString format:(NSString *)format {
    if (!dateString || dateString.length == 0) {
        return [ValidationResult invalidWithMessage:@"Date is required"];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    formatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    
    NSDate *date = [formatter dateFromString:dateString];
    
    if (!date) {
        return [ValidationResult invalidWithMessage:@"Please enter a valid date"];
    }
    
    return [ValidationResult valid];
}

+ (ValidationResult *)validateDateNotInPast:(NSDate *)date {
    if (!date) {
        return [ValidationResult invalidWithMessage:@"Date is required"];
    }
    
    NSDate *now = [NSDate date];
    if ([date compare:now] == NSOrderedAscending) {
        return [ValidationResult invalidWithMessage:@"Date cannot be in the past"];
    }
    
    return [ValidationResult valid];
}

+ (ValidationResult *)validateDateNotInFuture:(NSDate *)date {
    if (!date) {
        return [ValidationResult invalidWithMessage:@"Date is required"];
    }
    
    NSDate *now = [NSDate date];
    if ([date compare:now] == NSOrderedDescending) {
        return [ValidationResult invalidWithMessage:@"Date cannot be in the future"];
    }
    
    return [ValidationResult valid];
}

#pragma mark - Form Validation

+ (ValidationResult *)validateForm:(NSDictionary<NSString *, ValidationResult *> *)validations {
    NSMutableArray *errorMessages = [NSMutableArray array];
    
    for (NSString *fieldName in validations.allKeys) {
        ValidationResult *result = validations[fieldName];
        if (!result.isValid && result.errorMessage) {
            [errorMessages addObject:result.errorMessage];
        }
    }
    
    if (errorMessages.count > 0) {
        return [ValidationResult invalidWithMessage:[errorMessages componentsJoinedByString:@"\n"]];
    }
    
    return [ValidationResult valid];
}

+ (ValidationResult *)validateTextField:(NSString *)text 
                                  rules:(NSArray<ValidationResult *> *)rules {
    for (ValidationResult *rule in rules) {
        if (!rule.isValid) {
            return rule;
        }
    }
    
    return [ValidationResult valid];
}

#pragma mark - Utility Methods

+ (BOOL)isAlphanumeric:(NSString *)text {
    if (!text) return NO;
    
    NSCharacterSet *alphanumericSet = [NSCharacterSet alphanumericCharacterSet];
    NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:text];
    
    return [alphanumericSet isSupersetOfSet:stringSet];
}

+ (BOOL)isLettersOnly:(NSString *)text {
    if (!text) return NO;
    
    NSCharacterSet *letterSet = [NSCharacterSet letterCharacterSet];
    NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:text];
    
    return [letterSet isSupersetOfSet:stringSet];
}

+ (BOOL)isNumbersOnly:(NSString *)text {
    if (!text) return NO;
    
    NSCharacterSet *numberSet = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:text];
    
    return [numberSet isSupersetOfSet:stringSet];
}

+ (NSString *)sanitizeInput:(NSString *)text {
    if (!text) return @"";
    
    // Remove leading/trailing whitespace
    NSString *sanitized = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // Remove multiple spaces
    sanitized = [sanitized stringByReplacingOccurrencesOfString:@"\\s+" 
                                                      withString:@" " 
                                                         options:NSRegularExpressionSearch 
                                                           range:NSMakeRange(0, sanitized.length)];
    
    return sanitized;
}

+ (NSString *)formatPhoneNumber:(NSString *)phone {
    if (!phone) return @"";
    
    // Remove all non-numeric characters
    NSString *cleanPhone = [[phone componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
    
    // Format as Indian mobile number
    if (cleanPhone.length == 10) {
        return [NSString stringWithFormat:@"%@ %@ %@", 
                [cleanPhone substringToIndex:5], 
                [cleanPhone substringWithRange:NSMakeRange(5, 3)], 
                [cleanPhone substringFromIndex:8]];
    }
    
    return phone;
}

@end 
//
//  ValidationUtils.h
//  Jwelly Ecat
//
//  Created by MMI Softwares Pvt Ltd on 16/04/25.
//  Copyright © 2025 MMI Softwares. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Validation result structure
 */
@interface ValidationResult : NSObject

@property (nonatomic, assign) BOOL isValid;
@property (nonatomic, strong, nullable) NSString *errorMessage;

+ (instancetype)valid;
+ (instancetype)invalidWithMessage:(NSString *)message;

@end

/**
 * ValidationUtils - Modern input validation system
 * 
 * Provides comprehensive validation for:
 * - Email addresses
 * - Phone numbers
 * - Passwords
 * - Required fields
 * - Numeric values
 * - Date validation
 * - Custom patterns
 */
@interface ValidationUtils : NSObject

#pragma mark - Basic Validation

/**
 * Validate if a string is not empty
 * @param text The text to validate
 * @return Validation result
 */
+ (ValidationResult *)validateRequired:(NSString *)text;

/**
 * Validate if a string is not empty with custom field name
 * @param text The text to validate
 * @param fieldName The name of the field for error message
 * @return Validation result
 */
+ (ValidationResult *)validateRequired:(NSString *)text fieldName:(NSString *)fieldName;

/**
 * Validate email format
 * @param email The email to validate
 * @return Validation result
 */
+ (ValidationResult *)validateEmail:(NSString *)email;

/**
 * Validate phone number format
 * @param phone The phone number to validate
 * @return Validation result
 */
+ (ValidationResult *)validatePhone:(NSString *)phone;

/**
 * Validate password strength
 * @param password The password to validate
 * @return Validation result
 */
+ (ValidationResult *)validatePassword:(NSString *)password;

/**
 * Validate numeric input
 * @param text The text to validate
 * @return Validation result
 */
+ (ValidationResult *)validateNumeric:(NSString *)text;

/**
 * Validate decimal number
 * @param text The text to validate
 * @return Validation result
 */
+ (ValidationResult *)validateDecimal:(NSString *)text;

#pragma mark - Advanced Validation

/**
 * Validate text length
 * @param text The text to validate
 * @param minLength Minimum length
 * @param maxLength Maximum length
 * @return Validation result
 */
+ (ValidationResult *)validateLength:(NSString *)text 
                           minLength:(NSInteger)minLength 
                           maxLength:(NSInteger)maxLength;

/**
 * Validate text matches pattern
 * @param text The text to validate
 * @param pattern The regex pattern
 * @param errorMessage Custom error message
 * @return Validation result
 */
+ (ValidationResult *)validatePattern:(NSString *)text 
                              pattern:(NSString *)pattern 
                         errorMessage:(NSString *)errorMessage;

/**
 * Validate date format
 * @param dateString The date string to validate
 * @param format The date format
 * @return Validation result
 */
+ (ValidationResult *)validateDate:(NSString *)dateString format:(NSString *)format;

/**
 * Validate date is not in the past
 * @param date The date to validate
 * @return Validation result
 */
+ (ValidationResult *)validateDateNotInPast:(NSDate *)date;

/**
 * Validate date is not in the future
 * @param date The date to validate
 * @return Validation result
 */
+ (ValidationResult *)validateDateNotInFuture:(NSDate *)date;

#pragma mark - Form Validation

/**
 * Validate multiple fields at once
 * @param validations Dictionary of field names to validation results
 * @return Combined validation result
 */
+ (ValidationResult *)validateForm:(NSDictionary<NSString *, ValidationResult *> *)validations;

/**
 * Validate text field with multiple rules
 * @param text The text to validate
 * @param rules Array of validation rules
 * @return Validation result
 */
+ (ValidationResult *)validateTextField:(NSString *)text 
                                  rules:(NSArray<ValidationResult *> *)rules;

#pragma mark - Utility Methods

/**
 * Check if string contains only alphanumeric characters
 * @param text The text to check
 * @return YES if alphanumeric only
 */
+ (BOOL)isAlphanumeric:(NSString *)text;

/**
 * Check if string contains only letters
 * @param text The text to check
 * @return YES if letters only
 */
+ (BOOL)isLettersOnly:(NSString *)text;

/**
 * Check if string contains only numbers
 * @param text The text to check
 * @return YES if numbers only
 */
+ (BOOL)isNumbersOnly:(NSString *)text;

/**
 * Sanitize input by removing unwanted characters
 * @param text The text to sanitize
 * @return Sanitized text
 */
+ (NSString *)sanitizeInput:(NSString *)text;

/**
 * Format phone number for display
 * @param phone The phone number to format
 * @return Formatted phone number
 */
+ (NSString *)formatPhoneNumber:(NSString *)phone;

@end

NS_ASSUME_NONNULL_END 
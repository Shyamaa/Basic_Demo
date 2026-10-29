//
//  ScanViewController.m
//  Jewel Desk
//
//  Created by MMI SOFTWARES PVT LTD on 14/07/23.
//  Copyright © 2023 MMI Softwares. All rights reserved.
//

#import "ScanViewController.h"
#import "TagCalculator.h"
#import "CartList.h"
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface ScanViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic) BOOL isReading;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewPlayer;

@end

@implementation ScanViewController

@synthesize str_act,visid,cusmobile,act;

- (void)viewDidLoad {
    [super viewDidLoad];
    _isReading = NO;
    _captureSession = nil;
    _scannedCodes = [NSMutableArray array];
    _qrCodeLayers = [NSMutableArray array];
    _recentlyScanned = [NSMutableSet set];

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // Ensure the video preview layer is properly resized
    if (_videoPreviewPlayer) {
        _videoPreviewPlayer.frame = _viewPreview.layer.bounds;
    }
}

#pragma mark: - IBAction Methods

- (IBAction)btn_submit:(id)sender {
    if (self.scannedCodes.count == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No Scans"
                                                                       message:@"Please scan some codes first."
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:nil];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }

    for (NSString *code in self.scannedCodes) {
        [self URL_INSERT_ITEM:code]; // Send each code individually
    }
    
    // Optionally clear the list after submission
    [self.scannedCodes removeAllObjects];
    [self.labelStatus setText:@""]; // Clear label
    NSLog(@"Submitted all scanned codes.");
}

- (IBAction)btn_send:(id)sender {
    if(!_isReading) {
        if([self startReading]) {
            [_labelStatus setText:@"Scanning code..."];
            [_startButton setTitle:@"Stop Scan" forState: UIControlStateNormal];
            //[_startButton setTitle:@"Stop"];
        }
    } else {
        [self stopReading];
        //[_startButton setTitle:@"Start"];
        [_startButton setTitle:@"Scan Start" forState: UIControlStateNormal];
        //[_labelStatus setText:@"QR code reader is not yet running..."];
        NSString *firstBit = @"";
        // Process label status to extract relevant QR code data
        
        if ([_labelStatus.text rangeOfString:@"/"].location == NSNotFound) {
            firstBit = _labelStatus.text;
        } else {
            NSArray *foo = [_labelStatus.text componentsSeparatedByString: @"/"];
            firstBit = [foo objectAtIndex:1];
        }
        NSString *trimmed = [firstBit stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSLog(@"trimmed :::::: %@",trimmed);
    }
    _isReading = !_isReading;
}

- (BOOL)startReading {
    [self.recentlyScanned removeAllObjects];
    [self.scannedCodes removeAllObjects]; // if you want to reset the scanned data too
    NSError *error;
    // Try to find the back camera (AVCaptureDeviceTypeBuiltInWideAngleCamera)
    AVCaptureDevice *captureDevice = nil;
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == AVCaptureDevicePositionBack) {
            captureDevice = device;
            break;
        }
    }
    if (!captureDevice) {
        NSLog(@"Error: No back camera available.");
        return NO;
    }
    // Try to create device input with the back camera
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    if (error || !deviceInput) {
        NSLog(@"Error setting up camera input: %@", error.localizedDescription);
        return NO;
    }
    // Create capture session and add input
    _captureSession = [[AVCaptureSession alloc] init];
    if (!_captureSession) {
        NSLog(@"Failed to create capture session");
        return NO;
    }
    [_captureSession addInput:deviceInput];
    // Set up metadata output for QR code detection
    AVCaptureMetadataOutput *capturedMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:capturedMetadataOutput];
    // Set metadata delegate for QR code detection
    dispatch_queue_t dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [capturedMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [capturedMetadataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    // Set up the video preview layer
    _videoPreviewPlayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    _videoPreviewPlayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _videoPreviewPlayer.frame = _viewPreview.layer.bounds;
    [_viewPreview.layer addSublayer:_videoPreviewPlayer];
    // Start the session
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.captureSession startRunning];
    });
    return YES;
}

- (void)stopReading {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.captureSession stopRunning];
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        self.captureSession = nil;
        // ✅ Remove video preview layer
        [self.videoPreviewPlayer removeFromSuperlayer];
        // ✅ Remove all QR bounding boxes
        for (CAShapeLayer *layer in self.qrCodeLayers) {
            [layer removeFromSuperlayer];
        }
        [self.qrCodeLayers removeAllObjects];
    });
}

- (void)updateScannedListUI {
    NSString *allCodes = [self.scannedCodes componentsJoinedByString:@"\n"];
    self.labelStatus.text = allCodes;
}


- (void)captureOutput:(AVCaptureOutput *)output
didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection {

    // Remove old layers
    dispatch_async(dispatch_get_main_queue(), ^{
        for (CAShapeLayer *layer in self.qrCodeLayers) {
            [layer removeFromSuperlayer];
        }
        [self.qrCodeLayers removeAllObjects];
    });

    if (metadataObjects != nil && metadataObjects.count > 0) {
        for (AVMetadataObject *metadata in metadataObjects) {
            if ([metadata.type isEqualToString:AVMetadataObjectTypeQRCode]) {

                AVMetadataMachineReadableCodeObject *transformed =
                    (AVMetadataMachineReadableCodeObject *)[self.videoPreviewPlayer transformedMetadataObjectForMetadataObject:metadata];

                NSString *scannedString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];

                BOOL alreadyScanned = [self.scannedCodes containsObject:scannedString];
                BOOL recentlySeen = [self.recentlyScanned containsObject:scannedString];

                UIColor *boxColor = (alreadyScanned || recentlySeen) ? [UIColor greenColor] : [UIColor redColor];
                [self drawBoundingBoxForCode:transformed withColor:boxColor];
                if (!alreadyScanned && !recentlySeen) {
                    [self.recentlyScanned addObject:scannedString];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.recentlyScanned removeObject:scannedString];
                    });

                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.scannedCodes addObject:scannedString];
                        self.labelStatus.text = scannedString;
                        NSLog(@"✅ Added new code: %@", scannedString);
/*
                        if (self.scannedCodes.count >= 100) {
                            [self stopReading];
                            self.isReading = NO;
                            //[self.startButton setTitle:@"Start"];
                            [self.startButton setTitle:@"Scan Start" forState: UIControlStateNormal];
                            NSLog(@"Scan limit reached. Scanner stopped.");
                        }
                        */
                    });
                } else {
                    NSLog(@"⚠️ Duplicate or recently scanned code: %@", scannedString);
                }
            }
        }

    }
}

- (void)drawBoundingBoxForCode:(AVMetadataMachineReadableCodeObject *)codeObject withColor:(UIColor *)color {
    if (!codeObject.corners || codeObject.corners.count == 0) return;

    UIBezierPath *path = [UIBezierPath bezierPath];
    NSArray *points = codeObject.corners;

    CGPoint movePoint;
    CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)points[0], &movePoint);
    [path moveToPoint:movePoint];

    for (int i = 1; i < points.count; i++) {
        CGPoint nextPoint;
        CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)points[i], &nextPoint);
        [path addLineToPoint:nextPoint];
    }

    [path closePath];

    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = color.CGColor;
    shapeLayer.fillColor = [[UIColor clearColor] CGColor];
    shapeLayer.lineWidth = 2.0;

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.viewPreview.layer addSublayer:shapeLayer];
        [self.qrCodeLayers addObject:shapeLayer];
    });
}



-(void)URL_INSERT_ITEM:(NSString *)data {
    
    webUrlconstant *WEB_URL = [webUrlconstant sharedInstance];
    [[BusyIndicator sharedInstance]startIndicator];
    NSString *mobile = [[NSUserDefaults standardUserDefaults]stringForKey:@"mobile"];
    NSString *ECAT_TYPE = [[NSUserDefaults standardUserDefaults]stringForKey:@"ECAT_TYPE"];
    NSString *loginRequest;
    NSString *URL_API;
    NSString *apptype=ECAT_TYPE;
    if ([ECAT_TYPE isEqualToString:@"1"]) {
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        NSString *db = [[NSUserDefaults standardUserDefaults]stringForKey:@"db"];
        NSString *ipusername = [[NSUserDefaults standardUserDefaults]stringForKey:@"ipusername"];
        NSString *pswd = [[NSUserDefaults standardUserDefaults]stringForKey:@"pswd"];
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        loginRequest=[NSString stringWithFormat:@"mobile=%@&data=%@&apptype=%@&ip=%@&dbname=%@&ipusername=%@&password=%@&ftppath=%@&visid=%@&cusmobile=%@&act=%@",mobile,data,apptype,ip,db,ipusername,pswd,ftppath,visid,cusmobile,act];
        URL_API = [WEB_URL URL_INSERT_ITEMQR];
    }else if ([ECAT_TYPE isEqualToString:@"2"]) {
        NSString *ftppath = [[NSUserDefaults standardUserDefaults]stringForKey:@"ftppath"];
        NSString *ip = [[NSUserDefaults standardUserDefaults]stringForKey:@"ip"];
        URL_API = [NSString stringWithFormat:@"http://%@/jwellyecat/insert_itemqr_ios.php",ip];
        loginRequest=[NSString stringWithFormat:@"mobile=%@&data=%@&apptype=%@&ftppath=%@&visid=%@&cusmobile=%@&act=%@",mobile,data,apptype,ftppath,visid,cusmobile,act];
    }else{
        loginRequest=[NSString stringWithFormat:@"mobile=%@&data=%@&apptype=%@&visid=%@&cusmobile=%@&act=%@",mobile,data,apptype,visid,cusmobile,act];
        URL_API =[WEB_URL URL_INSERT_ITEMQR];
    }
    NSLog(@"loginRequest :::::::::::::: %@",loginRequest);
    NSString *urlString = [NSString stringWithFormat:@"%@",loginRequest];
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
        // handle response
        if ([data length] >0 && error == nil){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self parse_Insert:data];
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

- (void)parse_Insert:(NSData *) data {
    @try {
        NSString *myData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
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
                UIAlertController * alert=[UIAlertController alertControllerWithTitle:@"Message"
                                                                              message:str_msg
                                                                       preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"OK"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action){
                    [self.navigationController popViewControllerAnimated:YES];
                                            }];
                [alert addAction:yesButton];
                [self presentViewController:alert animated:YES completion:nil];
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

//
//  BarCodeScannerViewController.m
//  ScanBarCodes
//
//  Created by Torrey Betts on 10/10/13.
//  Copyright (c) 2013 Infragistics. All rights reserved.
//

/******
 * This is code from an already existing copy on the internet created by
 * Infragistics. It is used to scan barcodes and spit back out the upc string
 * that's detected. The website is from:
 * http://www.infragistics.com/community/blogs/torrey-betts/archive/2013/10/10/scanning-barcodes-with-ios-7-objective-c.aspx 
 * We then use the upc string to search for the movie that is associated with
 * that dvd/blu-ray
 ******/

#import <AVFoundation/AVFoundation.h>
#import "BarCodeScannerViewController.h"
#import "Reachability.h"
#import <AudioToolbox/AudioServices.h>

@interface BarCodeScannerViewController () <AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession *_session;
    AVCaptureDevice *_device;
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    AVCaptureVideoPreviewLayer *_prevLayer;

}
@end

@implementation BarCodeScannerViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.number = 0;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //instantiates the reachability class to check for internet connection
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];
    
    //The rest of this code in this method is from the original creator of this class
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"Library written to pList"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"Search done"
                                               object:nil];

    _session = [[AVCaptureSession alloc] init];
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;

    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
    if (_input) {
        [_session addInput:_input];
    } else {
        NSLog(@"Error: %@", error);
    }

    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [_session addOutput:_output];

    _output.metadataObjectTypes = [_output availableMetadataObjectTypes];

    _prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _prevLayer.frame = self.view.bounds;
    _prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:_prevLayer];

    [_session startRunning];
}

//hides the activity indicator until later
- (void) viewDidAppear:(BOOL)animated
{
    self.activityIndicator.hidden = YES;
    [self.activityIndicator stopAnimating];
}

/********************************************************************************************
 * @method captureOutput didOutputMetadataObjects: fromConnection:
 * @abstract captures the barcode, translates it to a number and kicks off the search
 * @description Uses most of the code from Torrey Betts' project with the exception of the
 *      reachability check, alerts, the vibration when the barcode is read and the search
 *      search calls. The search call begins the search with a different API than the title
 *      search.
 ********************************************************************************************/
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    CGRect highlightViewRect = CGRectZero;
    AVMetadataMachineReadableCodeObject *barCodeObject;
    NSString *detectionString = nil;
    NSArray *barCodeTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
            AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
            AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode];


    
    if ([self isReachable]) {
        for (AVMetadataObject *metadata in metadataObjects) {
            for (NSString *type in barCodeTypes) {
                if ([metadata.type isEqualToString:type]){
                    barCodeObject = (AVMetadataMachineReadableCodeObject *)[_prevLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
                    highlightViewRect = barCodeObject.bounds;
                    detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                    break;
                }
            }

            if (detectionString != nil) {
                self.barcodeValue = detectionString;
                //starts the search
                if (self.number == 0) {
                    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
                    // start animating activity indicator
                    [self.view bringSubviewToFront:self.activityIndicator];
                    self.activityIndicator.hidden = NO;
                    [self.activityIndicator startAnimating];

                    self.number++;
                    self.search = [[SearchResult alloc]initWithUpc:detectionString];
                    [self.search searchForMovieByUpc:detectionString];

                }
                return;
            }
        }
    }

    else{
        if (self.number == 0) {
            self.number++;
            [self noInternetError];
        }
                return;
    }
}

/********************************************************************************************
 * @method isReachable
 * @abstract checks to see if have wifi or 3G/LTE connection
 * @description Uses the Reachability classes
 ********************************************************************************************/
- (BOOL)isReachable
{
    Reachability *currentReachability = [Reachability reachabilityForInternetConnection];
    if(currentReachability.currentReachabilityStatus != NotReachable){
        NSLog(@"Connected to the internet!");
        return true;
    }
    NSLog(@"Not connected to the internet!");
    return false;
}

/********************************************************************************************
 * @method noInternetError
 * @abstract gives alert view error when not connected to internet to search
 * @description
 ********************************************************************************************/
- (void)noInternetError
{
    NSString *title = @"Sorry! Must be connected to the internet to search!";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:title delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    NSLog(@"Showing no internet connection error");
}

/********************************************************************************************
 * @method receivedNotification
 * @abstract checks to see if search is done, if so, hide the activity indicator
        and reset number to 0 so can search again
 * @description
 ********************************************************************************************/
- (void)receivedNotification:(NSNotification *) notification {
    if ([[notification name] isEqualToString:@"Search done"]) {
        NSLog(@">>>>> Search done notification received by SearchViewController");
        
        [self hideActivityIndicator];
        //reset counter to 0 so can scan again
        self.number = 0;
    }
}

/********************************************************************************************
 * @method hideActivityIndicator
 * @abstract hides the activity indicator
 * @description
 ********************************************************************************************/
- (void) hideActivityIndicator{
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;
}

@end
//
//  BarCodeScannerViewController.h
//  ScanBarCodes
//
//  Created by Torrey Betts on 10/10/13.
//  Copyright (c) 2013 Infragistics. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "SearchResult.h"

@interface BarCodeScannerViewController : UIViewController

@property (strong, nonatomic) NSString *barcodeValue;

@property (strong, nonatomic) Reachability *reachability;
@property (strong, nonatomic) SearchResult *search;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

//counter to prevent repeat loop
@property (nonatomic) __block int *number;

@end
//
//  BarCodeScannerViewController.h
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

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "SearchResult.h"

@interface BarCodeScannerViewController : UIViewController

@property (strong, nonatomic) NSString *barcodeValue;

//added by us to enable searching and check for internet connection
@property (strong, nonatomic) Reachability *reachability;
@property (strong, nonatomic) SearchResult *search;

//counter to prevent repeat loop
@property (nonatomic) __block int *number;

@end
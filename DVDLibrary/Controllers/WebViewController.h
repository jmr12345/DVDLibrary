//
//  WebViewController.h
//  AroundTheInternet
//
//  Created by Ming on 2/6/14.
//  Copyright (c) 2014 Ming. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSURL *trailerURL;
//- (IBAction)sendTweet:(id)sender;
@end

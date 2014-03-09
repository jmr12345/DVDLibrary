//
//  WebViewController.m
//  AroundTheInternet
//
//  Created by Ming on 2/6/14.
//  Copyright (c) 2014 Ming. All rights reserved.
//

#import "WebViewController.h"
#import "Social/Social.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.trailerURL= [NSURL URLWithString:@"http://www.youtube.com/watch?v=ISJR4rVO0TQ"];
    NSURLRequest *requestURL = [NSURLRequest requestWithURL:self.trailerURL];
    [self.webView loadRequest:requestURL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (IBAction)sendTweet:(id)sender {
//    
//    SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
//    [tweetSheet setInitialText:[self.site.siteUrl absoluteString]];
//    [self presentViewController:tweetSheet animated:YES completion:nil];
//}

@end

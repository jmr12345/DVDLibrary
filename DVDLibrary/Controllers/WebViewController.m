//
//  WebViewController.m
//  DVDLibrary
//
//  Created by Ming on 2/6/14.
//  Copyright (c) 2014 Ming. All rights reserved.
//
// WebViewController shows an internet browser, but its main purpose in our
// app is to show the movie trailers on YouTube.  It appears when the user
// clicks on a movie trailer button.

#import "WebViewController.h"
#import "Social/Social.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *urlString = [self.trailerURL absoluteString];
    NSLog(@">>>>> Showing url: %@",urlString);
    NSURLRequest *requestURL = [NSURLRequest requestWithURL:self.trailerURL];
    [self.webView loadRequest:requestURL];
}

@end

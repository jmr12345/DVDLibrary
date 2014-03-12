//
//  LoadingView.m
//  DVDLibrary
//
//  Created by Ming on 3/11/14.
//  Copyright (c) 2014 Ming. All rights reserved.
//

#import "ProcessingView.h"

@implementation ProcessingView


// code modified from http://stackoverflow.com/questions/3490991/big-activity-indicator-on-iphone
- (id)initWithFrame:(CGRect)frame withMessage:(NSString*)message
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 15;
        self.opaque = NO;
        self.alpha = 0.9;
        self.backgroundColor = [UIColor darkGrayColor];
        
        UILabel *loadLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, 100, 22)];
        
        loadLabel.text = message;
        loadLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        loadLabel.textAlignment = NSTextAlignmentCenter;
        loadLabel.textColor = [UIColor colorWithWhite:1.0f alpha:1.0f];
        loadLabel.backgroundColor = [UIColor clearColor];
        
        [self addSubview:loadLabel];
        
        UIActivityIndicatorView *spinning = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        spinning.frame = CGRectMake(32, 15, 37, 37);
        [spinning startAnimating];
        
        [self addSubview:spinning];
        
        //self.frame = CGRectMake(105, 200, 100, 100);
    }
    return self;
}

@end

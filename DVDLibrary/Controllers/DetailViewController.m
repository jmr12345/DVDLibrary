//
//  DetailViewController.m
//  DVDLibrary
//
//  Created by Ming on 2/28/14.
//  Copyright (c) 2014 Ming. All rights reserved.
//

#import "DetailViewController.h"
#import "Movie.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.movieImageView.image = self.movie.image;
    self.titleLabel.text = self.movie.title;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

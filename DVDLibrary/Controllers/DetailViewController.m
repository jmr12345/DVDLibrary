//
//  DetailViewController.m
//  DVDLibrary
//
//  Created by Ming on 2/28/14.
//  Copyright (c) 2014 Ming. All rights reserved.
//

#import "DetailViewController.h"
#import "Movie.h"
#import "MovieTableViewCell.h"

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

    self.sections = [[NSMutableArray alloc] initWithObjects:@"Synopsis",@"Cast", nil];
    NSLog(@"%lu",[self.sections count]);
	
    self.movieImageView.image = self.movie.image;
    self.titleLabel.text = self.movie.title;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 28)];
    
    // Setup label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 28)];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    NSString *string = [self.sections objectAtIndex:section];
    [label setText:string];
    [view addSubview:label];
    
    [view setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:0.7f]];
    
    return view;
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString* key = [self.sections objectAtIndex:section];
    return key;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSString* category = [self.sections objectAtIndex:section];
//    NSArray* arrayForSection = (NSArray*)[self.filteredTableData objectForKey:category];
//    return [arrayForSection count];
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TestCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Get movie at current position
//    Movie *movie = [[Movie alloc] init];
//    NSString* category = [self.sections objectAtIndex:indexPath.section];
//    NSArray* arrayForSection = (NSArray*)[self.filteredTableData objectForKey:category];
//    movie = (Movie *)[arrayForSection objectAtIndex:indexPath.row];
    
    // Configure cell appearance
//    cell.label.text = movie.title;
//    [cell.movieImageView setImage:movie.image];
    cell.textLabel.text = @"hi there";
    return cell;
}



@end

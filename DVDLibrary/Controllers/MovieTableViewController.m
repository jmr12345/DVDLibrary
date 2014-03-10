//
//  MovieTableViewController.m
//  DVDLibrary
//
//  Created by Ming on 3/1/14.
//  Copyright (c) 2014 Ming. All rights reserved.
//
// MovieTableViewController handles displaying the movies in a table view.
// Clicking on a movie segues to the DetailViewController.

#import "MovieTableViewController.h"
#import "MovieTableViewCell.h"
#import "Movie.h"
#import "MovieData.h"
#import "DetailViewController.h"

@interface MovieTableViewController ()
@end

@implementation MovieTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.sectionFooterHeight = 0.0;
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString* sectionTitle = [self.lvc.sections objectAtIndex:section];
    return sectionTitle;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.lvc.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString* category = [self.lvc.sections objectAtIndex:section];
    NSArray* arrayForSection = (NSArray*)[self.lvc.filteredMovieData objectForKey:category];
    return [arrayForSection count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MovieTableViewCellID";
    MovieTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Get movie at current position
    Movie *movie = [[Movie alloc] init];
    NSString* category = [self.lvc.sections objectAtIndex:indexPath.section];
    NSArray* arrayForSection = (NSArray*)[self.lvc.filteredMovieData objectForKey:category];
    movie = (Movie *)[arrayForSection objectAtIndex:indexPath.row];
    
    // Configure cell appearance
    cell.label.text = movie.title;
    [cell.movieImageView setImage:movie.image];
    return cell;
}

#pragma mark - Table view delegate

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 28)];
    
    // Setup label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 28)];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    NSString *string = [self.lvc.sections objectAtIndex:section];
    [label setText:string];
    [view addSubview:label];
    
    [view setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:0.7f]];

    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    // If no items in section, don't show any header
    if ([tableView.dataSource tableView:tableView numberOfRowsInSection:section] == 0) {
        return 0;
    } else {
        return 28;
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@">>>>> Segue to DetailViewController from MovieTableViewController");
    
    // Get destination view controller
    DetailViewController *dvc = [segue destinationViewController];
    
    // Get selected indexPath
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    
    // Get movie at current position
    Movie *selectedMovie = [[Movie alloc] init];
    NSString* category = [self.lvc.sections objectAtIndex:selectedIndexPath.section];
    NSArray* arrayForSection = (NSArray*)[self.lvc.filteredMovieData objectForKey:category];
    selectedMovie = (Movie *)[arrayForSection objectAtIndex:selectedIndexPath.row];

    // Pass movie to detail view controller
    dvc.movie = selectedMovie;
}

@end

//
//  DetailViewController.m
//  DVDLibrary
//
//  Created by Ming on 2/28/14.
//  Copyright (c) 2014 Ming. All rights reserved.
//

#import "DetailViewController.h"
#import "Movie.h"
#import "WebViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.sections = [[NSMutableArray alloc] initWithObjects:@"Movie Info",@"Synopsis",@"Cast", nil];
	
    self.movieImageView.image = self.movie.image;
    self.titleLabel.text = self.movie.title;
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString* sectionTitle = [self.sections objectAtIndex:section];
    return sectionTitle;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section){
        // Movie info
        case 0:
            return 3;
            break;
        // Synopsis
        case 1:
            return 1;
            break;
        // Cast
        case 2:
            NSLog(@">>>>> Cast: %@",self.movie.cast);
            return [self.movie.cast count];
            break;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BasicCellID";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    switch (indexPath.section) {
        // Movie info
        case 0:
            if (indexPath.row == 0){
                cell.textLabel.text = [NSString stringWithFormat:@"Runtime: %@ minutes",self.movie.duration];
            }
            if (indexPath.row == 1){
                cell.textLabel.text = [NSString stringWithFormat:@"Release Date: %@",self.movie.releaseDate];
            }
            
            if (indexPath.row == 2){
                cell.textLabel.text = [NSString stringWithFormat:@"Genres: %@",self.movie.genre];
            }
            break;
        // Synopsis
        case 1:
            cell.textLabel.text = self.movie.description;
            break;
        // Cast
        case 2:
            cell.textLabel.text = [self.movie.cast objectAtIndex:indexPath.row];
            break;
    }
    return cell;
}

#pragma mark - Table view delegate

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 32)];
    
    // Setup label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 25)];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    NSString *string = [self.sections objectAtIndex:section];
    [label setText:string];
    [view addSubview:label];
    
    [view setBackgroundColor:[UIColor colorWithWhite:0.2 alpha:0.7f]];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // Set cell size for synopsis to fit synopsis text
    if (indexPath.section==1 & indexPath.row==0)
    {
        CGRect rect = [self.movie.description boundingRectWithSize:CGSizeMake(300.f, CGFLOAT_MAX)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]}
                                             context:nil];
        CGSize strSize = rect.size;
        return (strSize.height+5);
    }
    else return 50;
}

#pragma mark - Navigation

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([[segue identifier] isEqualToString:@"TrailerSegue"]) {
//        
//        NSLog(@">>>>> Segue from DetailViewController to WebViewController");
//        
//        // Get destination view
//        WebViewController *wvc = [segue destinationViewController];
//        
//        // Set the trailer url in the new view
//        [wvc.trailerURL = self.movie.trailerURL;
//    }
//}

@end

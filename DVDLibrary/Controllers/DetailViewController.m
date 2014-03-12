//
//  DetailViewController.m
//  DVDLibrary
//
//  Created by Ming on 2/28/14.
//  Copyright (c) 2014 Ming. All rights reserved.
//
// DetailViewController appears when a movie is tapped on in the LibraryViewController
// and displays details about the movie.  It also contains a trailer button that segues
// to the WebViewController with a YouTube link of the movie.

#import "DetailViewController.h"
#import "Movie.h"
#import "WebViewController.h"
#import "MovieLibraryManager.h"
#import "Reachability.h"
#import "ProcessingView.h"

@interface DetailViewController ()
@property (strong, nonatomic) ProcessingView *processingView;
@end

@implementation DetailViewController

- (void)viewDidLoad
{
    NSLog(@"count:%lu",(unsigned long)[self.allMovieData count]);
    [super viewDidLoad];
    
    self.reachability = [Reachability reachabilityForInternetConnection];
    [self.reachability startNotifier];

    self.sections = [[NSMutableArray alloc] initWithObjects:@"Movie Info",@"Synopsis",@"Cast", nil];
	
    self.movieImageView.image = self.movie.image;
    self.titleLabel.text = self.movie.title;
    
    self.tableView.sectionFooterHeight = 0.0;
    
    NSString *urlString = [self.movie.url absoluteString];
    NSLog(@"URL: %@",urlString);
    
    self.processingView = [[ProcessingView alloc] initWithFrame:CGRectMake(110, 200, 100, 100)withMessage:@"Deleting"];
    [self.view addSubview:self.processingView];
    self.processingView.hidden = YES;
    
    
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
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
                NSString *release = [dateFormatter stringFromDate:self.movie.releaseDate];
                cell.textLabel.text = [NSString stringWithFormat:@"Release Date: %@",release];
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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 25)];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([self isReachable]) {
        if ([[segue identifier] isEqualToString:@"TrailerSegue"]) {
        
            NSLog(@">>>>> Segue from DetailViewController to WebViewController");
            
            // Get destination view
            WebViewController *wvc = [segue destinationViewController];
            
            // Set the trailer url in the new view
            wvc.trailerURL = self.movie.trailer;
        }
    }
    else{
        [self noInternetError];
    }
}

/********************************************************************************************
 * @method removeMovieSuccess
 * @abstract gives alert view when the movie is successfully deleted from the library
 * @description
 ********************************************************************************************/
- (void)removeMovieSuccess
{
    self.processingView.hidden = YES;
    NSString *title = @"Movie successfully deleted!";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:title delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    NSLog(@">>>>> Movie successfully deleted alert");
   
}

/********************************************************************************************
 * @method deleteMovie
 * @abstract deletes the current movie showing in the detail view
 * @description reads the plist, removes the item and resaves the new library in the plist
 ********************************************************************************************/
- (IBAction)deleteMovie:(UIBarButtonItem *)sender {
    NSLog(@">>>>> trash can button clicked");
    self.processingView.hidden = NO;
    
    [self.allMovieData removeObject:self.movie];

    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
        
    dispatch_async(queue,^{
        MovieLibraryManager *plistManager = [MovieLibraryManager sharedInstance];
        [plistManager saveMovieLibrary:self.allMovieData];
        [self removeMovieSuccess];
    });
}
/********************************************************************************************
 * @method alertView clickedButtonAtIndex:
 * @abstract action when the successful deletion "OK" button is clicked
 * @description after the delete movie success, the user is taken back to the library page
 *      when OK is clicked
 ********************************************************************************************/
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"OK"])
    {
        NSLog(@">>>>> OK button clicked on successful deletion");
        [self.navigationController popToRootViewControllerAnimated:TRUE];
    }
}

/********************************************************************************************
 * @method isReachable
 * @abstract checks to see if have wifi or 3G/LTE connection
 * @description Uses the Reachability classes
 ********************************************************************************************/
- (BOOL)isReachable
{
    Reachability *currentReachability = [Reachability reachabilityForInternetConnection];
    if(currentReachability.currentReachabilityStatus != NotReachable){
        NSLog(@">>>>>Connected to the internet!");
        return true;
    }
    NSLog(@">>>>>Not connected to the internet!");
    return false;
}

/********************************************************************************************
 * @method noInternetError
 * @abstract gives alert view error when not connected to internet to search
 * @description
 ********************************************************************************************/
- (void)noInternetError
{
    NSString *title = @"Sorry! Must be connected to the internet to view the trailer!";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:title delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    NSLog(@"Showing no internet connection alert");
}
@end

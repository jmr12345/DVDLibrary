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
    switch (section){
        case 0:
            return 3;
            break;
        case 1:
            return 1;
            break;
        case 2:
            NSLog(@"Cast:%@",self.movie.cast);
            NSLog(@"Cast count:%lu",[self.movie.cast count]);
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
        case 1:
            cell.textLabel.text = self.movie.description;
            break;
        case 2:
            cell.textLabel.text = [self.movie.cast objectAtIndex:indexPath.row];
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==1 & indexPath.row==0)
    {
        
        CGRect rect = [self.movie.description boundingRectWithSize:CGSizeMake(300.f, CGFLOAT_MAX)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]}
                                             context:nil];
        CGSize strSize = rect.size;
        NSLog(@"HEIGHT:%f",strSize.height);
        return (strSize.height+5);
    }
    else return 50;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"TrailerSegue"]) {
        
        NSLog(@"websegue");
        
        // Get destination view
        WebViewController *wvc = [segue destinationViewController];
        
        // Get button tag
        NSInteger tagIndex = [(UIButton *)sender tag];
        
        // Set the site in the new view
        //[wvc.trailerURL = self.movie.trailerURL;
    }
}


//#pragma YouTube
//
//- (void)webViewDidFinishLoad:(UIWebView *)_webView {
//	UIButton *b = [self findButtonInView:_webView];
//	[b sendActionsForControlEvents:UIControlEventTouchUpInside];
//}
//
//- (UIButton *)findButtonInView:(UIView *)view {
//	UIButton *button = nil;
//	
//	if ([view isMemberOfClass:[UIButton class]]) {
//		return (UIButton *)view;
//	}
//	
//	if (view.subviews && [view.subviews count] > 0) {
//		for (UIView *subview in view.subviews) {
//			button = [self findButtonInView:subview];
//			if (button) return button;
//		}
//	}
//	
//	return button;
//}

//- (IBAction)watchTrailer:(id)sender {
//    // This is a youtube video.  Put up an invisible UIWebView
//    if (self.youTubeWebView == nil) {
//        self.youTubeWebView = [[UIWebView alloc] initWithFrame:CGRectMake(5.0, 5.0, 2.0, 2.0)];
//        self.youTubeWebView.scalesPageToFit = YES;
//        self.youTubeWebView.delegate = self;
//        
//        [self.view insertSubview:self.youTubeWebView atIndex:0];
//    }
//    NSString* embedHTML = @""
//    "<html><head>"
//    "<style type=\"text/css\">"
//    "body {"
//    "background-color: transparent;"
//    "color: white;"
//    "}"
//    "</style>"
//    "</head><body style=\"margin:0\">"
//    "<object width=\"%0.0f\" height=\"%0.0f\"><param name=\"movie\" value=\"%@&autoplay=1\">"
//    "</param><embed src=\"%@&autoplay=1\" type=\"application/x-shockwave-flash\" width=\"%0.0f\" height=\"%0.0f\"></embed></object>"
//    "</body></html>";
//    NSString *html = [NSString stringWithFormat:embedHTML,
//                      self.youTubeWebView.frame.size.width,
//                      self.youTubeWebView.frame.size.height,
//                      "http://www.youtube.com/watch?v=ISJR4rVO0TQ",
//                      "http://www.youtube.com/watch?v=ISJR4rVO0TQ",
//                      self.youTubeWebView.frame.size.width,
//                      self.youTubeWebView.frame.size.height];
//    [self.youTubeWebView loadHTMLString:html baseURL:nil];
//    
//}

       
@end

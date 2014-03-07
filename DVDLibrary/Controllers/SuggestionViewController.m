//
//  SuggestionViewController.m
//  DVDLibrary
//
//  Created by Ming on 3/1/14.
//  Copyright (c) 2014 Ming. All rights reserved.
//

#import "SuggestionViewController.h"
#import "MovieData.h"
#import "Movie.h"

@interface SuggestionViewController ()
@property (strong, nonatomic) NSArray *movieArray;
@end

@implementation SuggestionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *data = [[MovieData alloc] init].movieData;
    self.movieArray = data;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.movieArray count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    Movie *movie = [self.movieArray objectAtIndex:row];
    return movie.title;
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, pickerView.frame.size.width-50, 44)];
    label.backgroundColor = [UIColor purpleColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    Movie *movie = [self.movieArray objectAtIndex:row];
    label.text = movie.title;

    return label;
}

- (IBAction)spin:(id)sender {
    
    [self performSelector: @selector(pickRandomRow)
               withObject: nil
               afterDelay: 0];
    [self performSelector: @selector(pickRandomRow)
               withObject: nil
               afterDelay: 0.5];
    [self performSelector: @selector(pickRandomRow)
               withObject: nil
               afterDelay: 1];
    [self performSelector: @selector(pickRandomRow)
               withObject: nil
               afterDelay: 1.5];
    [self performSelector: @selector(showSelectedMovie)
               withObject: nil
               afterDelay: 2];
}

-(void)pickRandomRow
{
    [self.picker selectRow: (arc4random() % [self.movieArray count]) inComponent: 0 animated: YES];
}

-(void)showSelectedMovie
{
    Movie *movie = (Movie*)[self.movieArray objectAtIndex:[self.picker selectedRowInComponent:0]];
    
    NSString *movieTitle = movie.title;
    NSString *title = [[NSString alloc] initWithFormat:@"Time to watch %@!", movieTitle];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:title delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    [alert show];
}

@end

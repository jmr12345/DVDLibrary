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
@property (strong, nonatomic) NSArray *array;
@end

@implementation SuggestionViewController

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
	// Do any additional setup after loading the view.
    NSArray *data = [[MovieData alloc] init].movieData;
    
    self.array = data;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)spin:(id)sender {
    [self.picker selectRow:[_array count]-1 inComponent:0 animated: YES];
    
    [self.picker selectRow:0 inComponent:0 animated: YES];
    
    [self.picker selectRow:2 inComponent:0 animated: YES];
    
    
//     [self.picker selectRow: (arc4random() % [_array count]) inComponent: 0 animated: YES];
//    
//    Movie *movie = (Movie*)[_array objectAtIndex:[_picker selectedRowInComponent:0]];
//    
//    NSString *select = movie.title;
//    
//    NSString *title = [[NSString alloc] initWithFormat:@"You selected %@!", select];
//    
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:@"YAY!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//    
//    [alert show];
    
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
    
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [_array count];
    
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    Movie *movie = [_array objectAtIndex:row];
    return movie.title;
    
}
@end

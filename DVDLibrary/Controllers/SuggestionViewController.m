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
    
    [self performSelector: @selector(setRandom)
               withObject: nil
               afterDelay: 0];
    [self performSelector: @selector(setRandom)
               withObject: nil
               afterDelay: 0.5];
    [self performSelector: @selector(setRandom)
               withObject: nil
               afterDelay: 1];
    [self performSelector: @selector(setRandom)
               withObject: nil
               afterDelay: 1.5];


    
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

-(void)setRandom{
[self.picker selectRow: (arc4random() % [_array count]) inComponent: 0 animated: YES];
}

-(void) setPickerRowToLastRow;
{
    [self.picker selectRow:[self.picker numberOfRowsInComponent:0]-1 inComponent:0 animated:YES];
}
-(void) setPickerRowToFirstRow;
{
    [self.picker selectRow:1 inComponent:0 animated:YES];
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

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, pickerView.frame.size.width-50, 44)];
    label.backgroundColor = [UIColor purpleColor];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    Movie *movie = [self.array objectAtIndex:row];
    label.text = movie.title;

    return label;
}
@end

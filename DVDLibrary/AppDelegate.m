//
//  AppDelegate.m
//  DVDLibrary
//
//  Created by Ming on 2/26/14.
//  Copyright (c) 2014 Ming. All rights reserved.
//

#import "AppDelegate.h"
#import "MovieData.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    //set the initial launch date and load example data
    [self setPreferencesAndLoadData];

    return YES;
}

/********************************************************************************************
 * @method setPreferences
 * @abstract sets Initial run in nsuser defaults
 * @description gets NSUserDefaults and sets the initial date of first launch as Movie Library 
                Initial Run and loads example data for class purposes (example data would not be
                included if submitting to app store)
 ********************************************************************************************/
- (void)setPreferencesAndLoadData
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    // if the app has not been run yet
    if ([defaults boolForKey:@"MovieLibraryHasRunAppOnce"] == NO)
    {
        NSLog(@"Application is running for the first time");
        
        //formats current date
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"dd-MM-yy HH:mm"];
        NSString *dateString = [df stringFromDate:[NSDate date]];
        
        //sets date
        [defaults setObject:dateString forKey:@"Movie Library Initial Run"];
        //sets boolean for check when app is run again
        [defaults setBool:YES forKey:@"MovieLibraryHasRunAppOnce"];
        //for the pre-populated data <-- suppresses the successfully added alert
        [defaults setInteger:0 forKey:@"Movie Library initial run counter"];
        
        [defaults synchronize];
        
        NSLog(@"NSUserDefaults: %@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
        
        //load pre-populated data for example purposes for class (if sent to app store, we wouldn't include this)
        MovieData *initialData = [[MovieData alloc]init];
        NSLog(@"Loading initial data for example: %@", initialData);
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end

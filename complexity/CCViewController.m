//
//  CCViewController.m
//  complexity
//
//  Created by Patrick Madden on 12/7/13.
//  Copyright (c) 2013 Optimality Research Group. All rights reserved.
//

#import "CCViewController.h"
#define LDBG 0

@interface CCViewController ()

@end

@implementation CCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //if (LDBG)
    NSLog(@"Segue named %@ %p", segue.identifier, segue.destinationViewController);
    
    InfoViewController *vc = [segue destinationViewController];
    if ([segue.identifier isEqualToString:@"qs"])
        [vc setFileToLoad:@"qs"];
    if ([segue.identifier isEqualToString:@"bubble"])
        [vc setFileToLoad:@"bubble"];
    if ([segue.identifier isEqualToString:@"basics"])
        [vc setFileToLoad:@"basics"];
    
}

- (IBAction)done:(UIStoryboardSegue *)segue {
    if (LDBG) NSLog(@"Popping back to this view controller! %@ %p", segue.identifier, segue.destinationViewController);
    if (LDBG) NSLog(@"Back at main.  Destroy any peripheral or controller.");

    // reset UI elements etc here
}


@end

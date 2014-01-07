//
//  ComplexityGraphViewController.m
//  complexity
//
//  Created by Patrick Madden on 12/27/13.
//  Copyright (c) 2013 Optimality Research Group. All rights reserved.
//

#import "ComplexityGraphViewController.h"
#define LDBG 0
@interface ComplexityGraphViewController ()

@end

@implementation ComplexityGraphViewController
@synthesize complexityGraph, cgN;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)slideChange:(id)sender
{
    if (sender == nil)
    {
        [complexityGraph setNeedsDisplay];
        return;
    }
    
    // float *c = [complexityGraph c];
    UISlider *s = (UISlider *)sender;
    float *c = [complexityGraph c];
    switch ([s tag])
    {
        case 0:
        case 1:
        case 2:
        case 3:
            c[[s tag]] = [s value];
            if (LDBG) NSLog(@"Set curve %d to %f", (int) [s tag], [s value]);
            break;
        default:
            [complexityGraph setN:[s value]];
            break;
    }

    [complexityGraph setNeedsDisplay];

}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if (LDBG) NSLog(@"Segue named %@ %p", segue.identifier, segue.destinationViewController);
    
    InfoViewController *vc = [segue destinationViewController];
    if ([segue.identifier isEqualToString:@"qs"])
        [vc setFileToLoad:@"qs"];
    if ([segue.identifier isEqualToString:@"bubble"])
        [vc setFileToLoad:@"bubble"];
}

- (IBAction)done:(UIStoryboardSegue *)segue {
    if (LDBG) NSLog(@"Popping back to this view controller! %@ %p", segue.identifier, segue.destinationViewController);
    if (LDBG) NSLog(@"Back at main.  Destroy any peripheral or controller.");
    
    // reset UI elements etc here
}


@end

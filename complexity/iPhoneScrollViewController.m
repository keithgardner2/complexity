//
//  iPhoneScrollViewController.m
//  complexity
//
//  Created by Keith Gardner on 3/9/14.
//  Copyright (c) 2014 Optimality Research Group. All rights reserved.
//

#import "iPhoneScrollViewController.h"

@interface iPhoneScrollViewController ()

@end

@implementation iPhoneScrollViewController

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
    
    /*
    self.algColumn  = [[NSArray alloc]         initWithObjects:@"QS Hoare", @"QS Hoare Rand", @"QS Lomuto", @"QS Lomuto Rand",@"Insertion Sort",@"Selection Sort",@"Rank Sort",@"Heap Sort", @"Merge Sort", @"Bubble Sort", nil];
    self.optionsColumn = [[NSArray alloc] initWithObjects:@"Random", @"Ascending", @"Descending", @"Values Equal", nil];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
     */
        /*
         CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
         if(iOSDeviceScreenSize.height  == 568){
         NSLog(@"Loading 4 inch storyboard");
         myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(350, 50, 150, 162.0)];
         pickerOptions= [[UIPickerView alloc] initWithFrame:CGRectMake(400, 50, 150, 162.0)];
         }
         if(iOSDeviceScreenSize.height  == 480){
         NSLog(@"Loading 3.5 inch");
         myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(20, 120, 250, 162.0)];
         pickerOptions= [[UIPickerView alloc] initWithFrame:CGRectMake(270, 120, 250, 162.0)];
         }*/
    /*
    }
    else{
        _myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(715, 130, 230, 150)];
        _pickerOptions= [[UIPickerView alloc] initWithFrame:CGRectMake(715, 330, 230, 150)];
    }
    
    _myPickerView.tag = 0;
    _pickerOptions.tag = 1;
    
    _myPickerView.delegate = self;
    _pickerOptions.delegate = self;
    
    _myPickerView.showsSelectionIndicator = YES;
    _pickerOptions.showsSelectionIndicator = YES;
    
    [self.view addSubview:_myPickerView];
    [self.view addSubview:_pickerOptions];
    
    [self.view bringSubviewToFront:_myPickerView];
    [self.view bringSubviewToFront:_pickerOptions];
    
    [_myPickerView setBackgroundColor:[UIColor whiteColor]];
    [_pickerOptions setBackgroundColor:[UIColor whiteColor]];
*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  iPhoneScrollViewController.m
//  complexity
//
//  Created by Keith Gardner on 3/9/14.
//  Copyright (c) 2014 Optimality Research Group. All rights reserved.
//

#import "iPhoneScrollViewController.h"

UIPickerView *myPickerView;
UIPickerView *pickerOptions;

@interface iPhoneScrollViewController ()

@end

@implementation iPhoneScrollViewController
//
//@synthesize userAlg;
//@synthesize userData;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];

//    [userAlg setText:@"--"];
//    [userData setText:@"--"];
    //[userAlg

    
    self.algColumn  = [[NSArray alloc]         initWithObjects:@"QS Hoare", @"QS Hoare Rand", @"QS Lomuto", @"QS Lomuto Rand",@"Insertion Sort",@"Selection Sort",@"Rank Sort",@"Heap Sort", @"Merge Sort", @"Bubble Sort", nil];
    self.optionsColumn = [[NSArray alloc] initWithObjects:@"Random", @"Ascending", @"Descending", @"Values Equal", nil];
    
    NSLog(@"before if view did load iPhoneScrollVC");
    
//    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
//        
//        NSLog(@"in if view did load iPhoneScrollVC");
//        
//         CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
//         if(iOSDeviceScreenSize.height  == 568){
//             NSLog(@"Loading 4 inch storyboard");
//             myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(50, 50, 150, 162.0)];
//             
//             pickerOptions= [[UIPickerView alloc] initWithFrame:CGRectMake(200, 50, 150, 162.0)];
//         }
//         if(iOSDeviceScreenSize.height  == 480){
//
//             NSLog(@"Loading 3.5 inch");
//             myPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(19, 84, 215, 162.0)];
//             
//             pickerOptions= [[UIPickerView alloc] initWithFrame:CGRectMake(247, 84, 215, 162.0)];
//         }
//    }
    
    myPickerView.tag = 0;
    pickerOptions.tag = 1;
    
    myPickerView.delegate = self;
    pickerOptions.delegate = self;
    
    myPickerView.showsSelectionIndicator = YES;
    pickerOptions.showsSelectionIndicator = YES;
    
    [self.view addSubview:myPickerView];
    [self.view addSubview:pickerOptions];
    
    [self.view bringSubviewToFront:myPickerView];
    [self.view bringSubviewToFront:pickerOptions];
    
    [myPickerView setBackgroundColor:[UIColor whiteColor]];
    [pickerOptions setBackgroundColor:[UIColor whiteColor]];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    // Handle the selection
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSUInteger numRows;
    if(pickerView.tag == 0){
        numRows = 10;//8 algorithms currently
    }
    else{
        numRows = 4;//4 data options
    }
    
    return numRows;
}

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// tell the picker the title for a given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if(pickerView.tag ==0){
        return _algColumn[row];
    }
    else{
        return _optionsColumn[row];
    }
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth;
    if(pickerView.tag == 0)
        sectionWidth = 150;
    else
        sectionWidth = 200;
    
    return sectionWidth;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)goBack:(id)sender {
    NSInteger algTypePicker;
    NSInteger optionType;
    
    algTypePicker = [myPickerView selectedRowInComponent:0];
    optionType = [pickerOptions selectedRowInComponent:0];
    
    NSLog(@"alg: %li", (long)algTypePicker);
    NSLog(@"opt: %li", (long)optionType);

}

@end

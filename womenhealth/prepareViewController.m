//
//  prepareViewController.m
//  womenhealth
//
//  Created by smart_parking on 8/5/13.
//  Copyright (c) 2013 codes. All rights reserved.
//

#import "prepareViewController.h"

@interface prepareViewController ()

@end

@implementation prepareViewController

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
    
    //[self.text setFont:[UIFont fontWithName:@"Thonburi" size:17.0f]];
    [super viewDidLoad];
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc]initWithString:self.text.text];
    
    NSArray *words=[self.text.text componentsSeparatedByString:@" "];
    
    
    for (NSString *word in words) {
      
        if ([word isEqualToString:@"colonoscopy"]) {
            NSRange range=[self.text.text rangeOfString:word];
            UIFont *font=[UIFont fontWithName:@"Thonburi-Bold" size:20.0f];
            [string addAttribute:NSFontAttributeName value:font range:range];
           }
     
    [self.text setAttributedText:string];
    }

	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setText:nil];
    [self setText:nil];
    [super viewDidUnload];
}
@end

//
//  ViewController.m
//  CCCountingiOS
//
//  Created by deng you hua on 11/7/17.
//  Copyright © 2017 CC | ccworld1000@gmail.com. All rights reserved.
//

#import "ViewController.h"
#import <CCCounting/CCCounting.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet CCCounting *label;
@property (weak, nonatomic) IBOutlet CCCounting *myLabel;
@property (weak, nonatomic) IBOutlet CCCounting *countPercentageLabel;
@property (weak, nonatomic) IBOutlet CCCounting *scoreLabel;
@property (weak, nonatomic) IBOutlet CCCounting *attributedLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // make one that counts up
    self.myLabel.cType = CCCountingTypeLinear;
    self.myLabel.format = @"%d";
    [self.myLabel countFrom:1 to:10 withDuration:3.0];
    
    // make one that counts up from 5% to 10%, using ease in out (the default)
    self.countPercentageLabel.format = @"%.1f%%";
    [self.countPercentageLabel countFrom:5 to:10];
    
    // count up using a string that uses a number formatter
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = kCFNumberFormatterDecimalStyle;
    _scoreLabel.formatBlock = ^NSString* (CGFloat value) {
        NSString* formatted = [formatter stringFromNumber:@((int)value)];
        return [NSString stringWithFormat:@"Score: %@",formatted];
    };
    _scoreLabel.cType = CCCountingTypeEaseOut;
    [_scoreLabel countFrom:0 to:10000 withDuration:2.5];
    
    // count up with attributed string
    NSInteger toValue = 100;
    _attributedLabel.attributedFormatBlock = ^NSAttributedString* (CGFloat value) {
        NSDictionary* normal = @{ NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue-UltraLight" size: 20] };
        NSDictionary* highlight = @{ NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue" size: 20] };
        
        NSString* prefix = [NSString stringWithFormat:@"%d", (int)value];
        NSString* postfix = [NSString stringWithFormat:@"/%d", (int)toValue];
        
        NSMutableAttributedString* prefixAttr = [[NSMutableAttributedString alloc] initWithString: prefix
                                                                                       attributes: highlight];
        NSAttributedString* postfixAttr = [[NSAttributedString alloc] initWithString: postfix
                                                                          attributes: normal];
        [prefixAttr appendAttributedString: postfixAttr];
        
        return prefixAttr;
    };
    [_attributedLabel countFrom:0 to:toValue withDuration:2.5];
    
    self.label.cType = CCCountingTypeEaseInOut;
    self.label.format = @"%d%%";
    __weak ViewController* blockSelf = self;
    self.label.completionBlock = ^{
        blockSelf.label.textColor = [UIColor colorWithRed:0 green:0.5 blue:0 alpha:1];
    };
    [self.label countFrom:0 to:100];
}


@end

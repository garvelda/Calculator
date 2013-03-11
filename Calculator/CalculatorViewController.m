//
//  CalculatorViewController.m
//  Calculator
//
//  Created by David Eleazar García Santiago on 04/03/13.
//  Copyright (c) 2013 David Eleazar García Santiago. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) CalculatorBrain *calculatorBrain;
@end

@implementation CalculatorViewController

- (CalculatorBrain *)calculatorBrain {
	if (!_calculatorBrain) {
		_calculatorBrain = [[CalculatorBrain alloc] init];
	}
	
	return _calculatorBrain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = sender.currentTitle;
    
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
        
}

- (IBAction)operationPressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) {
		[self enterPressed];
	}
	
	double result = [self.calculatorBrain performOperation:sender.currentTitle];
	NSString *resultString = [NSString stringWithFormat:@"%g", result];
	[self.calculatorBrain pushOperand:result];
	self.display.text = resultString;
}

- (IBAction)enterPressed {
	[self.calculatorBrain pushOperand:[self.display.text doubleValue]];
	self.userIsInTheMiddleOfEnteringANumber = NO;
}

@end

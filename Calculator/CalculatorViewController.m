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
@property (nonatomic) NSMutableDictionary *testVariableValues;
@property (nonatomic) NSDictionary *test1;
@property (nonatomic) NSDictionary *test2;
@property (nonatomic) NSDictionary *test3;
@end

@implementation CalculatorViewController

- (NSDictionary *) test1 {
	if (!_test1) {
		_test1 = [[NSDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithDouble:1], @"x", [NSNumber numberWithDouble:2], @"y", [NSNumber numberWithDouble:3], @"z", nil];
	}
	
	return _test1;
}

- (NSDictionary *) test2 {
	if (!_test2) {
		_test2 = [[NSDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithDouble:4], @"x", [NSNumber numberWithDouble:5], @"y", [NSNumber numberWithDouble:6], @"z", nil];
	}
	
	return _test2;
}

- (NSDictionary *) test3 {
	if (!_test3) {
		_test3 = [[NSDictionary alloc] initWithObjectsAndKeys: [NSNumber numberWithDouble:7], @"x", [NSNumber numberWithDouble:8], @"y", [NSNumber numberWithDouble:9], @"z", nil];
	}
	
	return _test3;
}

- (CalculatorBrain *)calculatorBrain {
	if (!_calculatorBrain) {
		_calculatorBrain = [[CalculatorBrain alloc] init];
	}
	
	return _calculatorBrain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = sender.currentTitle;
    
    if (self.userIsInTheMiddleOfEnteringANumber) {
		self.displayResult.text = [self.displayResult.text stringByAppendingString:digit];
    } else {
		if (![digit isEqualToString:@"0"]) {
			self.displayResult.text = digit;
			self.userIsInTheMiddleOfEnteringANumber = YES;
		}
    }
}

- (IBAction)operationPressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) {
		[self enterPressed];
	}
	
	double result = [self.calculatorBrain performOperation:sender.currentTitle];
	self.displayProgram.text = [CalculatorBrain descriptionOfProgram:self.calculatorBrain.program];
	self.displayResult.text = [NSString stringWithFormat:@"%g", result];
	
}

- (IBAction)enterPressed {
	[self.calculatorBrain pushOperand:[self.displayResult.text doubleValue]];
	self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (IBAction)undoPressed {
	if (self.userIsInTheMiddleOfEnteringANumber) {
		NSMutableString *displayResultText = [self.displayResult.text mutableCopy];
		int displayResultTextLength = [displayResultText length];
		
		if (displayResultTextLength > 0) {
			[displayResultText deleteCharactersInRange:NSMakeRange([displayResultText length]-1, 1)];
			self.displayResult.text = [displayResultText copy];
		} else if (displayResultTextLength == 0) {
			self.userIsInTheMiddleOfEnteringANumber = NO;
			[CalculatorBrain runProgram:self.calculatorBrain.program];
		}
	} else {
		// Eliminar el ultimo elemento de la pila
	}
}

- (IBAction)testPressed:(UIButton *)sender {
	if ([sender.currentTitle isEqualToString:@"Test 1"]) {
		self.testVariableValues = [self.test1 mutableCopy];
	} else if ([sender.currentTitle isEqualToString:@"Test 2"]) {
		self.testVariableValues = [self.test2 mutableCopy];
	} else if ([sender.currentTitle isEqualToString:@"Test 3"]) {
		self.testVariableValues = [self.test3 mutableCopy];
	}
	
	self.displayVariablesValues.text = [self formatVariablesValues:self.testVariableValues];
	self.displayResult.text = [NSString stringWithFormat:@"%g", [CalculatorBrain runProgram:self.calculatorBrain.program usingVariableValues:self.testVariableValues]];
}

- (NSString *) formatVariablesValues:(NSDictionary *) dict {
	NSString *variablesText = @"";
	
	if (dict) {
		NSArray *keys = [dict allKeys];
		
		for (NSString *key in keys) {
			if (key) {
				variablesText = [variablesText stringByAppendingFormat:@"%@ = %@, ", key, [dict valueForKey:key]];
			}
		}
	}
		
	return [variablesText substringToIndex:[variablesText length] - 2];
}

- (IBAction)variablePressed:(UIButton *)sender {
    NSString *variable = sender.currentTitle;
	self.displayResult.text = variable;
	[self.calculatorBrain pushVariable:variable];
}

- (IBAction)cPressed {
	self.displayResult.text = @"0";
	self.displayProgram.text = @"";
	self.displayVariablesValues.text = @"";
	[self.testVariableValues removeAllObjects];
}

@end

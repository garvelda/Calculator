//
//  CalculatorBrain.m
//  Calculator
//
//  Created by CS193p Instructor.
//  Copyright (c) 2011 Stanford University.
//  All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@property (nonatomic) NSMutableDictionary *testVariableValues;

@property (nonatomic) NSSet *operations;
@property (nonatomic) NSSet *variables;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;

- (NSSet *) operations {
	if (!_operations) {
		_operations = [[NSSet alloc] initWithObjects: @"+", @"-", @"*", @"/", @"sqrt", @"sin", @"cos", nil];
	}
	
	return _operations;
}

- (NSSet *) variables {
	if (!_variables) {
		_variables = [[NSSet alloc] initWithObjects: @"x", @"y", @"z", nil];
	}
	
	return _variables;
}

- (NSMutableArray *)programStack {
    if (_programStack == nil) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}

- (id)program {
    return [self.programStack copy];
}

- (NSString *) description {
	return [CalculatorBrain descriptionOfProgram:self.program];
}

+ (NSString *)popOperandOffProgramStackForDescription:(NSMutableArray *)stack {
    NSString *description = @"";
	NSSet *oneParamaterOperations = [[NSSet alloc] initWithObjects: @"sqrt", @"sin", @"cos", nil];
	NSSet *twoParamatersOperations = [[NSSet alloc] initWithObjects: @"+", @"-", @"*", @"/", nil];
	
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        description = [description stringByAppendingString:topOfStack];
    } else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
		
		if ([oneParamaterOperations containsObject:operation]) {
			description = [description stringByAppendingFormat:@" %@(%@)", operation, [self popOperandOffProgramStackForDescription:stack]];
		} else if ([twoParamatersOperations containsObject:operation]) {
			id secondParameter = [self popOperandOffProgramStackForDescription:stack];

			if ([secondParameter isKindOfClass:[NSString class]]) {
				if ([oneParamaterOperations containsObject:secondParameter]) {
					description = [description stringByAppendingFormat:@" %@(%@)", operation, [self popOperandOffProgramStackForDescription:stack]];
				}
			} else if ([secondParameter isKindOfClass:[NSNumber class]]) {
				description = [description stringByAppendingFormat:@" (%@ %@ %@)", [self popOperandOffProgramStackForDescription:stack], operation, secondParameter];
			}
		}
    }
	
    return description;
}

+ (NSSet *)variablesUsedInProgram:(id)program {
	NSSet *setOfVariablesInProgram;
	
    if ([program isKindOfClass:[NSArray class]]) {
		for (id operand in program) {
			if ([operand isKindOfClass:[NSString class]]) {
				// Si es una variable la agregamos al NSSet de salida
			}
		}
    }
	
	return setOfVariablesInProgram;
}

+ (NSString *)descriptionOfProgram:(id)program {
    NSMutableArray *stack;
	
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
	
    return [self popOperandOffProgramStackForDescription:stack];
}

- (void)pushOperand:(double)operand {
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double)performOperation:(NSString *)operation {
    [self.programStack addObject:operation];
    return [[self class] runProgram:self.program];
}

+ (double)popOperandOffProgramStack:(NSMutableArray *)stack {
    double result = 0;
	
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [topOfStack doubleValue];
    } else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
		
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffProgramStack:stack] +
			[self popOperandOffProgramStack:stack];
        } else if ([@"*" isEqualToString:operation]) {
            result = [self popOperandOffProgramStack:stack] *
			[self popOperandOffProgramStack:stack];
        } else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffProgramStack:stack];
            result = [self popOperandOffProgramStack:stack] - subtrahend;
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffProgramStack:stack];
            if (divisor) result = [self popOperandOffProgramStack:stack] / divisor;
        } else if ([operation isEqualToString:@"sqrt"]) {
			result = sqrt([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"sin"]) {
			result = sin([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"cos"]) {
			result = cos([self popOperandOffProgramStack:stack]);
		}
    }
	
    return result;
}

+ (double)runProgram:(id)program {
    NSMutableArray *stack;
	
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
	
    return [self popOperandOffProgramStack:stack];
}

@end

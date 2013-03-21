//
//  QuizViewController.m
//  Quiz
//
//  Created by Long Vinh Nguyen on 1/21/13.
//  Copyright (c) 2013 com.cscv. All rights reserved.
//

#import "QuizViewController.h"


@implementation QuizViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    // Call the init method implemented by the superclass
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        // Create two arrays and make the pointers point to them
        questions = [[NSMutableArray alloc] init];
        answers = [[NSMutableArray alloc] init];
        
        // Add questions and answers to the arrays
        [questions addObject:@"What is 7 + 7?"];
        [answers addObject:@"14"];
        
        [questions addObject:@"What is the capital of Vermont?"];
        [answers addObject:@"Montpelier"];
        
        [questions addObject:@"From what is cognac made?"];
        [answers addObject:@"Grapes"];
    }
    
    // Return address of the new object
    return self;
}

- (void)showQuestion:(id)sender
{
    // Step to the next question
    currentQuestionIndex++;
    
    // Am I past the last question?
    if (currentQuestionIndex == [questions count]) {
        currentQuestionIndex = 0;
    }
    
    // Get the string at that index in the question array
    NSString *question = [questions objectAtIndex:currentQuestionIndex];
    
    // Log the string to the console
    NSLog(@"displaying question: %@", question);
    
    // Displaying the string in the question of field
    [questionField setText:question];
    
    // Clear the answer field
    [answerField setText:@"???"];
    
}


- (void)showAnswer:(id)sender
{
    // What is the answer to the current quesstion?
    NSString *answer = [answers objectAtIndex:currentQuestionIndex];
    
    // Display it in the answer field
    [answerField setText:answer];
}

















@end

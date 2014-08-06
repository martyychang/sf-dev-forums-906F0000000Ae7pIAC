//
//  ViewController.m
//  Salesforce REST
//
//  Created by Marty Y. Chang on 8/5/14.
//  Copyright (c) 2014 mycR Enterprises. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *endpointField;
@property (weak, nonatomic) IBOutlet UITextField *accessTokenField;
@property (weak, nonatomic) IBOutlet UITextField *subjectIdField;
@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property (weak, nonatomic) IBOutlet UITextView *responseBodyView;
@property (weak, nonatomic) IBOutlet UITextField *bodyField;
@end

@implementation ViewController

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

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.responseBodyView.text = response.description;
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.responseBodyView.text = [error localizedDescription];
}

- (IBAction)testEndpoint:(id)sender {
    self.responseBodyView.text = @"Testing endpoint...";
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.endpointField.text] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (!connection) {
        self.responseBodyView.text = @"Connection failed!";
    }
}

/*
 * Based on Mac Developer Library's URL Loading System Programming Guide
 */
- (IBAction)postToChatter2:(id)sender {
    // Inform the user that we are posting to Chatter now
    self.responseBodyView.text = @"Posting to Chatter...";
    
    // Construct the POST request
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.endpointField.text]];
    
    // Set the request's Authorization header
    [postRequest setValue:[NSString stringWithFormat:@"Bearer %@", self.accessTokenField.text] forHTTPHeaderField:@"Authorization"];
    
    // Set the request's content type to application/json
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Designate the request as a POST request
    [postRequest setHTTPMethod:@"POST"];
    
    // Set the request body
    NSMutableData *requestData = [[NSMutableData alloc] init];
    [requestData appendData:[[NSString stringWithFormat:@"{\"body\":{\"messageSegments\":[{\"type\":\"Text\",\"text\":\"%@\"}]},\"feedElementType\":\"FeedItem\",\"subjectId\":\"%@\"}", self.bodyField.text, self.subjectIdField.text] dataUsingEncoding:NSUTF8StringEncoding]];
    [postRequest setHTTPBody:requestData];
    
    // Initialize the URL connection, which automatically sends the request
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:postRequest delegate:self];
}
@end

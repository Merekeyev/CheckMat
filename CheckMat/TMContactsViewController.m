//
//  TMContactsViewController.m
//  CheckMat
//
//  Created by Temirlan Merekeyev on 17.06.17.
//  Copyright © 2017 Temirlan Merekeyev. All rights reserved.
//

#import "TMContactsViewController.h"
#import <MapKit/MapKit.h>
#import <MessageUI/MessageUI.h>
@interface TMContactsViewController () <MKMapViewDelegate, MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (assign,nonatomic)CLLocationCoordinate2D location;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberOne;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberTwo;
@property (weak, nonatomic) IBOutlet UILabel *email;
@property (weak, nonatomic) IBOutlet UILabel *website;
@property (weak, nonatomic) IBOutlet UILabel *instagram;


@end

@implementation TMContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _location.latitude = 43.2370;
    _location.longitude = 76.8996;
    MKPointAnnotation* annotation = [[MKPointAnnotation alloc] init];
    annotation.coordinate = _location;
    [annotation setCoordinate:_location];
    [annotation setTitle:@"Checkmat"];
    [self.mapView addAnnotation:annotation];
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(_location, 500,500);
    [self.mapView setRegion:viewRegion animated:YES];
    
    [self call:self.phoneNumberOne];
    [self call:self.phoneNumberTwo];
    [self sendEmail];
    [self openSocial:self.website];
    [self openSocial:self.instagram];
 
    // Do any additional setup after loading the view.
}

#pragma mark - Map methods

-(void)checkMatClicked:(id)sender{
    NSString* directionURL = [NSString stringWithFormat:@"http://maps.apple.com/?ll=%f,%f", _location.latitude,_location.longitude];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: directionURL]
                                       options:@{}
                             completionHandler:nil];
}

-(MKAnnotationView*)mapView:(MKMapView*)mapView viewForAnnotation:(nonnull id<MKAnnotation>)annotation{
    MKPinAnnotationView* pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"current"];
    [pin setPinTintColor:[UIColor blackColor]];
    UIButton* annotationButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    if([[annotation title] isEqualToString:@"Checkmat"]){
        [annotationButton addTarget:self
                             action:@selector(checkMatClicked:)
                   forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    [pin setRightCalloutAccessoryView:annotationButton];
    [pin setDraggable:NO];
    [pin setHighlighted:YES];
    [pin setAnimatesDrop:YES];
    [pin setCanShowCallout:YES];
    
    return pin;
    
}
#pragma mark - Phone methods

-(void)call:(UILabel*)phone{
    
    if([phone isEqual:self.phoneNumberOne]){
       
        [self.phoneNumberOne setUserInteractionEnabled:YES];
        UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                               action:@selector(labelTappedPhoneNumberOne) ];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        [self.phoneNumberOne addGestureRecognizer:tapGestureRecognizer];
        
    }else{
        
        [self.phoneNumberTwo setUserInteractionEnabled:YES];
        UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                               action:@selector(labelTappedPhoneNumberTwo) ];
        tapGestureRecognizer.numberOfTapsRequired = 1;
        [self.phoneNumberTwo addGestureRecognizer:tapGestureRecognizer];
    }
    
   
    
}

-(void)labelTappedPhoneNumberOne{
    
    
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.phoneNumberOne.text]]
                                       options:@{}
                             completionHandler:nil];
}

-(void)labelTappedPhoneNumberTwo{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.phoneNumberTwo.text]]
                                       options:@{}
                             completionHandler:nil];
}

#pragma mark - Email

-(void)sendEmail{
    
    [self.email setUserInteractionEnabled:YES];
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(sendEmailSelector)];
    tapGesture.numberOfTapsRequired = 1;
    [self.email addGestureRecognizer:tapGesture];
}

- (void)sendEmailSelector {
   
    NSString *emailTitle = @"Вопрос";
    
    NSString *messageBody = @"";
    
    NSArray *toRecipents = [NSArray arrayWithObject:@"info@checkmat.kz"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    
    [self presentViewController:mc animated:YES completion:NULL];
    
}
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            
            break;
        case MFMailComposeResultSaved:
           
            break;
        case MFMailComposeResultSent:
            
            break;
        case MFMailComposeResultFailed:
            
            break;
        default:
            break;
    }
    
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark - Social

-(void)openSocial:(UILabel*) site{
    if([site isEqual:self.website]){
        [self.website setUserInteractionEnabled:YES];
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(openWebsite)];
        tapGesture.numberOfTapsRequired = 1;
        [self.website addGestureRecognizer:tapGesture];
    }else{
        [self.instagram setUserInteractionEnabled:YES];
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(openInstagram)];
        tapGesture.numberOfTapsRequired = 1;
        [self.instagram addGestureRecognizer:tapGesture];
    }
    
}

-(void)openWebsite{
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://checkmat.kz"]
                                       options:@{}
                             completionHandler:nil];
    
}

-(void)openInstagram{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.instagram.com/checkmat_almaty/"]
                                       options:@{}
                             completionHandler:nil];
}



#pragma mark - Alert

- (void) alertTitle:(NSString*) title
            Message:(NSString*) message
             Button:(NSString*) buttonText{
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction actionWithTitle:buttonText
                                                       style:UIAlertActionStyleCancel
                                                     handler:nil];
    [alert addAction:okButton];
    [self presentViewController:alert
                       animated:YES
                     completion:nil];
    
    
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end

//
//  TMHomeViewController.m
//  CheckMat
//
//  Created by Temirlan Merekeyev on 19.06.17.
//  Copyright © 2017 Temirlan Merekeyev. All rights reserved.
//

#import "TMHomeViewController.h"
#import "TMServerManager.h"
@interface TMHomeViewController () <UITableViewDelegate, UITableViewDataSource>
@property(strong,nonatomic)NSMutableArray* newsArray;
@property(strong,nonatomic)NSMutableArray* titleArray;
@property(strong,nonatomic)NSMutableArray* dateArray;
@property(strong,nonatomic)NSMutableArray* attrArray;
@property(strong,nonatomic)NSArray* json;
@property(strong,nonatomic)NSAttributedString* attr;
@end
typedef void(^ getDataCompletion)(BOOL) ;
@implementation TMHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView registerClass:[UITableViewCell self] forCellReuseIdentifier:@"Cell"];
    self.newsArray  = [NSMutableArray array];
    self.titleArray = [NSMutableArray array];
    self.dateArray  = [NSMutableArray array];
    [self loadNews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - API

-(void)getData:(getDataCompletion)complblock{
    
    [[TMServerManager sharedManager] getHomeDataOnSuccess:^(NSArray *news, NSArray *titleArray, NSArray *date) {
        [self.newsArray addObjectsFromArray:news];
        [self.titleArray addObjectsFromArray:titleArray];
        [self.dateArray addObjectsFromArray:date];
    } onFailure:^(NSError *error) {
        NSLog(@"Error %@", error);
    }];
    
}

-(void) loadNews{
    
    NSURL* url = [NSURL URLWithString:@"http://app.checkmat.kz/api/article/get-by-category-slug?slug=news"];
    
    NSData* data = [NSData dataWithContentsOfURL:url];
    
    self.json = [NSJSONSerialization JSONObjectWithData:data
                                                options:kNilOptions
                                                  error:nil];
    
    
    self.newsArray  = [NSMutableArray array];
    self.titleArray = [NSMutableArray array];
    self.dateArray  = [NSMutableArray array];
    self.attrArray  = [NSMutableArray array];
    NSArray* dictsArray = self.json;
    
    
    for (NSDictionary* dict in dictsArray){
        [self.newsArray addObject:[dict objectForKey:@"body"]];
        [self.titleArray addObject:[dict objectForKey:@"title"]];
        [self.dateArray addObject:[dict objectForKey:@"updated_at"]];
        
    }
    
    for (int i = 0; i < self.newsArray.count; i++) {
        self.attr = [[NSAttributedString alloc]
                     initWithData:[[self.newsArray objectAtIndex:i] dataUsingEncoding:NSUnicodeStringEncoding]
                     options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        [self.attrArray addObject:self.attr];
        
    }
    
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.attrArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [[self.attrArray objectAtIndex:indexPath.row] string];
    cell.accessoryType = UITableViewCellAccessoryNone;
   
    //cell.detailTextLabel.text = [[self.attrArray objectAtIndex:indexPath.row] string];
    
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

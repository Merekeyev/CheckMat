//
//  TMNewsViewController.m
//  CheckMat
//
//  Created by Temirlan Merekeyev on 12.06.17.
//  Copyright © 2017 Temirlan Merekeyev. All rights reserved.
//

#import "TMNewsViewController.h"
#import "TMServerManager.h"
#import "TMDetailViewController.h"
@interface TMNewsViewController ()
@property(strong,nonatomic)NSMutableArray* newsArray;
@property(strong,nonatomic)NSMutableArray* titleArray;
@property(strong,nonatomic)NSMutableArray* attrArray;
@property(strong,nonatomic)NSArray* json;
@property(strong,nonatomic)NSAttributedString* attr;
@property(strong,nonatomic) IBOutlet UITableView *newsTable;
@property(strong,nonatomic)TMDetailViewController* dvc;
@end

typedef void(^ getInfoCompletion)(BOOL) ;

@implementation TMNewsViewController

/*
 self.attr = [[NSAttributedString alloc]
 initWithData:[[self.newsArray objectAtIndex:i] dataUsingEncoding:NSUnicodeStringEncoding]
 options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
 NSLog(@"%@", [self.attr string]);
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell self] forCellReuseIdentifier:@"Cell"];
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.dvc = [storyboard instantiateViewControllerWithIdentifier:@"TMDetailViewController"];
   
    self.newsArray = [NSMutableArray array];
    self.titleArray = [NSMutableArray array];
    [self loadNews];
  /*  [self getInfo:^(BOOL finished) {
       
        if(finished){
            for(int i = 0; i < self.newsArray.count; i++){
                self.attr = [[NSAttributedString alloc]
                             initWithData:[[self.newsArray objectAtIndex:i] dataUsingEncoding:NSUnicodeStringEncoding]
                             options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
                NSLog(@"Title - %@, Body - %@",[self.titleArray objectAtIndex:i], [self.attr string]);
                
            }
            [self.tableView reloadData];
        }
    }];*/
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - API
-(void) getInfo:(getInfoCompletion) complblock{
    
    [[TMServerManager sharedManager] getInfoDataOnSuccess:^(NSArray *infoArray, NSArray *titleArray) {
        [self.newsArray addObjectsFromArray:infoArray];
        [self.titleArray addObjectsFromArray:titleArray];
        
        complblock(YES);
    } onFailure:^(NSError *error) {
        NSLog(@"Error %@", error);
    }];
    

}
     

-(void) loadNews{
    
    NSURL* url = [NSURL URLWithString:@"http://app.checkmat.kz/api/article/get-by-category-slug?slug=info"];
    
    NSData* data = [NSData dataWithContentsOfURL:url];
    
    self.json = [NSJSONSerialization JSONObjectWithData:data
                                                     options:kNilOptions
                                                       error:nil];
    
    
    self.newsArray = [NSMutableArray array];
    self.titleArray = [NSMutableArray array];
    self.attrArray = [NSMutableArray array];
    NSArray* dictsArray = self.json;
    
    
    for (NSDictionary* dict in dictsArray){
        [self.newsArray addObject:[dict objectForKey:@"body"]];
        [self.titleArray addObject:[dict objectForKey:@"title"]];
        
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
    
    cell.textLabel.text = [self.titleArray objectAtIndex:indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableAttributedString* attrib = [self.attrArray objectAtIndex:indexPath.row];

    [self.navigationController pushViewController:self.dvc animated:YES];
    [self.dvc getInfo:attrib];
    
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
    
    if([[segue identifier] isEqualToString:@"showDetailView"]){
        NSIndexPath* indexPath = [self.tableView indexPathForSelectedRow];
        
        NSAttributedString* attrib = [self.attrArray objectAtIndex:indexPath.row];
        self.dvc = [segue destinationViewController];
        [self.dvc getInfo:attrib];
    }
}
*/

@end

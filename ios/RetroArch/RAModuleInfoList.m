/*  RetroArch - A frontend for libretro.
 *  Copyright (C) 2013 - Jason Fetters
 * 
 *  RetroArch is free software: you can redistribute it and/or modify it under the terms
 *  of the GNU General Public License as published by the Free Software Found-
 *  ation, either version 3 of the License, or (at your option) any later version.
 *
 *  RetroArch is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
 *  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
 *  PURPOSE.  See the GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License along with RetroArch.
 *  If not, see <http://www.gnu.org/licenses/>.
 */

@implementation RAModuleInfo
+ (RAModuleInfo*)moduleWithPath:(NSString*)thePath data:(config_file_t*)theData
{
   RAModuleInfo* new = [RAModuleInfo new];

   char* dispname = ios_config_get_string(theData, "display_name", [[[thePath lastPathComponent] stringByDeletingPathExtension] UTF8String]);
   char* confpath = ios_config_get_string(theData, "supported_extensions", "");

   new.displayName = [NSString stringWithUTF8String:dispname];
   new.path = thePath;
   new.configPath = [NSString stringWithFormat:@"%@/%@.cfg", [RetroArch_iOS get].system_directory, [[thePath lastPathComponent] stringByDeletingPathExtension]];
   new.data = theData;
   
   new.supportedExtensions = [[NSString stringWithUTF8String:confpath] componentsSeparatedByString:@"|"];
   
   free(dispname);
   free(confpath);
   
   return new;
}

- (void)dealloc
{
   config_file_free(self.data);
}

- (bool)supportsFileAtPath:(NSString*)path
{
   return [self.supportedExtensions containsObject:[[path pathExtension] lowercaseString]];
}

@end

static NSString* const labels[3] = {@"Emulator Name", @"Manufacturer", @"Name"};
static NSString* const keys[3] = {@"emuname", @"manufacturer", @"systemname"};
static NSString* const sectionNames[2] = {@"Emulator", @"Hardware"};
static const uint32_t sectionSizes[2] = {1, 2};

@implementation RAModuleInfoList
{
   RAModuleInfo* _data;
}

- (id)initWithModuleInfo:(RAModuleInfo*)info
{
   self = [super initWithStyle:UITableViewStyleGrouped];

   _data = info;
   return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
   return sizeof(sectionSizes) / sizeof(sectionSizes[0]);
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
   return sectionNames[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return sectionSizes[section];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   UITableViewCell* cell = [self.tableView dequeueReusableCellWithIdentifier:@"datacell"];
   cell = (cell != nil) ? cell : [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"datacell"];
   
   uint32_t sectionBase = 0;
   for (int i = 0; i != indexPath.section; i ++)
   {
      sectionBase += sectionSizes[i];
   }

   cell.textLabel.text = labels[sectionBase + indexPath.row];
   
   char* val = ios_config_get_string(_data.data, [keys[sectionBase + indexPath.row] UTF8String], "Unspecified");
   cell.detailTextLabel.text = [NSString stringWithUTF8String:val];
   free(val);

   return cell;
}

@end

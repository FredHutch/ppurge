# HPC File System Tools

Tools to help system administrators manage and monitor very large file systems.

## ppurge
ppurge (Parallel Purge) is a tool for maintaining HPC scratch storage volumes by removing files
past a certain age.
File purging is a two-step process. Step one is to mark a file as
"purgable" by moving the file into a temporary cache directory named .ppurge.
Ppurge subdirectories are local to the directory where the data files reside.
The files in `.ppurge` are kept for an additional n days until removed permanently.

When initially run on a system with files past the purge date, older files are moved to the `.ppurge` subdirectory but will not be removed until the purge directory and the file are past the purge age. 

At present, Ppurge does not remove directories. Many structural directories in a scatch system would be removed due to inactivity.
Not removing directories will leave many empty directory trees in
scratch file systems. I could implement a feature for deleting directories based on file system depth.
For scratch volumes with a well-defined directory
structure. For example, implement an option `--dirPurgeLevel 4`, which would remove directories below level 4 in the file system tree.

```/scratch30/department/user/project/work/purgeDirLevel```


### Build and install ###
ppurge is a single C program. glib > 2.10 is required. ppurge needs root sticky
bit to run. In practice pwalk should be run as root or as setuid. `sudo make install`
changes owner to root and setuid. The executable is kept in place.

make
sudo make install

### Usage ###
ppurge is designed to run daily on the same volume to remove files past a certain age. For example, the volume `/scratch/delete30` should not have files past 30 days.
Output is written in CSV format to stdout. Output is a list of all files that are purged or removed. The first character of each log line is 'P' or 'R', for Purged or Removed.
Format of output: type, depth, fname, UID, GID, st_size, st_mode, atime, mtime, ctime
ppurge creates a log file with the following name ppurge-YYYY.MM.DD-HH_MM_SS.log internal error messages.
Path names with illegal characters are written in the log file.


### Options
The --purgeDays is a manditory argument. Purge days is a positive integer with a unit of days.


### Issues
Ppurge should not run a volume with .snapshots or replication policies. ppurge will remove files from .git directories. Keeping a source tree in a  scratch file system may not be a good idea. Ppurge uses the atime of .ppurge directory for deciding when to remove files. Your HPC file system should have no `diratime` enabled. If needed, an aditional marker could be created to the purge directory for tracking removal times. At present, the software has been tested on BeeGFS and Isilon over NFSv3. 


#/!bin/perl -e

use strict;
use warnings;


&walk_dir_recursive("/tmp/111","/", "e9a256c893ad896");





sub walk_dir_recursive {

  my ($backupdir,$curdir,$sha1) = @_;
  print "\nSTART walking through dir $curdir\n";

  my $output = `git cat-file -p $sha1 `;
  foreach my $line (split /[\r\n]+/, $output) {
    my @tokens = split /\s+/, $line;
    next if(scalar(@tokens) != 4);
    my $type = $tokens[1]; #blob or tree
    my $sha1 = $tokens[2]; #952f2465f2ed8128b873d118ad741eb67b30680b
    my $name = $tokens[3]; # pipapo.txt
 
    if($type eq "blob"){
      print "DIR $curdir : found file $name with sha1 $sha1\n";
      `git cat-file -p $sha1 > $backupdir$curdir$name `
    }elsif($type eq "tree"){
      my $newcurdir = $curdir.$name."/";
      print "DIR $curdir : found DIR $name with sha1 $sha1 => $newcurdir\n";
      `mkdir $backupdir$newcurdir`;
      &walk_dir_recursive($backupdir,$newcurdir,$sha1);
    } 
  }
}






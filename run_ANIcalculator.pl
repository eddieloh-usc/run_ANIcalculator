#!/usr/bin/perl

use strict;

my $configfile = $ARGV[0] or die "Require path to configuration file\n"; 

my $starttime=localtime();
print STDERR "\n>>> Analysis started on $starttime\n\n";

##### Parse Config File #####
print STDERR ">>> Parsing configuration file...\n";
my %config=();
my $countconfigline=0;
open (CONFIG,"$configfile") or die "ERROR! Cannot open configuration file $configfile!!!\n";
while (my $line=<CONFIG>) {
   chomp $line;
   my $line2=$line;
   next if ($line =~ /^#/gm);
   next if !($line =~ /\S/gm);
   my @array=split(/\s+/,$line2);
   my $arraylen=scalar(@array);
   next if ($array[0] eq "Parameter");
   die "ERROR! $arraylen columns parsed where only 2 columns expected!!!\n" if ($arraylen != 2);
   $countconfigline++;
   if (!exists $config{$array[0]}) {
      $config{$array[0]}=$array[1];
   }else {
      $config{$array[0]}=$config{$array[0]}."::".$array[1];
   }
   print STDERR "$countconfigline   $array[0]    \t$array[1]\n";
}
my $numparam=scalar(keys(%config));
print STDERR ">>> Configuration file parsed... $numparam parameter(s) stored...\n\n";

##### Get Parameters #####
my $calcscript = $config{"ANIcalculator_Script"};
my $dbdir = $config{"DB_directory"};
my $outputfile = $config{"Output_File"};
my $set1genomes = $config{"Set1Genome"};
my $set2genomes = $config{"Set2Genome"};


##### Gather set1 and set2 files #####
print STDERR ">>> Gathering input files...\n";
my @set1genomes=split(/\:\:/,$set1genomes);
my @set2genomes=split(/\:\:/,$set2genomes);
my @set1files=();
my @set2files=();
my $countinfiles=0;
foreach my $set1regex (@set1genomes) {
   print STDERR "Set1: $set1regex\n";
   my $countfound1=0;
   foreach my $file (glob "$dbdir/*") {
      if ($file =~ /$set1regex/gm) {
         print STDERR "   Found: $file\n";
	 push(@set1files,$file);
	 $countinfiles++;
	 $countfound1++;
      }
   }
   print STDERR "   No Files Found\n" if ($countfound1==0);
}
foreach my $set2regex (@set2genomes) {
   print STDERR "Set2: $set2regex\n";
   my $countfound2=0;
   foreach my $file (glob "$dbdir/*") {
      if ($file =~ /$set2regex/gm) {
         print STDERR "   Found: $file\n";
	 push(@set2files,$file);
	 $countinfiles++;
	 $countfound2++;
      }
   }
   print STDERR "   No Files Found\n" if ($countfound2==0);
}
print STDERR ">>> $countinfiles input files gathered...\n\n";

##### Run comparisons #####
print STDERR ">>> Running comparisons...\n";
my $countcomp=0;
my $randnum=int(rand(1000000));
my $tempdir="tempdir".$randnum;
system("mkdir $tempdir");
system("rm -r ani.blast.dir") if (-e "ani.blast.dir");
foreach my $file1 (@set1files) {
   foreach my $file2 (@set2files) {
      system("cp $file1 $tempdir");
      system("cp $file2 $tempdir");
   }
}
system("gunzip $tempdir/*");
foreach my $file1 (@set1files) {
   foreach my $file2 (@set2files) {
      $countcomp++;
      $file1=~s/^\S+\//$tempdir\//gm;
      $file1=~s/.gz$//gm;
      $file2=~s/^\S+\//$tempdir\//gm;
      $file2=~s/.gz$//gm;
      my $randnum2=int(rand(1000000));
      my $tempoutfile="outfile.ANIcalculator.$randnum2";
      my $templogfile="logfile.ANIcalculator.$randnum2";
      my $cmd1="$calcscript -genome1fna $file1 -genome2fna $file2 -outfile $tempoutfile > tmplog.txt";
      print STDERR "Running comparison $countcomp\n";
      system($cmd1);

      if ($countcomp==1) {
	 system("cp $tempoutfile $outputfile");
      }else {
         system("grep -v \"GENOME1\\sGENOME2\" $tempoutfile \>\> $outputfile");
      }	      
      system("rm $tempoutfile");
      system("rm ANIcalculator.log");
   }
}
system("rm -r $tempdir");
system("rm tmplog.txt");
print STDERR ">>> Ran $countcomp comparisons... Result written to $outputfile...\n";





#unless (open(LOGFILE, ">$logfile")){
#   print STDERR "Cannot open file \"$logfile\" to write to!!\n\n";
#   exit;
#}





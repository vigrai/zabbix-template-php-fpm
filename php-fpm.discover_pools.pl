#!/usr/bin/perl
 
$first = 1;
 
print "{\n";
print "\t\"data\":[\n\n";

my $cmd = 'ps ax |grep "php-fpm: pool " |grep -v grep|awk \'{print $NF}\' |sort -u';

foreach $pool (`$cmd`)
{
    print "\t,\n" if not $first;
    $first = 0;
    chomp $pool;
 
    print "\t{\n";
    print "\t\t\"{#POOLNAME}\":\"$pool\"\n";
    print "\t}\n";
}
 
print "\n\t]\n";
print "}\n";

#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

die <<USAGE

Usage: ./chheader.pl /path/to/file.fq <search> <replace> > outfile.fq
	instead of <search>, specify what you want to erase (regex enabled)
	instead of <replace>, specify what you want to replace it with (regex enabled)
	If you want to append a string to the end of fastq headers, type "noreplace" instead of <search>
	works on gzipped files
	If you want to append a string that starts with whitespace, or you want to replace something with whitespace, put your <replace> in double quotes, e.g. " foobar" or " "
USAGE

unless scalar(@ARGV) == 3;

my $filename = shift;
my $search = shift;
my $replace = shift;
my $i = 4;
my $filehandle;

if ($filename =~ /gz$/) {
	open $filehandle, "gunzip -dc $filename |" or die $!;
}
else {
	open $filehandle, "<$filename" or die $!;
}

while (<$filehandle>) {

	if ($i % 4 == 0) {
		if ($search =~ /noreplace/) {
			chomp $_;
			$_ .= $replace;
			print $_, "\n";
		}
		else {
			if (/$search/) {
				$_ =~ s/$search/$replace/;
				print;
			}
		}
	}
	else {
		print $_;
	}
	$i++;
}

close $filehandle;

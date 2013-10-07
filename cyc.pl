#!/usr/bin/perl
#
#  cyc.pl
#  
#  Copyright 2012-2013 Francesco Ruvolo <ruvolof@gmail.com>
#  
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.

use strict;
use warnings;
use File::Find;
use Getopt::Long;

my $PROGNAME = 'Count Your Code';
my $VERSION = '1.0';
my $AUTHOR = 'Francesco Ruvolo <ruvolof@gmail.com>';

my $do_stats = undef;

my $version = sub {
	print "$PROGNAME $VERSION - $AUTHOR\n";
	exit 0;
};

my $help = sub {
	print "Usage: cyc <options> <DIRECTORIES_LIST> <FILES_LIST>\n";
	print "Available options:\n";
	print "\t-h, --help\tPrint this help and exit.\n";
	print "\t--stats\t\tPrint detailed stats about programming languages.\n";
	print "\t--version\tPrint version.\n";
	exit 0;
};

my $ret = GetOptions ( "version" => $version,
					   "h|help" => $help,
					   "stats" => \$do_stats );

# Source file valid for stats
my %extension = (
	# Bash
	sh => 'Bash/Sh',
	bash => 'Bash/Sh',
	
	# C Family
	h => 'C/C++ Header',
	hh => 'C++ Header',
	c  => 'C',
	cc => 'C++',
	cpp => 'C++',
	
	# CSS
	css => 'CSS',

	# Perl
	pl => 'Perl',
	pm => 'Perl Module',
	pod => 'Perl Documentation',
	
	# PHP
	php => 'PHP',
	
	# Python
	py => 'Python',
	
	# Java
	java => 'Java',
	
	# Javascript
	js => 'Javascript',
	
	# General Markup
	xml => 'XML',
	htm => 'HTML',
	html => 'HTML',
	md => 'Markdown',
	markdown => 'Markdown',
	
	# Others
	txt => 'Plain Text',
	);

my %code_stats;

my $unknown = '';

# Variable where lines are counted.
my $code_lines = 0;

my $count_lines = sub {
	if (-f $_) {
		my ($file_extension) = $_ =~ /^.*\.([a-zA-Z0-9]+)$/i;
		if (defined $file_extension) {
			if (exists $extension{$file_extension}){
				my $lines = `wc -l "$_" | cut -d' ' -f1`;
				chomp($lines);
				$code_lines += $lines;
				
				if (defined $do_stats) {
					$code_stats{$extension{$file_extension}} += $lines;
				}
			}
			else {
				if ($unknown !~ m/\b$file_extension\b/) {
					$unknown = join(' ', $unknown, $file_extension);
				}
			}
		}
	}
};

foreach my $argument (@ARGV) {
	find( { wanted => $count_lines }, $argument );
}

print 'Total: ' . $code_lines . "\n";

if (defined $do_stats) {
	# Ordering the hash by values
	my @ordered = sort { $code_stats{$b} <=> $code_stats{$a} } keys %code_stats;
	
	print "\nCode stats:\n";
	foreach my $lang (@ordered) {
		print "$lang: $code_stats{$lang}\n";
	}
	print "Unkown extension: $unknown\n" if $unknown;
}

exit 0;

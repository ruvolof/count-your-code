#!/usr/bin/perl
#
#  cyc.pl
#  
#  Copyright 2012 Francesco Ruvolo <ruvolof@gmail.com>
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

my $do_stats = undef;

my $ret = GetOptions ( "stats" => \$do_stats );

# Source file valid for stats
my %extension = (
	sh => 'Bash/Sh',
	c  => 'C',
	pl => 'Perl',
	pm => 'Perl Module',
	);

my %code_stats;

# Variable where lines are counted.
my $code_lines = 0;

my $count_lines = sub {
	if (-f $_) {
		my ($file_extension) = $_ =~ /^.*\.([a-zA-Z0-9]+)$/i;
		if (defined $file_extension) {
			if (exists $extension{$file_extension}){
				my $lines = `wc -l $_ | cut -d' ' -f1`;
				chomp($lines);
				$code_lines += $lines;
				
				if (defined $do_stats) {
					if (exists $extension{$file_extension} ) {
						$code_stats{$file_extension} += $lines;
					}
				}
			}
		}
	}
};

foreach my $argument (@ARGV) {
	find( { wanted => $count_lines }, $argument );
}

print $code_lines . "\n";

if (defined $do_stats) {
	print "Code stats:\n";
	foreach my $lang (sort keys %code_stats) {
		print "$extension{$lang}: $code_stats{$lang}\n";
	}
}

exit 0;

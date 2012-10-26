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

my $extension = {
	'.sh' => 'Bash/Sh',
	'.c'  => 'C',
	'.pl' => 'Perl',
	'.pm' => 'Perl Module',
	};

my $code_lines = 0;

my $count_lines = sub {
	if (-f $_) {
		my $lines = `wc -l $_ | cut -d' ' -f1`;
		chomp($lines);
		$code_lines += $lines;
	}
};

foreach my $argument (@ARGV) {
	find( { wanted => $count_lines }, $argument );
}

print $code_lines . "\n";

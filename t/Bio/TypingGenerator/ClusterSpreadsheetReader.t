#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;
use File::Slurp::Tiny qw(read_file write_file);

BEGIN { unshift( @INC, './lib' ) }

BEGIN {
    use Test::Most;
    use_ok('Bio::TypingGenerator::ClusterSpreadsheetReader');
}

my $obj;
ok($obj = Bio::TypingGenerator::ClusterSpreadsheetReader->new(filename => 't/data/clusters_spreadsheet.csv', sample_name_column => 0) , 'initialise clusters spreadsheet');

is_deeply($obj->samples_to_clusters, {
          'seq6' => '3',
          'seq3' => '2',
          'seq7' => '3',
          'seq9' => '4',
          'seq10' => '4',
          'seq2' => '1',
          'seq8' => '3',
          'seq1' => '1',
          'seq4' => '2',
          'seq5' => '2'
        }, 'samples to clusters');

is_deeply($obj->clusters_to_samples, {
          '4' => [
                   'seq9',
                   'seq10'
                 ],
          '1' => [
                   'seq1',
                   'seq2'
                 ],
          '3' => [
                   'seq6',
                   'seq7',
                   'seq8'
                 ],
          '2' => [
                   'seq3',
                   'seq4',
                   'seq5'
                 ]
        }, 'clusters to samples	');


done_testing();

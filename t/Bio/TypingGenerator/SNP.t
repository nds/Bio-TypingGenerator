#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;
use File::Slurp::Tiny qw(read_file write_file);

BEGIN { unshift( @INC, './lib' ) }

BEGIN {
    use Test::Most;
    use_ok('Bio::TypingGenerator::SNP');
}

my $obj;
my @columns_to_samples =  qw(seq1	seq2	seq3	seq4	seq5	seq6	seq7	seq8	seq9	seq10);
ok($obj = Bio::TypingGenerator::SNP->new(
   vcf_line            => "1	3	.	A	C	.	.	AB	.	.	.	C	C	C	.	.	.	.	.", 
   columns_to_samples  => \@columns_to_samples, 
   samples_to_clusters => {
          'seq6'  => '3',
          'seq3'  => '2',
          'seq7'  => '3',
          'seq9'  => '4',
          'seq10' => '4',
          'seq2'  => '1',
          'seq8'  => '3',
          'seq1'  => '1',
          'seq4'  => '2',
          'seq5'  => '2'
        }) 
, 'initialise a SNP');
is($obj->coordinate, 3, 'get the coordinate of the SNP');
is_deeply($obj->variation_samples_to_clusters, {'seq4' => '2','seq3' => '2','seq5' => '2'},  'variation samples to clusters');
is_deeply($obj->reference_samples_to_clusters, {          
    'seq6'  => '3',
    'seq7'  => '3',
    'seq9'  => '4',
    'seq10' => '4',
    'seq2'  => '1',
    'seq8'  => '3',
    'seq1'  => '1'
},  'reference samples to clusters');
is_deeply(sort $obj->variation_clusters, [2], 'variation clusters');
is_deeply(sort $obj->reference_clusters, [1,3,4], 'reference clusters');



done_testing();

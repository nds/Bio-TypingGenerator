#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;
use File::Slurp::Tiny qw(read_file write_file);

BEGIN { unshift( @INC, './lib' ) }

BEGIN {
    use Test::Most;
    use_ok('Bio::TypingGenerator::SNPClusterAnalysis');
}

my $obj;
ok($obj = Bio::TypingGenerator::SNPClusterAnalysis->new(multifasta => 't/data/multifasta.aln', clusters_spreadsheet => 't/data/clusters_spreadsheet.csv',sample_name_column => 0),'Initialise object');
is_deeply($obj->snps_to_unique_clusters, {3 => 2, 6 => 1, 10 => 2},'snps which uniquely define a cluster');


my $obj_one_snp;
ok($obj_one_snp = Bio::TypingGenerator::SNPClusterAnalysis->new(multifasta => 't/data/one_snp.aln', clusters_spreadsheet => 't/data/clusters_spreadsheet.csv',sample_name_column => 0),'Initialise object');
is_deeply($obj_one_snp->snps_to_unique_clusters,{ 1 => 1},'snps which uniquely define a cluster');

done_testing();

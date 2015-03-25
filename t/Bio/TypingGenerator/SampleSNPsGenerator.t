#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;
use File::Slurp::Tiny qw(read_file write_file);

BEGIN { unshift( @INC, './lib' ) }

BEGIN {
    use Test::Most;
    use_ok('Bio::TypingGenerator::SampleSNPsGenerator');
}

my $obj;
ok($obj = Bio::TypingGenerator::SampleSNPsGenerator->new(filename => 't/data/multifasta.aln', samples_to_clusters => {
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
        }) , 'initialise multifasta file');
ok($obj->_run_snp_sites, 'run snp_sites');

my $header_line = "#CHROM	POS	ID	REF	ALT	QUAL	FILTER	INFO	FORMAT	seq1	seq2	seq3	seq4	seq5	seq6	seq7	seq8	seq9	seq10";
is_deeply($obj->_parse_column_headings($header_line), ['seq1','seq2','seq3','seq4','seq5','seq6','seq7','seq8','seq9','seq10'], 'sample names pulled out of header name');

is_deeply($obj->columns_to_samples, [
            'seq1',
            'seq2',
            'seq3',
            'seq4',
            'seq5',
            'seq6',
            'seq7',
            'seq8',
            'seq9',
            'seq10'
          ],'Columns to sample names');
is_deeply($obj->samples_to_columns, {
          'seq6' => 5,
          'seq3' => 2,
          'seq7' => 6,
          'seq9' => 8,
          'seq10' => 9,
          'seq2' => 1,
          'seq8' => 7,
          'seq1' => 0,
          'seq4' => 3,
          'seq5' => 4
        },'Sample names to column index');
ok($obj->parse_vcf, 'parse the vcf output');


done_testing();

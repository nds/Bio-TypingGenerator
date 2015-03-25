package Bio::TypingGenerator::SampleSNPsGenerator;

# ABSTRACT: Take in a multifasta file and get the snps from the snp_sites VCF

=head1 SYNOPSIS

Find defining snps

=cut

use Moose;
use Text::CSV;
use Bio::TypingGenerator::SNP;
use Bio::TypingGenerator::Exceptions;
use File::Temp;

has 'filename'     => ( is => 'rw', isa => 'Str', required => 1 );
has 'exec'         => ( is => 'rw', isa => 'Str', default => 'snp_sites' );
has 'samples_to_clusters'        => ( is => 'rw', isa => 'HashRef', required =>1 );

has 'columns_to_samples'         => ( is => 'rw', isa => 'ArrayRef' );
has 'samples_to_columns'         => ( is => 'rw', isa => 'HashRef' );
has 'snps'                       => ( is => 'rw', isa => 'ArrayRef[Bio::TypingGenerator::SNP]', default => sub {[]} );

has '_tmp_vcf_file_obj'          => ( is => 'rw', isa => 'File::Temp',lazy => 1, builder => '_build__tmp_vcf_file_obj');
has '_vcf_filename'              => ( is => 'rw', isa => 'Str',lazy => 1, builder => '_build__vcf_filename');

sub BUILD {
    my ($self) = @_;
	$self->_run_snp_sites;
    $self->parse_vcf;
}

sub _build__tmp_vcf_file_obj
{
  my($self) = @_;
  return File::Temp->new(CLEANUP => 0);
}
sub  _build__vcf_filename
{
	my($self) = @_;
	return $self->_tmp_vcf_file_obj->filename;
}

sub _run_snp_sites
{
	my($self) = @_;
	my $cmd = $self->exec." -v -o ".$self->_vcf_filename." ".$self->filename;
	system($cmd);
	return 1;
}

sub parse_vcf
{
	my($self) = @_;
	open(my $infh, $self->_vcf_filename ) or Bio::TypingGenerator::Exceptions::FileNotFound->throw(error => "Couldnt open the intermediate VCF file");
	while(<$infh>)
	{   
		chomp();
		my $line = $_;
		
		if($line  =~ /\#CHROM/)
		{
			my $columns_to_samples  = $self->_parse_column_headings($line);
			my %samples_to_columns;
			for(my $i =0; $i < @{$columns_to_samples}; $i++)
			{
			   $samples_to_columns{$columns_to_samples->[$i]} = $i;
			}
			$self->columns_to_samples($columns_to_samples);
			$self->samples_to_columns(\%samples_to_columns);
			next;
		}
		next if($line  =~ /^\#/);

		push(@{$self->snps}, Bio::TypingGenerator::SNP->new(vcf_line =>$line, columns_to_samples =>$self->columns_to_samples, samples_to_clusters => $self->samples_to_clusters));
	}
	
	
	return $self;
}

sub _parse_column_headings
{
	my($self,$line) = @_;
	#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\tFORMAT
	my @headings = split(/\t/,$line);
	
	my @columns_to_samples;
	for(my $i =9; $i< @headings; $i++ )
	{
		$columns_to_samples[$i-9] = $headings[$i];
	} 
	return \@columns_to_samples;
}


no Moose;
__PACKAGE__->meta->make_immutable;

1;

package Bio::TypingGenerator::SNPClusterAnalysis;

# ABSTRACT: Represents a single SNP

=head1 SYNOPSIS

Find defining snps

=cut

use Moose;
use Bio::TypingGenerator::ClusterSpreadsheetReader;
use Bio::TypingGenerator::SampleSNPsGenerator;

has 'multifasta'           => ( is => 'rw', isa => 'Str', required => 1 );
has 'clusters_spreadsheet' => ( is => 'rw', isa => 'Str', required => 1 );
has 'clusters_column'         => ( is => 'rw', isa => 'Int', default => 2 );
has 'sample_name_column'      => ( is => 'rw', isa => 'Int', default => 1 );

has '_cluster_spreadsheet_reader' => ( is => 'rw', isa => 'Bio::TypingGenerator::ClusterSpreadsheetReader', lazy => 1, builder => '_build__cluster_spreadsheet_reader' );
has '_sample_snps_generator'      => ( is => 'rw', isa => 'Bio::TypingGenerator::SampleSNPsGenerator', lazy => 1, builder => '_build__sample_snps_generator' );

sub _build__cluster_spreadsheet_reader
{
	my($self) = @_;
	return Bio::TypingGenerator::ClusterSpreadsheetReader->new(filename => $self->clusters_spreadsheet, clusters_column => $self->clusters_column,sample_name_column => $self->sample_name_column);
}

sub _build__sample_snps_generator
{
	my($self) = @_;
	return Bio::TypingGenerator::SampleSNPsGenerator->new(filename => $self->multifasta,samples_to_clusters => $self->_cluster_spreadsheet_reader->samples_to_clusters);
}

sub snps_to_unique_clusters
{
	my($self) = @_;
	
	my %snp_to_cluster;
	for my $snp (@{$self->_sample_snps_generator->snps})
	{
		if(my $cluster_id = $snp->unique_cluster)
		{
			$snp_to_cluster{$snp->coordinate} = $cluster_id;
		}
	}
	return \%snp_to_cluster;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;

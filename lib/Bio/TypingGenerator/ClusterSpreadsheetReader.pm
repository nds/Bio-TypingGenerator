package Bio::TypingGenerator::ClusterSpreadsheetReader;

# ABSTRACT: Find defining snps

=head1 SYNOPSIS

Find defining snps

=cut

use Moose;
use Text::CSV;

has 'filename'                => ( is => 'rw', isa => 'Str', required => 1 );
has 'clusters_column'         => ( is => 'rw', isa => 'Int', default => 2 );
has 'sample_name_column'      => ( is => 'rw', isa => 'Int', default => 1 );

has 'clusters_to_samples'    => ( is => 'ro', isa => 'HashRef',  lazy => 1, builder => '_build_clusters_to_samples' );
has 'samples_to_clusters'    => ( is => 'rw', isa => 'HashRef', default => sub{{}} );
has '_csv_parser'             => ( is => 'ro', isa  => 'Text::CSV',lazy     => 1, builder => '_build__csv_parser' );
has '_input_spreadsheet_fh'   => ( is => 'ro', lazy => 1,          builder  => '_build__input_spreadsheet_fh' );


sub BUILD {
    my ($self) = @_;
    $self->clusters_to_samples;
}


sub _build_clusters_to_samples
{
	my($self) = @_;
	my %clusters_to_samples;
	my %samples_to_clusters;
	my $header = $self->_csv_parser->getline( $self->_input_spreadsheet_fh );
	
    while ( my $row = $self->_csv_parser->getline( $self->_input_spreadsheet_fh ) ) 
    {
		my $sample_name = $row->[$self->sample_name_column];
		my $cluster = $row->[$self->clusters_column];
		
		$samples_to_clusters{$sample_name} = $cluster ;

		if(!defined($clusters_to_samples{$cluster}))
		{
			$clusters_to_samples{$cluster} = [];
		}

	    push($clusters_to_samples{$cluster}, $sample_name);

	}
	$self->samples_to_clusters(\%samples_to_clusters);
	return \%clusters_to_samples;
}


sub _build__input_spreadsheet_fh {
    my ($self) = @_;
    open( my $fh, $self->filename );
    return $fh;
}

sub _build__csv_parser
{
  my ($self) = @_;
  return Text::CSV->new( { binary => 1, always_quote => 1} );
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;

package Bio::TypingGenerator::CommandLine::ClusterDefiningSNPs;

# ABSTRACT: Get a list of cluster defining SNPs

=head1 SYNOPSIS

Get a list of cluster defining SNPs

=cut

use Moose;
use Getopt::Long qw(GetOptionsFromArray);
use Bio::TypingGenerator::ExtractSNPs;

has 'args'        => ( is => 'rw', isa => 'ArrayRef', required => 1 );
has 'script_name' => ( is => 'ro', isa => 'Str',      required => 1 );
has 'help'        => ( is => 'rw', isa => 'Bool',     default  => 0 );

has 'multifasta'           => ( is => 'rw', isa => 'Str' );
has 'clusters_spreadsheet' => ( is => 'rw', isa => 'Str' );

has '_error_message' => ( is => 'rw', isa => 'Str' );

sub BUILD {
    my ($self) = @_;

    my ( $multifasta, $clusters_spreadsheet, $help );

    GetOptionsFromArray(
        $self->args,
        'i|multifasta=s'           => \$multifasta,
        's|clusters_spreadsheet=s' => \$clusters_spreadsheet,
        'h|help'                   => \$help,
    );

    $self->help($help) if(defined($help));
    
    $self->multifasta($multifasta)                     if ( defined($multifasta) );
    $self->clusters_spreadsheet($clusters_spreadsheet) if ( defined($) );
}

sub run {
    my ($self) = @_;

    ( !$self->help ) or die $self->usage_text;
    if ( ! -e $self->multifasta ) {
        die $self->usage_text;
    }
    
	my $obj = Bio::TypingGenerator::ExtractSNPs->new(multifasta => $self->multifasta, clusters_spreadsheet => $self->clusters_spreadsheet);
    $obj->run();
}



sub usage_text {
    my ($self) = @_;

    return <<USAGE;
    Usage: cluster_defining_snps [options]
    Get a list of cluster defining SNPs from a multifasta alignment and a spreadsheet of BAPs clusters

    cluster_defining_snps -i multfasta.aln -s spreadsheet.csv

    # This help message
    cluster_defining_snps -h

USAGE
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;
package Bio::TypingGenerator::Exceptions;
# ABSTRACT: Exceptions for input data 

=head1 SYNOPSIS

Exceptions for input data 

=cut


use Exception::Class (
    Bio::TypingGenerator::Exceptions::FileNotFound   => { description => 'Couldnt open the file' },
);  

1;

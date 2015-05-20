package Information;
use Moose;
use MooseX::ABC;
use namespace::autoclean;


has 'title' => (is => 'ro', isa => 'Str', required => '1');
has 'desc' => (is => 'ro', isa => 'Str', required => '0');

__PACKAGE__->meta->make_immutable;

1;

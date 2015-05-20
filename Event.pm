package Event;
use Moose;
use namespace::autoclean;


extends 'Information';
has 'participants' => (is => 'ro', isa => 'ArrayRef[Citizen]',required => '0');
 1;

__PACKAGE__->meta->make_immutable;

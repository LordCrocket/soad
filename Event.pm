package Event;
use Moose;
use namespace::autoclean;
use MooseX::StrictConstructor;


extends 'Information';
has 'participants' => (is => 'ro', isa => 'ArrayRef[Citizen]',required => '0');

use overload '""' => "to_string", fallback => 1;

sub to_string {
	(my $self) = @_;
	return $self->id . " (Event) " .$self->title . " Participants: " . join (', ',@{$self->participants});
}



__PACKAGE__->meta->make_immutable;
 1;

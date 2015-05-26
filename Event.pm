package Event;
use Moose;
use namespace::autoclean;


extends 'Information';
has 'participants' => (is => 'ro', isa => 'ArrayRef[Citizen]',required => '0');

use overload '""' => "to_string", fallback => 1;

sub to_string {
	my $self = shift;
	my $string_rep = "(Event) ".$self->title . " Participants: " . join (', ',@{$self->participants});
	return $string_rep;
}

__PACKAGE__->meta->make_immutable;
 1;

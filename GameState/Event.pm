package GameState::Event;
use Moose;
use namespace::autoclean;
use MooseX::StrictConstructor;

with 'GameState::Participation';

extends 'GameState::Information';
has 'participants' => (is => 'ro', isa => 'ArrayRef[GameState::Citizen]',required => '0');

use overload '""' => "to_string", fallback => 1;

sub to_string {
	(my $self) = @_;
	return $self->id . " (Event) " .$self->title . " Participants: " . join (', ',@{$self->participants});
}
sub get_participants {
	(my $self) = @_;
	return wantarray ? @{$self->participants} : $self->participants
}




__PACKAGE__->meta->make_immutable;
 1;

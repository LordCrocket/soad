package Player;
use Moose;

has 'known_information' => (
	is  => 'rw',
	isa => 'ArrayRef[Information]',
	);
has 'known_citizen' => (
	is  => 'rw',
	isa => 'ArrayRef[Citizen]',
	);
1;

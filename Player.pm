package Player;
use Moose;
use MooseX::StrictConstructor;
use namespace::autoclean;
use Log::Log4perl;

my $logger = Log::Log4perl->get_logger('player');

has '_known_information' => (
	is  => 'ro',
	isa => 'ArrayRef[Information]',
	init_arg => undef,
	default => sub {[]},
	);
has '_known_citizen' => (
	is  => 'ro',
	isa => 'ArrayRef[Citizen]',
	init_arg => undef,
	default => sub {[]},
	);

sub add_know_citizen {
	(my $self,my $citizen) = @_;
	push(@{$self->_known_citizen},$citizen);
	$logger->debug("Player: " .$self." now knows " . $citizen);
}

__PACKAGE__->meta->make_immutable;
1;

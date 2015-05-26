package GameState;
use Moose;
use MooseX::StrictConstructor;
use namespace::autoclean;

my $logger = Log::Log4perl->get_logger('gamestate');

has '_players' => (
	is  => 'ro',
	isa => 'ArrayRef[Player]',
	init_arg => undef,
	default => sub {[]}
	);
has '_citizens' => (
	is  => 'ro',
	isa => 'ArrayRef[Citizen]',
	init_arg => undef,
	default => sub {[]}
	);

sub add_player {
	(my $self,my $player) = @_;
	push(@{$self->_players},$player);
	$logger->debug("Player: " . $player  . " was added to " . $self);
}

__PACKAGE__->meta->make_immutable;
1;

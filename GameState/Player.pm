package GameState::Player;
use Moose;
use MooseX::StrictConstructor;
use MooseX::ClassAttribute;
use namespace::autoclean;
use Log::Log4perl;

my $logger = Log::Log4perl->get_logger('player');

use overload '""' => "to_string", fallback => 1;

class_has 'counter' => (
      traits  => ['Counter'],
      is      => 'ro',
      isa     => 'Int',
      default => 0,
      handles => {
          inc_counter   => 'inc',
          dec_counter   => 'dec',
          reset_counter => 'reset',
      },
  );
has 'id' => (is => 'ro', isa => 'Int',required => '0',default => sub { return GameState::Player->inc_counter;});
has '_known_information' => (
	is  => 'ro',
	isa => 'ArrayRef[GameState::Information]',
	traits  => ['Array'],
	init_arg => undef,
	default => sub {[]},
	handles => {
		_add_known_information  => 'push'
	}
);

has '_known_citizen' => (
	is  => 'ro',
	isa => 'ArrayRef[GameState::Citizen]',
	traits  => ['Array'],
	init_arg => undef,
	default => sub {[]},

	handles => {
		_add_known_citizen  => 'push'
	}
);

sub add_know_citizen {
	(my $self,my $citizen) = @_;
	$self->_add_known_citizen($citizen);
	$logger->debug("Player: " .$self." now knows " . $citizen);
}
sub to_string {
	(my $self) = @_;
	return $self->id;
}

__PACKAGE__->meta->make_immutable;
1;

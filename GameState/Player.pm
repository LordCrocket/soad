package GameState::Player;
use Moose;
use MooseX::StrictConstructor;
use MooseX::ClassAttribute;
use namespace::autoclean;
use Log::Log4perl;

my $logger = Log::Log4perl->get_logger('player');

use overload '""' => "to_string", fallback => 1;
use overload 'eq' => "_matching", fallback => 1;

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

has 'known_citizens' => (
	is  => 'ro',
	isa => 'ArrayRef[GameState::Citizen]',
	traits  => ['Array'],
	init_arg => undef,
	default => sub {[]},

	handles => {
		_push_known_citizen  => 'push'
	}
);

has 'choices' => (
	is  => 'ro',
	isa => 'ArrayRef[GameState::Choice]',
	traits  => ['Array'],
	init_arg => undef,
	default => sub {[]},

	handles => {
		_push_choice  => 'push'
	}
);

has 'agent' => (is => 'rw', isa => 'GameState::Citizen');

sub add_known_citizen {
	(my $self,my $citizen) = @_;
	$self->_push_known_citizen($citizen);
	$logger->debug("Player: " .$self." now knows " . $citizen);
}

sub add_choice {
	(my $self,my $choice) = @_;
	$self->_push_choice($choice);
	$logger->debug("Player: " .$self." now got choice " . $choice);

}
sub to_string {
	(my $self) = @_;
	return $self->id;
}

sub _matching {
	(my $self,my $other) = @_;
	#$logger->debug("Matching: " . $self . " " . $other);
	return $self->id eq $other->id;
}

__PACKAGE__->meta->make_immutable;
1;

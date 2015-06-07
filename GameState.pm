package GameState;
use Moose;
use MooseX::StrictConstructor;
use MooseX::ClassAttribute;
use namespace::autoclean;
use experimental 'smartmatch';
use Data::Dumper;

my $logger = Log::Log4perl->get_logger('gamestate');

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

has 'id' => (is => 'ro', isa => 'Int',required => '0',default => sub { return GameState->inc_counter;});
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
has '_information' => (
	is  => 'ro',
	isa => 'ArrayRef[Information]',
	init_arg => undef,
	default => sub {[]}
	);


sub add_player {
	(my $self,my $player) = @_;
	push(@{$self->_players},$player);
	$logger->debug("Player: " . $player  . " was added to " . $self);
}
sub add_citizen {
	(my $self,my $citizen) = @_;
	push(@{$self->_citizens},$citizen);
	$logger->debug("Citizen: " . $citizen  . " was added to " . $self);
}
sub add_information {
	(my $self,my $information) = @_;
	push(@{$self->_information},$information);
	$logger->debug("Information: " . $information  . " was added to " . $self);
}

sub _citizen_exists {
	(my $self,my $citizen) = @_;
	return $citizen ~~ $self->_citizens;
}

sub _information_exists {
	(my $self,my $information) = @_;
	return $information ~~ $self->_information;
}

sub learn {
	(my $self,my $citizen,my $information) = @_;
	if(not _citizen_exists($self,$citizen)){
		$logger->error("Citizen: " . $citizen  . " does not exits in: "  . $self);
	}
	elsif(not _information_exists($self,$information)){
		$logger->error("Information: " . $information  . " does not exits in: "  . $self);
	}
	else {
		$citizen->learn($information);
	}
}

sub add_known_citizen {
	(my $self,my $player,my $citizen) = @_;
	$player->add_known_citizen($citizen);
}

sub to_string {
	my $self = shift;
	return "Game: " . $self->id;
}

__PACKAGE__->meta->make_immutable;
1;
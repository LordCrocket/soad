package GameState;
use Moose;
use MooseX::StrictConstructor;
use Moose::Util::TypeConstraints;
use MooseX::ClassAttribute;
use experimental 'smartmatch';
use Data::Dumper;
use Storable qw(dclone);
use List::Util qw(first);
use GameState::Citizen;
use GameState::Player;
use GameState::Event;

use namespace::autoclean;

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
	isa => 'ArrayRef[GameState::Player]',
	traits  => ['Array'],
	init_arg => undef,
	default => sub {[]},
	handles => {
		_push_player  => 'push'
	}
);
has '_citizens' => (
	is  => 'ro',
	isa => 'ArrayRef[GameState::Citizen]',
	traits  => ['Array'],
	init_arg => undef,
	default => sub {[]},
	handles => {
		_push_citizen  => 'push'
	}
);
has '_information' => (
	is  => 'ro',
	isa => 'ArrayRef[GameState::Information]',
	traits => ['Array'],
	init_arg => undef,
	default => sub {[]},
	handles => {
		_push_information  => 'push'
	}
);

sub BUILD {
	(my $self) = @_;
	$logger->debug($self . " created"); 
}

sub add_player {
	(my $self) = @_;
	my $player = GameState::Player->new();
	$self->_push_player($player);
	$logger->debug("Player: " . $player  . " was added to " . $self);
}
sub add_citizen {
	(my $self,my $citizen_hash) = @_;
	my $citizen = GameState::Citizen->new($citizen_hash);	
	$self->_push_citizen($citizen);
	$logger->debug("Citizen: " . $citizen  . " was added to " . $self);
}

sub add_event {
	(my $self,my $title,my $citizens) = @_;
	my $event = GameState::Event->new(title => $title, participants => $self->_get_citizens_that_exists($citizens));
	$self->_add_information($event);
	return $event;
}

sub _get_citizens_that_exists {
	(my $self, my $potential_citizens) = @_;
	my @citizens = ();
	foreach my $citizen (@{$potential_citizens}){
		my $internal_citizen = $self->_get_citizen($citizen);
		if ($internal_citizen){
			push(@citizens,$internal_citizen);
		}
		else {
			$logger->warn("Citizen: " . $citizen . " does not exists in " . $self);
		}
	} 
	return \@citizens;
}

sub _add_information {
	(my $self,my $information) = @_;
	$self->_push_information($information);
	$logger->debug("Information: " . $information  . " was added to " . $self);
	if($information->does('GameState::Participation')){
		foreach my $participant ($information->get_participants()){
			$participant->learn($information);
		}

	}
}

sub get_information {
	(my $self,my $information) = @_;
	return first { $_ eq $information  } @{$self->_information};
}

sub get_citizens {
	(my $self) = @_;
	return dclone($self->_citizens); 
}
sub get_citizens_attribute_max {
	return GameState::Citizen->attribute_max;
}

sub get_citizens_attribute_min {
	return GameState::Citizen->attribute_min;
}

sub _citizen_exists {
        (my $self,my $citizen) = @_;
        return $citizen ~~ $self->_citizens;
}

sub _get_citizen {
        (my $self,my $citizen) = @_;
	return first { $_ eq $citizen  } @{$self->_citizens};
}

sub get_occupations {
	(my $self) = @_;
	return find_type_constraint('Occupation')->{values};
}

sub get_allegiances {
	(my $self) = @_;
	return find_type_constraint('Allegiance')->{values};
}

sub _information_exists {
	(my $self,my $information) = @_;
        return $information ~~ $self->_information;
}

sub learn {
	(my $self,my $citizen,my $information) = @_;
	my $internal_citizen = $self->_get_citizen($citizen);
	my $internal_information = $self->get_information($information);

	if(! $internal_citizen){
		$logger->warn("Citizen: " . $citizen  . " does not exits in: "  . $self);
	}
	elsif(! $internal_information){
		$logger->warn("Information: " . $information  . " does not exits in: "  . $self);
	}
	else {
		$internal_citizen->learn($information);
	}
}

sub add_allegiance {
	(my $self,my $citizen,my $allegiance) = @_;
	my $internal_citizen = $self->_get_citizen($citizen);
	if(! $internal_citizen){
		$logger->warn("Citizen: " . $citizen  . " does not exits in: "  . $self);
	}
	else {
		$internal_citizen->add_allegiance($allegiance);
	}
}

sub add_known_citizen {
	(my $self,my $player,my $citizen) = @_;
	$player->add_known_citizen($citizen);
}

sub to_string {
	(my $self) = @_;
	return "Game: " . $self->id;
}

__PACKAGE__->meta->make_immutable;
1;

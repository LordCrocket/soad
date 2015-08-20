package GameState;
use Moose;
use MooseX::StrictConstructor;
use Moose::Util::TypeConstraints;
use MooseX::ClassAttribute;
use experimental 'smartmatch';
use Data::Dumper;
use Storable qw(dclone);
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
	init_arg => undef,
	default => sub {[]}
	);
has '_citizens' => (
	is  => 'ro',
	isa => 'ArrayRef[GameState::Citizen]',
	init_arg => undef,
	default => sub {[]}
	);
has '_information' => (
	is  => 'ro',
	isa => 'ArrayRef[GameState::Information]',
	init_arg => undef,
	default => sub {[]}
	);

sub BUILD {
	(my $self) = @_;
	$logger->debug($self . " created"); 
}

sub add_player {
	(my $self) = @_;
	my $player = GameState::Player->new();
	push(@{$self->_players},$player);
	$logger->debug("Player: " . $player  . " was added to " . $self);
}
sub add_citizen {
	(my $self,my $citizen_hash) = @_;
	my $citizen = GameState::Citizen->new($citizen_hash);	
	push(@{$self->_citizens},$citizen);
	$logger->debug("Citizen: " . $citizen  . " was added to " . $self);
}

sub add_event {
	(my $self,my $title,my $citizens) = @_;
	my $event = GameState::Event->new(title => $title, participants => $citizens);
	$self->_add_information($event);
	return $event->id;
}

sub _add_information {
	(my $self,my $information) = @_;
	push(@{$self->_information},$information);
	$logger->debug("Information: " . $information  . " was added to " . $self);
	if($information->does('Participation')){
		foreach my $participant ($information->get_participants()){
			$participant->learn($information);
		}

	}
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

sub get_occupations {
	(my $self) = @_;
	return find_type_constraint('Occupation')->{values};
}

sub _information_exists {
	(my $self,my $information) = @_;
	return $information ~~ $self->_information;
}

sub learn {
	(my $self,my $citizen,my $information) = @_;
	if(not $self->_citizen_exists($citizen)){
		$logger->error("Citizen: " . $citizen  . " does not exits in: "  . $self);
	}
	elsif(not $self->_information_exists($information)){
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
	(my $self) = @_;
	return "Game: " . $self->id;
}

__PACKAGE__->meta->make_immutable;
1;
